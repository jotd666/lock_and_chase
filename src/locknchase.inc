* Converted with 6502to68k by JOTD
*
* include file which contains generic macros
* and also macros that the user must fill/tune


	.include	"breakpoint.inc"
	
	.macro	ERROR	arg
	*.error	"\arg"     | comment out to disable errors
	.endm
	
	.ifdef	MC68020
* 68020 optimized
	.macro PUSH_SR
	move.w	ccr,-(sp)
	.endm

	.macro READ_LE_WORD    srcreg
	PUSH_SR
	moveq    #0,d4
	move.w    (\srcreg),d4
	rol.w    #8,d4
* we have to use long else it will
* extend sign for > 0x7FFF and will compute wrong offset
	move.l    d4,\srcreg
	POP_SR
	.endm

	.else
* 68000 compliant
	.macro PUSH_SR
	move.w	sr,-(sp)
	.endm

	.macro READ_LE_WORD    srcreg
	PUSH_SR
	moveq    #0,d4
	move.b    (1,\srcreg),d4
	lsl.w    #8,d4
	move.b    (\srcreg),d4
* we have to use long else it will
* extend sign for > 0x7FFF and will compute wrong offset
	move.l    d4,\srcreg
	POP_SR
	.endm

	.endif

	.macro POP_SR
	move.w	(sp)+,ccr
	.endm

	.macro	SBC_X	address
	INVERT_XC_FLAGS
	GET_ADDRESS	\address
	move.b	(a0,d1.w),d4
	subx.b	d4,d0
	INVERT_XC_FLAGS
	.endm
	
	.macro	SBC_Y	address
	INVERT_XC_FLAGS
	GET_ADDRESS	\address
	move.b	(a0,d2.w),d4
	subx.b	d4,d0
	INVERT_XC_FLAGS
	.endm
	
	.macro	SBC	address
	INVERT_XC_FLAGS
	GET_ADDRESS	\address
	move.b	(a0),d4
	subx.b	d4,d0
	INVERT_XC_FLAGS
	.endm

	.macro	SBCD_DIRECT	address
	INVERT_XC_FLAGS
	GET_ADDRESS	\address
	move.b	(a0),d4
	scbd	d4,d0
	INVERT_XC_FLAGS
	.endm
	
	.macro	SBC_IMM	param
	INVERT_XC_FLAGS
	move.b	#\param,d4
	subx.b	d4,d0
	INVERT_XC_FLAGS
	.endm

	.macro	SBCD_IMM	param
	INVERT_XC_FLAGS
	move.b	#\param,d4
	sbcd	d4,d0
	INVERT_XC_FLAGS
	.endm

	.macro INVERT_XC_FLAGS
	PUSH_SR
	move.w	(sp),d4
	eor.b	#0x11,d4
	move.w	d4,(sp)
	POP_SR
	.endm

* useful to recall C from X (add then move then bcx)
	.macro	SET_C_FROM_X
	PUSH_SR
	move.w	(sp),d4
	bset	#0,d4   | set C
	btst	#4,d4
	bne.b	0f
	bclr	#0,d4   | X is clear: clear C
0:
	move.w	d4,(sp)
	POP_SR
	.endm

	.macro	SET_X_FROM_CLEARED_C
	PUSH_SR
	move.w	(sp),d4
	bset	#4,d4   | set X
	btst	#0,d4
	beq.b	skip\@
	bclr	#4,d4   | C is set: clear X
skip\@:
	move.w	d4,(sp)
	POP_SR
	.endm

	.macro CLR_XC_FLAGS
	moveq	#0,d7
	roxl.b	#1,d7
	.endm
	.macro SET_XC_FLAGS
	st	d7
	roxl.b	#1,d7
	.endm

	.macro CLR_V_FLAG
	moveq	#0,d3
	add.b	d3,d3
	.endm

	.macro SET_I_FLAG
	ERROR  "TODO: insert interrupt disable code here"
	.endm
	.macro CLR_I_FLAG
	ERROR   "TODO: insert interrupt enable code here"
	.endm


	.macro	VIDEO_BYTE_DIRTY
	jbsr	osd_video_byte_dirty
	.endm

	.macro GET_ADDRESS	offset
	lea	\offset,a0
	GET_ADDRESS_FUNC
	.endm

	.macro GET_UNCHECKED_ADDRESS	offset
	lea	\offset,a0
	lea		(a6,a0.l),a0
	.endm

	.macro GET_ADDRESS_X	offset
	.ifgt	\offset-0x8000
	lea	\offset,a0
	.else
	lea	\offset\().w,a0
	.endif
	GET_ADDRESS_FUNC
	lea	(a0,d1.w),a0
	READ_LE_WORD	a0
	GET_ADDRESS_FUNC
	.endm

	.macro GET_INDIRECT_ADDRESS	offset
	GET_ADDRESS	\offset
	READ_LE_WORD	a0
	GET_ADDRESS_FUNC
	.endm

	.macro GET_INDIRECT_UNCHECKED_ADDRESS	offset
	GET_ADDRESS	\offset
	READ_LE_WORD	a0
	GET_UNCHECKED_ADDRESS_FUNC
	.endm

	.macro	GET_UNCHECKED_ADDRESS_FUNC
	lea		(a6,a0.l),a0
	.endm
	

	.ifdef	RELEASE
	.macro	GET_ADDRESS_FUNC
	GET_UNCHECKED_ADDRESS_FUNC
	.endm
	
	.else
	
	.macro	GET_ADDRESS_FUNC
	jbsr	get_address
	.endm
	
	
* dev mode, more checks about the address
get_address:
	cmp.l	#0xC000,a0
	jcc		10f		| rom: ok
	cmp.w	#0x4000,a0
	jcs		0f
	* >= 0x4000
	cmp.w	#0x7800,a0
	jcc		0f
	BREAKPOINT	"unsupported address range 0x4000-0x77FF"
	illegal
0:
	cmp.l	#0x8000,a0
	jcc		1f
	* 0X3c00 <= range < 0x4000, video ram
	cmp.w	#0x7c00,a0
	jcs		0f
	* video/attribute: must be done without "get_address"
	jbsr	osd_get_last_known_pc
	BREAKPOINT	"unsupported address range 0x7c00-0x7FFF, PC in D6"	
0:
	cmp.w	#0x3c00,a0
	jcs		10f
	* 0X3c00 <= range < 0x4000, video ram
	* video/attribute: must be done without "get_address"
	jbsr	osd_get_last_known_pc
	BREAKPOINT	"unsupported address range 0x3c00-0x3FFF, PC in D6"
	jra		10f
0:
1:
	* >=0x8000
	jbsr	osd_get_last_known_pc
	BREAKPOINT	"unsupported address range 0x8000-0xBFFF, PC in D6"
	
10:
	GET_UNCHECKED_ADDRESS_FUNC
	rts
	.endif
	
	.macro	PUSH_TABLE_X_ADDRESS	table
	lea		\table,a0
	and.w	#0xFF,d1
	.ifdef	MC68020
	move.l	(a0,d1.w*2),-(a7)
	.else
	add.w	d1,d1
	move.l	(a0,d1.w),-(a7)
	.endif
	.endm
