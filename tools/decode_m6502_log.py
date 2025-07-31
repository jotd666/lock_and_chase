import os,struct,re

# log has the registers, then "DEAD" in hex then ram and rom base addresses

with open(r"..\cpu_log","rb") as f:
    contents = f.read()
    contents = contents[:-8]
    dead_marker, = struct.unpack(">H",contents[-2:])

    if dead_marker != 0xDEAD:
        raise Exception("Corrupt CPU log, should end by 0xDEAD at offset -8")

pcs = set()
# generated using LOG_REGS
macro = """
    .macro    LOG_REGS    m6502pc
    move.w    sr,-(a7)
    move.l    a6,-(a7)
    move.l    log_ptr,a6
    move.w    #0x\m6502pc,(a6)+
    move.w    d0,(a6)+
    move.w    d1,(a6)+
    move.w    d2,(a6)+
    cmp.w    #0xCAFE,(a6)  | hitting the protection buffer
    jne        444f
    BREAKPOINT    "sub cpu log buffer full!"
444:
    move.w    #0xDEAD,(a6)+
    move.l    a6,log_ptr
    move.l    (a7)+,a6
    move.w    (a7)+,sr
    .endm

"""
len_block = 0

size = {"b":1,"w":2,"l":4}

for line in macro.splitlines():
    m = re.search ("move.([bwl]).*,\(a6\)",line)
    if m:
        s = m.group(1)
        len_block += size[s]

print("Block size = ",hex(len_block))

sorted_cmp = False
avoid_regs = []
regslist = list("axy")


def rework(name):
    regs[name] = decode_address(regs[name])

lst = []
for i in range(0,len(contents),len_block):
    chunk = contents[i:i+len_block]
    if len(chunk)<len_block:
        break
    regs=dict()
    regs["pc"],regs["a"],regs["x"],regs["y"],end = struct.unpack_from(">HHHHH",chunk)
    if end==0xCCCC:
        break
    pcs.add(regs["pc"])




    regstr = ["{}={:0{}X}".format(reg.upper(),regs[reg],2) for reg in regslist if reg not in avoid_regs]
    rest = ", ".join(regstr)

    out = f"{regs['pc']:04X}: {rest}\n"

    lst.append(out)

if sorted_cmp:
    lst.sort()

with open("amiga.tr","w") as f:
    f.writelines(lst)

# generated using log:     trace mame.tr,,noloop,{tracelog "A=%02X, X=%02X, Y=%02X, P=%02X ",a,x,y,p}
lst = []
print("reading MAME trace file...")
with open(r"K:\Emulation\MAME\mame.tr","r") as f:
    l = len("A=04, X=18, Y=FF, P=30 ")
    for line in f:
        m = re.match("A=(..), X=(..), Y=(..), P=..",line)
        if m:
            pc = line[l:l+4]
            regs = dict()
            if int(pc,16) in pcs:
                regs["a"],regs["x"],regs["y"] = m.groups()
                regstr = ["{}={}".format(reg.upper(),regs[reg]) for reg in regslist if reg not in avoid_regs]
                rest = ", ".join(regstr)
                lst.append(f"{pc}: {rest}\n")

if sorted_cmp:
    lst.sort()
print("writing filtered MAME trace file...")
with open("mame.tr","w") as fw:
    fw.writelines(lst)
