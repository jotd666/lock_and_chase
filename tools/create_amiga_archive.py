import subprocess,os,glob,shutil,pathlib

progdir = pathlib.Path(os.path.abspath(os.path.join(os.path.dirname(__file__),os.pardir)))

gamename = "baddudes"
# JOTD path for cranker, adapt to whatever your path is :)
os.environ["PATH"] += os.pathsep+r"K:\progs\cli"

cmd_prefix = ["make","-f",str(progdir / "makefile.am")]

subprocess.check_call(cmd_prefix+["clean"],cwd=progdir / "src")

subprocess.check_call(cmd_prefix+["RELEASE_BUILD=1"],cwd=progdir / "src")
# create archive

outdir = progdir / f"{gamename}_HD"

if os.path.exists(outdir):
    shutil.rmtree(outdir)

outdir.mkdir(exist_ok=True)

for file in ["readme.md",f"{gamename}.slave"]:
    shutil.copy(progdir / file,outdir)

datadir = progdir / "data"
shutil.copy(progdir / "assets" / "amiga" / "BadDudesAGA.info",outdir)



# cleanup of log files in data dir that whdload creates
for x in datadir.glob("game_level_?"):
    os.remove(x)
for x in datadir.glob("level_?_24*"):
    os.remove(x)
for x in datadir.glob("sprite_ram*"):
    os.remove(x)
for x in datadir.glob("game_ending"):
    os.remove(x)

dataout = outdir / "data"
dataout.mkdir(exist_ok=True)

pack_data = True  # set to false to create unpacked distros (much faster)

for sourcefile in datadir.glob("*"):
    destfile = dataout / sourcefile.name
    # -= RNC ProPackED v1.8 [by Lab 313] (01/26/2021) =-
    with open(sourcefile,"rb") as f:
        header = f.read(3).decode(errors="ignore")
    if header=="RNC" or not pack_data or sourcefile.name == "baddudes":
        # already packed/do not pack
        print(f"Copying {destfile}...")
        shutil.copy(sourcefile,destfile)
    else:
        cmd = ["propack","p",str(sourcefile),str(destfile)]
        print(f"Packing {destfile}...")
        p = subprocess.run(cmd,check=False,stdout=subprocess.DEVNULL)
        if p.returncode:
            print(f"failed packing {destfile}")
            shutil.copy(sourcefile,destfile)



exename = gamename
#subprocess.run(["cranker_windows.exe","-f",str(datadir / exename),"-o",str(dataout / exename)],check=True,stdout=subprocess.DEVNULL)
# we can't really use cranker now, seems to crash at startup. Never mind!!
shutil.copy(datadir / exename,dataout / exename)
subprocess.run(cmd_prefix+["clean"],cwd=os.path.join(progdir,"src"))
