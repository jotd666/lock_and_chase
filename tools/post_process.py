from shared import *

# post-conversion automatic patches, allowing not to change the asm file by hand



input_read_dict = {
"player_1_controls_9000":"read_inputs",
"dsw1_8000":"read_dsw1",
"dsw2_8001":"read_dsw2",
"system_9002":"read_system"
}

input_write_dict = {
"player_1_controls_9000":"",
"dsw1_8000":"",
"dsw2_8001":"video_control",
"system_9002":"",   # sound_start
"charbank_8003":"set_charbank",  # inc charbank
}



# various dirty but at least automatic patches applying on the specific track and field code
with open(source_dir / "conv.s") as f:
    lines = list(f)
    i = 0

    while i < len(lines):
        line = lines[i]
        if " = " in line:
            equates.append(line.replace("$","0x"))
            line = ""

        if "GET_ADDRESS\ttable" in line:
            line = line.replace("GET_ADDRESS","PUSH_TABLE_X_ADDRESS")
            if any(x in line for x in ("_cd28","_cf24","_c55d","_f1ae")):
                lines[i+1] = "\trts   | rest of the code is useless, just jump\n\n"
            if "_e9db" in line:
                for j in range(i+1,i+11):
                    lines[j] = ""
            else:
                lines[i+1] = ""

        if "unsupported transfer to stack register" in line:
            line = ""

        if "[indirect_jump]" in line:
            line = change_instruction("rts",lines,i)  # proper address already on stack

        if "[$f1e3:" in line:
            lines[i-1] = ""
        elif "[$f183:" in line:
            lines[i-1] = ""

        elif "[$c580:" in line:
            line = change_instruction("cmp.b\t#0,d0",lines,i) + "\tINVERT_XC_FLAGS\n"
            lines[i-1] = ""

        elif "[$d90a:" in line or "[$d911:" in line:
            # not detected by converter, highscore carry propagation
            # in bcd
            lines[i+2] = lines[i+2].replace("addx.b","abcd")

        elif "[$d024:" in line:
            line = "\ttst.b\tinvincible_flag\n\tjeq\t0f\n\trts\n0:\n"+line

        if "[disable]" in line:
            line = remove_instruction(lines,i)

        elif "nop" in line.split():
            line = remove_instruction(lines,i)

        elif "stray b" in line:
            line = ""       # when disabling this, make sure that false alarms have been reviewed

        if "[$f7df:" in line or "[$f7df:" in line or "[$f7eb:" in line:
            # X flag set by lsr
            line = "\tSET_C_FROM_X\n"+line
            lines[i+1]=""

        if "[$d9f8:" in line:
            line = remove_instruction(lines,i)      # no need to set decimal here (credit adds up to 09 only)

        if "unsupported return from interrupt" in line:
            line = change_instruction("rts",lines,i)

        if any(x in line for x in ("GET_ADDRESS","GET_INDIRECT_ADDRESS","or.","move.","addq.","clr.")):
            if "POP_SR" in lines[i-1] and "plp" not in lines[i-1]:
                # optimize: no need to restore SR, it won't be used
                for j in range(i-1,i-10,-1):
                    if j>=0 and "PUSH_SR" in lines[j] and "php" not in lines[j]:
                        lines[j] = ""
                        lines[i-1] = ""
                        break

        # pre-add video_address tag if we find a store instruction to an explicit 3000-3FFF address
        if store_to_video.search(line):
            line = line.rstrip() + " [video_address]\n"

        if "[$d031:" in line:
            line = "\tINVERT_XC_FLAGS\n"+line       # cmp invert before RTS
            lines[i+1] = ""


        if "[video_address" in line:
            # give me the original instruction
            line = line.replace("_ADDRESS","_UNCHECKED_ADDRESS")

            vbd_macro =  "MAYBE_VIDEO_BYTE_DIRTY" if "[video_address_maybe]" in line else "VIDEO_BYTE_DIRTY"

            # if it's a write, insert a "VIDEO_DIRTY" macro after the write
            for j in range(i+1,len(lines)):
                next_line = lines[j]
                if "[...]" not in next_line:
                    break
                if ",(a0)" in next_line or "clr" in next_line:
                    lines[j] = next_line+f"\t{vbd_macro} | [...]\n"
                    break
                elif ",(a0,d2.w)" in next_line:
                    lines[j] = next_line+f"\tadd.w\td2,a0 | [...]\n\t{vbd_macro} | [...]\n"
                    break
                elif ",(a0,d1.w)" in next_line:
                    lines[j] = next_line+f"\tadd.w\td1,a0 | [...]\n\t{vbd_macro} | [...]\n"
                    break




        line = re.sub(tablere,subt,line)


        # sync system is crap, and copy-pasted multiple times

        line = re.sub("jbsr\tsync_....","jbsr\tosd_wait_for_sync",line)



        if "[$f022:" in line or "[$f025:" in line:
            # remove useless 2 second wait
            line = remove_instruction(lines,i)

        if "GET_ADDRESS" in line:
            val = line.split()[1]
            toks = line.split()
            input_dict = input_read_dict if "lda" in toks else input_write_dict
            osd_call = input_dict.get(val)
            if osd_call is not None:
                if osd_call:
                    line = change_instruction(f"jbsr\tosd_{osd_call}",lines,i)
                else:
                    line = remove_instruction(lines,i)
                lines[i+1] = remove_instruction(lines,i+1)
                if "stx" in line:
                    line = f"\texg\td0,d1\n{line}\texg\td0,d1\n"
                if "sty" in line:
                    line = f"\texg\td0,d2\n{line}\texg\td0,d2\n"
            if "read_dsw1" in line and "sta" in line:
                line = remove_instruction(lines,i)
            if "read_dsw2" in line and "sta" in line:
                line = change_instruction("jbsr\tosd_video_control",lines,i)

        elif "unsupported instruction rti" in line:
            line = change_instruction("rts",lines,i)
##        elif "unsupported instruction andcc" in line:
##            line = change_instruction("CLR_XC_FLAGS",lines,i)
        elif "jump_table" in line:
            m = jmpre.search(line)
            if m:
                ireg = m.group(2).upper()  # A or B
                inst = m.group(1).upper()
                reg = {"x":"A2","y":"A3","u":"A4"}[m.group(3)]
                rest = re.sub(".*\"","",line)
                line = f"\t{inst}_{ireg}_INDEXED\t{reg}{rest}"
        if "ERROR" in line:
            print(line,end="")
        lines[i] = line
        i+=1




with open(source_dir / "data.inc","w") as fw:
    fw.writelines(equates)

with open(source_dir / "locknchase.68k","w") as fw:
    fw.write("""\t*.include "locknchase.inc"
.include "data.inc"
\t.global\tinsert_coin_irq_f000
\t.global\treset_f003
""")
    fw.writelines(lines)