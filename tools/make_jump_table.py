# this script was used once to
# - tag the jump/jsr calls
# - name the jump tables and dump their contents as words in the end of the file

import pathlib

def process(asm_file,rom_file,offset,end_address):
    with open(asm_file) as f:
        asm_lines = f.readlines()

    with open(rom_file,"rb") as f:
        rom = f.read()


    size = 0x100

    # first pass: add "jump_table" tag
    for i,line in enumerate(asm_lines):
        if ("[A," in line or "[B," in line) and ("JMP" in line or "JSR" in line):
            if "[jump_table]" in line:
                pass
            else:
                line = line.strip() + "        ; [jump_table]\n"
                asm_lines[i] = line

    # second pass: find tag, then previous LDx instruction to get table address
    # create a label for table at the previous LDx instruction that matches the
    # index register (X,Y,U). Widely used in a lot of games, Konami but not just them.
    for i,line in enumerate(asm_lines):
        if "[jump_table]" in line:
            reg = line.split(",")[1][0]
            loadr = "LD"+reg
            dest = None
            for j in range(i-1,i-10,-1):
                other_line = asm_lines[j]
                if loadr in other_line:
                    start,dest = other_line.rsplit(None,maxsplit=1)
                    break
            if dest:
                if "table_" in dest:
                    # already processed, re-process
                    dest = dest.replace("table_","")
                try:
                    table_address = int(dest.strip('#$'),16)
                except ValueError:
                    print(f"no table {i}")
                    raise
                block = rom[table_address-offset:table_address-offset+size]
                label = f"table_{table_address:04x}"
                asm_lines[j] = f"{start}    #{label}\n"

                asm_lines.append(f"{label}:\n")
                for i in range(0,len(block),2):
                    a = block[i]*256 + block[i+1]
                    if offset > a or a >= end_address:
                        break
                    asm_lines.append(f"\tdc.w\t${a:04x}\t; ${table_address:04x}\n")
                    table_address += 2
            else:
                print(f"Could not find {loadr} matching {line}")

    with open(asm_file.stem + "_new.asm","w") as f:
        f.writelines(asm_lines)

process(pathlib.Path("../src/jailbreak_6809.asm"),"../assets/mame/rom.bin",offset=0x8000,end_address=0x10000)
