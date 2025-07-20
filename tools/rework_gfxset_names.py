import glob,os,re,pathlib

gfx_dir = "../assets/sheets"

for sn,ttype in ((1,"sprites"),(0,"tiles")):
    outdir = pathlib.Path(gfx_dir) / ttype
    outdir.mkdir(exist_ok=True)

    orig_name = f"gfx dev 0 set {sn} tiles * colors 16 pal *.png"
    for file in glob.glob(os.path.join(gfx_dir,orig_name)):
        new_name = re.sub(".* pal ","pal_",os.path.basename(file))
        os.rename(file,outdir / new_name)