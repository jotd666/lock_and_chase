from PIL import Image,ImageOps
import os,sys,bitplanelib

this_dir = os.path.dirname(os.path.abspath(__file__))

src_dir = os.path.join(this_dir,"..","..","src","amiga")

sprite_names = dict()

NB_TILES = 1024
NB_SPRITES = 256

TT_UNKNOWN = 0
TT_BOB = 1
TT_SPRITE = 2
TT_TILE = 3

dump_it = True
dump_dir = os.path.join(this_dir,"dumps")

if dump_it:
    if not os.path.exists(dump_dir):
        os.mkdir(dump_dir)
        with open(os.path.join(dump_dir,".gitignore"),"w") as f:
            f.write("*")


def dump_asm_bytes(*args,**kwargs):
    bitplanelib.dump_asm_bytes(*args,**kwargs,mit_format=True)


def ensure_empty(d):
    if os.path.exists(d):
        for f in os.listdir(d):
            os.remove(os.path.join(d,f))
    else:
        os.makedirs(d)

def load_tileset(image_name,side,tileset_name,used_tiles,dumpdir,dump=False,name_dict=None):

    if isinstance(image_name,str):
        full_image_path = os.path.join(this_dir,os.path.pardir,"sheets",image_name)
        tiles_1 = Image.open(full_image_path)
    else:
        tiles_1 = image_name
    nb_rows = tiles_1.size[1] // side
    nb_cols = tiles_1.size[0] // side


    tileset_1 = []

    if dump:
        dump_subdir = os.path.join(dumpdir,tileset_name)
        ensure_empty(dump_subdir)

    tile_number = 0
    palette = set()

    for j in range(nb_rows):
        for i in range(nb_cols):
            if tile_number in used_tiles:
                img = Image.new("RGB",(side,side))
                img.paste(tiles_1,(-i*side,-j*side))

                # only consider colors of used tiles
                palette.update(set(bitplanelib.palette_extract(img)))


                tileset_1.append(img)
                if dump:
                    img = ImageOps.scale(img,5,resample=Image.Resampling.NEAREST)
                    if name_dict:
                        name = name_dict.get(tile_number,"unknown")
                    else:
                        name = "unknown"

                    img.save(os.path.join(dump_subdir,f"{name}_{tile_number:03x}.png"))
            else:
                tileset_1.append(None)
            tile_number += 1


    return sorted(set(palette)),tileset_1




def paint_black(img,coords):
    for x,y in coords:
        img.putpixel((x,y),(0,0,0))

def change_color(img,color1,color2):
    rval = Image.new("RGB",img.size)
    for x in range(img.size[0]):
        for y in range(img.size[1]):
            p = img.getpixel((x,y))
            if p==color1:
                p = color2
            rval.putpixel((x,y),p)
    return rval


nb_planes = 3
nb_colors = 1<<nb_planes


sprite_names = {}
hw_sprite_table = set()

def add_sprite(values,name,is_hw_sprite=False):
    if isinstance(values,int):
        values = [values]
    for v in values:
        sprite_names[v] = name
    if is_hw_sprite:
        hw_sprite_table.update(values)

add_sprite(0x80,"blank")
add_sprite(0xb5,"points_100")
add_sprite(0xb6,"points_300")
add_sprite(0xB7,"points_1000")
add_sprite(0xB8,"points_2000")


add_sprite(range(0xA8,0xAC),"player_car")
add_sprite(range(0x81,0x8d),"player")
add_sprite(range(0x8d,0x90),"angry_cop")  # no hw sprites as there are 4 angry cops
add_sprite(range(0x90,0x96),"red_cop",True)  # okay for colored ones as only once instance
add_sprite(range(0x96,0x9c),"yellow_cop",True)
add_sprite(range(0x9c,0xa2),"blue_cop",True)
add_sprite(range(0xa2,0xa8),"green_cop",True)

sprites_path = os.path.join(this_dir,os.path.pardir,"sheets")

def remove_colors(imgname):
    img = Image.open(imgname)
    return img
    for x in range(img.size[0]):
        for y in range(img.size[1]):
            c = img.getpixel((x,y))
            if c in colors_to_remove:
                img.putpixel((x,y),(0,0,0))
    return img

#sprite_sheet_dict = {i:remove_colors(os.path.join(sprites_path,f"sprites_pal_{i:02x}.png")) for i in range(16)}


tile_palette = set()

def rset(a,b):
    return set(range(a,b))

used_tiles = rset(0,0x400)  # rset(0,0x6E) | rset(0xa0,0xF2) | rset(0x11C,0x120) | rset(0x200,0x380) | lost_tiles
tp,tile_set = load_tileset(os.path.join(sprites_path,"tiles.png"),8,"tiles",used_tiles,dump_dir,dump=dump_it,name_dict=None)


tile_palette.update(tp)
used_sprites = set(sprite_names)
sp,sprite_set = load_tileset(os.path.join(sprites_path,"sprites.png"),16,"sprites",used_sprites,dump_dir,dump=dump_it,name_dict=sprite_names)
tile_palette.update(sp)


full_palette = sorted(tile_palette)


# pad just in case we don't have 8 colors (but we have)
full_palette += (nb_colors-len(full_palette)) * [(0x10,0x20,0x30)]




plane_orientations = [("standard",lambda x:x),
("flip",ImageOps.flip),
("mirror",ImageOps.mirror),
("flip_mirror",lambda x:ImageOps.flip(ImageOps.mirror(x)))
]


def read_tileset(img_set,palette,plane_orientation_flags,tile_type,cache=None):
    next_cache_id = 1
    tile_table = []

    tile_entry = []
    for i,tile in enumerate(img_set):
        entry = dict()
        if tile_type == TT_TILE:
            pass
        else:
            if (i in hw_sprite_table) == (tile_type == TT_BOB):
                tile = None  # incompatible sprite type
        if tile:

            # check if tile_type is compatible with current tile

            for b,(plane_name,plane_func) in zip(plane_orientation_flags,plane_orientations):
                if b:

                    actual_nb_planes = nb_planes
                    wtile = plane_func(tile)

                    if tile_type == TT_BOB:
                        y_start,wtile = bitplanelib.autocrop_y(wtile)
                        height = wtile.size[1]
                        actual_nb_planes += 1
                        bitplane_data = bitplanelib.palette_image2raw(wtile,None,palette,generate_mask=True,blit_pad=True)
                    elif tile_type == TT_TILE:
                        height = 8    # doesn't matter
                        y_start = 0
                        bitplane_data = bitplanelib.palette_image2raw(wtile,None,palette)
                    elif tile_type == TT_SPRITE:
                        height = 16
                        y_start = 0
                        actual_nb_planes = 4
                        bitplane_plane_ids = bitplanelib.palette_image2attached_sprites(wtile,None,palette)

                    if tile_type != TT_SPRITE:
                        plane_size = len(bitplane_data) // actual_nb_planes
                        bitplane_plane_ids = []
                        for j in range(actual_nb_planes):
                            offset = j*plane_size
                            bitplane = bitplane_data[offset:offset+plane_size]

                            cache_id = cache.get(bitplane)
                            if cache_id is not None:
                                bitplane_plane_ids.append(cache_id)
                            else:
                                if any(bitplane):
                                    cache[bitplane] = next_cache_id
                                    bitplane_plane_ids.append(next_cache_id)
                                    next_cache_id += 1
                                else:
                                    bitplane_plane_ids.append(0)  # blank

                    entry[plane_name] = {"height":height,"y_start":y_start,"bitplanes":bitplane_plane_ids}


        tile_table.append(entry)

    return tile_table

tile_plane_cache = {}
tile_table = read_tileset(tile_set,full_palette,[True,False,False,False], tile_type=TT_TILE,cache=tile_plane_cache)

bob_plane_cache = {}
bob_table = read_tileset(sprite_set,full_palette,[True,False,True,False], tile_type=TT_BOB,cache=bob_plane_cache)

# force 16 colors for attached HW sprites
sprite_table = read_tileset(sprite_set,full_palette+full_palette,[True,False,True,False], tile_type=TT_SPRITE)

##background_plane_cache = {}
##background_table = read_tileset(background_set,background_palette,[True,False,False,False],cache=background_plane_cache, tile_type=TT_TILE)

with open(os.path.join(src_dir,"palette.68k"),"w") as f:
    f.write("playfield_palette:\n")
    bitplanelib.palette_dump(full_palette,f,bitplanelib.PALETTE_FORMAT_ASMGNU)
##    f.write("background_palette:\n")
##    bitplanelib.palette_dump(background_palette,f,bitplanelib.PALETTE_FORMAT_ASMGNU)

sprite_type_table = [TT_UNKNOWN]*NB_SPRITES
for k in sprite_names:
    sprite_type_table[k] = TT_SPRITE if k in hw_sprite_table else TT_BOB

with open(os.path.join(src_dir,"graphics.68k"),"w") as f:
    f.write("\t.global\tsprite_type_table\n")
    f.write("\t.global\tcharacter_table\n")
    f.write("\t.global\tbob_table\n")
    f.write("\t.global\tsprite_table\n")

    f.write("* 0: no sprite\n* 1: blitter object\n* 2: hardware sprite\n")
    f.write("sprite_type_table:\n")
    bitplanelib.dump_asm_bytes(sprite_type_table,f,True)

    f.write("character_table:\n")

    for i,tile_entry in enumerate(tile_table):
        f.write("\t.long\t")
        if tile_entry:
            f.write(f"tile_{i:03x}")
        else:
            f.write("0")
        f.write("\n")

    f.write("sprite_table:\n")

    for i,tile_entry in enumerate(sprite_table):
        f.write("\t.long\t")
        if tile_entry:
            prefix = sprite_names.get(i,"sprite")
            f.write(f"{prefix}_{i:03x}")
        else:
            f.write("0")
        f.write("\n")


    for i,tile_entry in enumerate(sprite_table):
        if tile_entry:
            prefix = sprite_names.get(i,"sprite")
            f.write(f"{prefix}_{i:03x}:\n")
            for orientation,_ in plane_orientations:
                f.write("\t.long\t")
                if orientation in tile_entry:
                    f.write(f"{prefix}_{i:03x}_{orientation}")
                else:
                    f.write("0")
                f.write("\n")

    for i,tile_entry in enumerate(tile_table):
        if tile_entry:
            name = f"tile_{i:03x}"

            f.write(f"{name}:\n")

            for bitplane_id in tile_entry["standard"]["bitplanes"]:
                f.write("\t.long\t")
                if bitplane_id:
                    f.write(f"tile_plane_{bitplane_id:02d}")
                else:
                    f.write("0")
                f.write("\n")

    for k,v in tile_plane_cache.items():
        f.write(f"tile_plane_{v:02d}:")
        dump_asm_bytes(k,f)

    f.write("bob_table:\n")
    for i,tile_entry in enumerate(bob_table):
        f.write("\t.long\t")
        if tile_entry:
            prefix = sprite_names.get(i,"bob")
            f.write(f"{prefix}_{i:02x}")
        else:
            f.write("0")
        f.write("\n")



##
    for i,tile_entry in enumerate(bob_table):
        if tile_entry:
            prefix = sprite_names.get(i,"bob")

            name = f"{prefix}_{i:02x}"

            f.write(f"{name}:\n")
            height = 0
            width = 4
            offset = 0
            for orientation,_ in plane_orientations:
                if orientation in tile_entry:
                    ot = tile_entry[orientation]

                    height = ot["height"]
                    offset = ot["y_start"]
                    break

            for orientation,_ in plane_orientations:
                f.write("* {}\n".format(orientation))
                f.write(f"\t.word\t{height},{width},{offset}\n")
                if orientation in tile_entry:
                    for bitplane_id in tile_entry[orientation]["bitplanes"]:
                        f.write("\t.long\t")
                        if bitplane_id:
                            f.write(f"bob_plane_{bitplane_id:02d}")
                        else:
                            f.write("0")
                        f.write("\n")

                else:
                    for _ in range(nb_planes+1):
                        f.write("\t.long\t0\n")

    f.write("\t.section\t.datachip\n")

    for k,v in bob_plane_cache.items():
        f.write(f"bob_plane_{v:02d}:")
        dump_asm_bytes(k,f)

    for i,tile_entry in enumerate(sprite_table):
        if tile_entry:
            prefix = sprite_names.get(i,"sprite")

            for orientation,_ in plane_orientations:
                if orientation in tile_entry:
                    f.write(f"{prefix}_{i:03x}_{orientation}:\n")
                    for j,hw_sprite_data in enumerate(tile_entry[orientation]["bitplanes"]):
                        f.write(f"* attach #{j} (each is 48 bytes)\n")
                        bitplanelib.dump_asm_bytes(hw_sprite_data,f,mit_format=True)



