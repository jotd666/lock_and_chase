;
; Lock'n'Chase 1981 Data East
;
; Reverse-engineered by JOTD 2025
; 
;	map(0x0000, 0x3bff).ram().share("rambase");
;	map(0x3c00, 0x3fff).ram().w(FUNC(btime_state::lnc_videoram_w)).share("videoram");
;	map(0x7800, 0x7bff).writeonly().share("colorram");  /* this is just here to initialize the pointer */
;	map(0x7c00, 0x7fff).rw(FUNC(btime_state::btime_mirrorvideoram_r), FUNC(btime_state::lnc_mirrorvideoram_w));
;	map(0x8000, 0x8000).portr("DSW1").nopw();     /* ??? */
;	map(0x8001, 0x8001).portr("DSW2").w(FUNC(btime_state::bnj_video_control_w));
;	map(0x8003, 0x8003).writeonly().share("lnc_charbank");
;	map(0x9000, 0x9000).portr("P1").nopw();     /* IRQ ack??? */
;	map(0x9001, 0x9001).portr("P2");
;	map(0x9002, 0x9002).portr("SYSTEM").w(m_soundlatch, FUNC(generic_latch_8_device::write));
;	map(0xb000, 0xb1ff).ram();
;	map(0xc000, 0xffff).rom();

	
;	PORT_START("P1")
;	PORT_BIT( 0x01, IP_ACTIVE_LOW, IPT_JOYSTICK_RIGHT ) PORT_4WAY
;	PORT_BIT( 0x02, IP_ACTIVE_LOW, IPT_JOYSTICK_LEFT ) PORT_4WAY
;	PORT_BIT( 0x04, IP_ACTIVE_LOW, IPT_JOYSTICK_UP ) PORT_4WAY
;	PORT_BIT( 0x08, IP_ACTIVE_LOW, IPT_JOYSTICK_DOWN ) PORT_4WAY
;	PORT_BIT( 0x10, IP_ACTIVE_LOW, IPT_BUTTON1 )
;	PORT_BIT( 0x20, IP_ACTIVE_LOW, IPT_UNKNOWN )
;	PORT_BIT( 0x40, IP_ACTIVE_LOW, IPT_UNUSED )
;	PORT_BIT( 0x80, IP_ACTIVE_LOW, IPT_UNUSED )
;
;
;	PORT_START("SYSTEM")
;	PORT_BIT( 0x01, IP_ACTIVE_LOW, IPT_START1 )
;	PORT_BIT( 0x02, IP_ACTIVE_LOW, IPT_START2 )
;	PORT_BIT( 0x04, IP_ACTIVE_LOW, IPT_TILT )
;	PORT_BIT( 0x08, IP_ACTIVE_LOW, IPT_UNKNOWN )
;	PORT_BIT( 0x10, IP_ACTIVE_LOW, IPT_UNUSED )
;	PORT_BIT( 0x20, IP_ACTIVE_LOW, IPT_UNUSED )
;	PORT_BIT( 0x40, IP_ACTIVE_HIGH, IPT_COIN1 ) PORT_CHANGED_MEMBER(DEVICE_SELF, btime_state,coin_inserted_irq_hi, 0)
;	PORT_BIT( 0x80, IP_ACTIVE_HIGH, IPT_COIN2 ) PORT_CHANGED_MEMBER(DEVICE_SELF, btime_state,coin_inserted_irq_hi, 0)
;
;	PORT_START("DSW1") // At location 15D on sound PCB
;	PORT_DIPNAME( 0x03, 0x03, DEF_STR( Coin_A ) )     PORT_DIPLOCATION("SW1:1,2")
;	PORT_DIPSETTING(    0x00, DEF_STR( 2C_1C ) )
;	PORT_DIPSETTING(    0x03, DEF_STR( 1C_1C ) )
;	PORT_DIPSETTING(    0x02, DEF_STR( 1C_2C ) )
;	PORT_DIPSETTING(    0x01, DEF_STR( 1C_3C ) )
;	PORT_DIPNAME( 0x0c, 0x0c, DEF_STR( Coin_B ) )     PORT_DIPLOCATION("SW1:3,4")
;	PORT_DIPSETTING(    0x00, DEF_STR( 2C_1C ) )
;	PORT_DIPSETTING(    0x0c, DEF_STR( 1C_1C ) )
;	PORT_DIPSETTING(    0x08, DEF_STR( 1C_2C ) )
;	PORT_DIPSETTING(    0x04, DEF_STR( 1C_3C ) )
;	PORT_DIPNAME( 0x10, 0x10, "Leave Off" )           PORT_DIPLOCATION("SW1:5") // Must be OFF. No test mode in ROM
;	PORT_DIPSETTING(    0x10, DEF_STR( Off ) )                                  // so this locks up the game at boot-up if on
;	PORT_DIPSETTING(    0x00, DEF_STR( On ) )
;	PORT_DIPUNUSED_DIPLOC( 0x20, IP_ACTIVE_LOW, "SW1:6" )
;	PORT_DIPNAME( 0x40, 0x00, DEF_STR( Cabinet ) )    PORT_DIPLOCATION("SW1:7")
;	PORT_DIPSETTING(    0x00, DEF_STR( Upright ) )
;	PORT_DIPSETTING(    0x40, DEF_STR( Cocktail ) )
;//  PORT_DIPNAME( 0x80, 0x00, "Screen" )              PORT_DIPLOCATION("SW1:8") // Manual states this is Screen Invert
;//  PORT_DIPSETTING(    0x00, "Normal" )
;//  PORT_DIPSETTING(    0x80, "Invert" )
;	PORT_BIT( 0x80, IP_ACTIVE_HIGH, IPT_CUSTOM  ) PORT_VBLANK("screen")  // Schematics show this is connected to DIP SW2.8
;
;	PORT_START("DSW2") // At location 14D on sound PCB
;	PORT_DIPNAME( 0x01, 0x01, DEF_STR( Lives ) )      PORT_DIPLOCATION("SW2:1")
;	PORT_DIPSETTING(    0x01, "3" )
;	PORT_DIPSETTING(    0x00, "5" )
;	PORT_DIPNAME( 0x06, 0x02, DEF_STR( Bonus_Life ) ) PORT_DIPLOCATION("SW2:2,3")
;	PORT_DIPSETTING(    0x06, "10000" )
;	PORT_DIPSETTING(    0x04, "15000" )
;	PORT_DIPSETTING(    0x02, "20000"  )
;	PORT_DIPSETTING(    0x00, "30000"  )
;	PORT_DIPNAME( 0x08, 0x08, "Enemies" )             PORT_DIPLOCATION("SW2:4")
;	PORT_DIPSETTING(    0x08, "4" )
;	PORT_DIPSETTING(    0x00, "6" )
;	PORT_DIPNAME( 0x10, 0x00, "End of Level Pepper" ) PORT_DIPLOCATION("SW2:5")
;	PORT_DIPSETTING(    0x10, DEF_STR( No ) )
;	PORT_DIPSETTING(    0x00, DEF_STR( Yes ) )
;	PORT_DIPUNUSED_DIPLOC( 0x20, 0x20, "SW2:6" )  // should be OFF according to the manual
;	PORT_DIPUNUSED_DIPLOC( 0x40, 0x40, "SW2:7" )  // should be OFF according to the manual
;	PORT_DIPUNUSED_DIPLOC( 0x80, 0x80, "SW2:8" )  // should be OFF according to the manual

nb_credits_02 = $02
nb_lives_p1_0f = $0f
nb_lives_p2_1e = $1e
nb_pellets_picked_37 = $37 
player_state_3b = $3b
player_x_3e = $3e
player_y_3f = $3f
player_x_copy_40 = $40
player_y_copy_41 = $41
tile_facing_player_4b = $4b
counter_0to4_4f = $4f
enemy_x_57 = $57
enemy_y_58 = $58
exit_open_flag_b0 = $b0
 
player_1_controls_9000 = $9000
system_9002 = $9002
dsw1_8000 = $8000
dsw2_8001 = $8001
charbank_8003 = $8003

insert_coin_irq_c000:
C000: 4C 4F A0 jmp insert_coin_c02f

boot_continues_c003:
C003: 4C 06 A0 jmp $c006	; useless jump just next line
C006: 58       cli			; interrupts enabled
C007: D8       cld			; decimal disabled
C008: A9 00    lda #$00
C00A: 8D 01 80 sta dsw2_8001		; video control
C00D: 8D 02 90 sta system_9002		; stop sound?
C010: 8D 00 90 sta player_1_controls_9000	; nop
C013: 20 5D BA jsr clear_screen_and_sprites_da3d
C016: 20 DA B9 jsr clear_zero_page_d9ba
C019: 20 AB B9 jsr clear_page_2_d9cb
C01C: A9 20    lda #$40
C01E: 20 A4 BB jsr wait_dbc4		; wait 2/3 of a second
C021: 20 14 B3 jsr $d314
C024: 20 02 BA jsr $da02
C027: 20 52 B3 jsr $d332
C02A: E6 05    inc $05
C02C: 4C B9 A0 jmp $c0d9

; called by interrupt
insert_coin_c02f:
C02F: 48       pha
C030: 8A       txa
C031: 48       pha
C032: 98       tya
C033: 48       pha
C034: 58       cli
C035: D8       cld
C036: A5 06    lda $06
C038: 8D 01 80 sta dsw2_8001
C03B: 20 A1 A0 jsr $c0c1
C03E: AD 02 90 lda system_9002
C041: 29 A0    and #$c0
C043: F0 2B    beq $c090
C045: 85 00    sta $00
C047: 20 A1 A0 jsr $c0c1
C04A: AD 02 90 lda system_9002
C04D: 25 00    and $00
C04F: F0 5F    beq $c090
C051: 20 A1 A0 jsr $c0c1
C054: AD 02 90 lda system_9002
C057: 25 00    and $00
C059: F0 55    beq $c090
C05B: 20 A1 A0 jsr $c0c1
C05E: AD 02 90 lda system_9002
C061: 25 00    and $00
C063: F0 4B    beq $c090
C065: E6 03    inc $03
C067: A9 01    lda #$01
C069: 8D 02 90 sta system_9002		; play credit sound
C06C: A2 00    ldx #$00
C06E: AD 00 80 lda dsw1_8000
C071: 49 FF    eor #$ff
C073: 29 0F    and #$0f
C075: 06 00    asl $00
C077: 90 02    bcc $c07b
C079: 4A       lsr a
C07A: 4A       lsr a
C07B: 29 03    and #$03
C07D: F0 1F    beq $c09e
C07F: E8       inx
C080: C9 01    cmp #$01
C082: F0 1A    beq $c09e
C084: E8       inx
C085: C9 02    cmp #$02
C087: F0 15    beq $c09e
C089: E8       inx
C08A: A5 03    lda $03
C08C: C9 02    cmp #$02
C08E: B0 09    bcs $c099
C090: 8D 00 90 sta player_1_controls_9000
C093: 68       pla
C094: A8       tay
C095: 68       pla
C096: AA       tax
C097: 68       pla
C098: 40       rti

C099: C6 03    dec $03
C09B: 4C 9E A0 jmp $c09e

C09E: A5 02    lda nb_credits_02
C0A0: F8       sed			; set decimal mode (useless as maxxed out to 9)
C0A1: 18       clc
C0A2: 7D AC A0 adc $c0cc, x
C0A5: C9 09    cmp #$09
C0A7: 90 02    bcc $c0ab
C0A9: A9 09    lda #$09		; max credits, nop that it will allow to insert 99 credits
C0AB: 85 02    sta nb_credits_02
C0AD: D8       cld
C0AE: C6 03    dec $03
C0B0: A5 04    lda $04
C0B2: D0 BC    bne $c090
C0B4: 8D 00 90 sta player_1_controls_9000
C0B7: A9 01    lda #$01
C0B9: 85 04    sta $04
C0BB: A2 FF    ldx #$ff
C0BD: 9A       txs
C0BE: 4C B0 A0 jmp $c0d0
C0C1: A0 E7    ldy #$e7
C0C3: A9 FF    lda #$ff
C0C5: A9 FF    lda #$ff
C0C7: EA       nop
C0C8: 88       dey
C0C9: D0 F8    bne $c0c3
C0CB: 60       rts

C0D0: 20 62 B7 jsr $d762
C0D3: 20 85 B3 jsr $d385
C0D6: 4C B0 A0 jmp $c0d0

C0D9: A2 FF    ldx #$ff		; set stack high
C0DB: 9A       txs
C0DC: 20 66 BA jsr clear_part_of_screen_da66
C0DF: A2 0E    ldx #$0e
C0E1: 20 DC B9 jsr $d9bc
C0E4: A5 07    lda $07
C0E6: 85 0F    sta nb_lives_p1_0f
C0E8: 85 1E    sta nb_lives_p2_1e
C0EA: A9 00    lda #$00
C0EC: 85 06    sta $06
C0EE: A5 04    lda $04
C0F0: F0 0C    beq $c0fe
C0F2: 20 AE BB jsr $dbce
C0F5: A5 05    lda $05
C0F7: C9 02    cmp #$02
C0F9: 90 03    bcc $c0fe
C0FB: 20 B3 BB jsr $dbd3
C0FE: 20 B2 A1 jsr $c1d2
C101: A5 4C    lda $2c
C103: 30 16    bmi $c11b
C105: 09 80    ora #$80
C107: 85 4C    sta $2c
C109: A9 00    lda #$00
C10B: 85 57    sta nb_pellets_picked_37
C10D: A9 00    lda #$00
C10F: 85 58    sta $38
C111: 85 59    sta $39
C113: 85 5A    sta $3a
C115: 20 D8 E1 jsr run_length_uncompress_e1b8
C118: 20 A3 BA jsr $dac3
C11B: A5 06    lda $06
C11D: 8D 01 80 sta dsw2_8001
C120: A5 57    lda nb_pellets_picked_37
C122: 85 9F    sta $9f
C124: A9 01    lda #$01
C126: 20 D8 E1 jsr run_length_uncompress_e1b8
C129: A9 01    lda #$01
C12B: 20 E0 B7 jsr $d7e0
C12E: 20 8C BA jsr display_nb_lives_da8c
C131: 20 B8 BA jsr display_current_bonus_and_level_dad8
C134: 20 F6 A1 jsr $c1f6
C137: 20 A6 B9 jsr $d9c6
C13A: A2 5B    ldx #$3b
C13C: 20 DC B9 jsr $d9bc
C13F: 20 59 B1 jsr $d139
; game mainloop
game_mainloop_c142:
C142: 20 D7 BB jsr sync_dbb7
C145: 20 B1 BC jsr special_writes_dcd1
C148: 20 5B A2 jsr $c23b
C14B: 20 B6 AA jsr $cad6
C14E: 20 F0 A6 jsr $c6f0
C151: 20 63 A7 jsr $c763
C154: 20 D4 A8 jsr $c8b4
C157: 20 30 A9 jsr $c950
C15A: 20 A5 A9 jsr $c9c5
C15D: 20 8C AA jsr $ca8c
C160: A5 04    lda $04
C162: F0 06    beq $c16a
C164: 20 9E B8 jsr $d89e
C167: 20 97 B8 jsr $d897
C16A: 20 D0 B7 jsr $d7b0
C16D: 20 5B B8 jsr $d83b
C170: A5 06    lda $06
C172: 8D 01 80 sta dsw2_8001
C175: A5 5B    lda player_state_3b
C177: 10 A9    bpl game_mainloop_c142
C179: 29 08    and #$08
C17B: F0 06    beq $c183
C17D: A5 4C    lda $2c
C17F: 29 7F    and #$7f
C181: 85 4C    sta $2c
C183: 20 4F BB jsr $db2f
C186: A9 00    lda #$00
C188: 20 E7 B9 jsr $d9e7
C18B: A9 30    lda #$50
C18D: 20 A4 BB jsr wait_dbc4
C190: A5 4C    lda $2c
C192: 10 41    bpl $c1b5
C194: A5 04    lda $04
C196: F0 40    beq $c1b8
C198: 20 E3 A1 jsr $c1e3
C19B: A9 02    lda #$02
C19D: 20 D8 E1 jsr run_length_uncompress_e1b8
C1A0: A5 4D    lda $2d
C1A2: 30 14    bmi $c1b8
C1A4: A5 05    lda $05
C1A6: C9 02    cmp #$02
C1A8: 90 08    bcc $c1b2
C1AA: E6 06    inc $06
C1AC: A5 06    lda $06
C1AE: 29 01    and #$01
C1B0: 85 06    sta $06
C1B2: 4C FE A0 jmp $c0fe
C1B5: 4C 01 A1 jmp $c101
C1B8: 20 10 A2 jsr $c210
C1BB: C6 05    dec $05
C1BD: D0 EB    bne $c1aa
C1BF: A9 00    lda #$00
C1C1: 85 06    sta $06
C1C3: 8D 01 80 sta dsw2_8001
C1C6: A5 02    lda nb_credits_02
C1C8: D0 05    bne $c1cf
C1CA: 85 04    sta $04
C1CC: 4C 44 A0 jmp $c024
C1CF: 4C B0 A0 jmp $c0d0
C1D2: A4 06    ldy $06
C1D4: BE F4 A1 ldx $c1f4, y
C1D7: A0 0E    ldy #$0e
C1D9: B5 00    lda $00, x
C1DB: 99 4C 00 sta $002c, y
C1DE: CA       dex
C1DF: 88       dey
C1E0: 10 F7    bpl $c1d9
C1E2: 60       rts
C1E3: A4 06    ldy $06
C1E5: BE F4 A1 ldx $c1f4, y
C1E8: A0 0E    ldy #$0e
C1EA: B9 4C 00 lda $002c, y
C1ED: 95 00    sta $00, x
C1EF: CA       dex
C1F0: 88       dey
C1F1: 10 F7    bpl $c1ea
C1F3: 60       rts

C1F6: A4 04    ldy $04
C1F8: F0 0F    beq $c209
C1FA: 4C 0F A2 jmp $c20f
C1FD: A0 01    ldy #$01
C1FF: A5 05    lda $05
C201: C9 02    cmp #$02
C203: 90 04    bcc $c209
C205: A4 06    ldy $06
C207: C8       iny
C208: C8       iny
C209: BE 53 A2 ldx $c233, y
C20C: 20 4F BC jsr $dc2f
C20F: 60       rts
C210: A5 05    lda $05
C212: A0 00    ldy #$00
C214: C9 02    cmp #$02
C216: 90 03    bcc $c21b
C218: A4 06    ldy $06
C21A: C8       iny
C21B: BE 57 A2 ldx $c237, y
C21E: 20 4F BC jsr $dc2f
C221: A9 80    lda #$80
C223: 20 A4 BB jsr wait_dbc4
C226: A2 4E    ldx #$2e
C228: 20 4F BC jsr $dc2f
C22B: A5 04    lda $04
C22D: F0 03    beq $c232
C22F: 20 95 E5 jsr $e595
C232: 60       rts


C23B: A9 00    lda #$00
C23D: 8D 03 80 sta charbank_8003
C240: A5 5B    lda player_state_3b
C242: 30 17    bmi $c25b
C244: 2C 68 A2 bit $c268
C247: D0 13    bne $c25c
C249: 2C 69 A2 bit $c269
C24C: D0 11    bne $c25f
C24E: 2C 6A A2 bit $c26a
C251: D0 0F    bne $c262
C253: 2C 6B A2 bit $c26b
C256: D0 0D    bne $c265
C258: 20 6C A2 jsr $c26c
C25B: 60       rts

C25C: 4C 91 A3 jmp $c391
C25F: 4C ED A3 jmp $c3ed
C262: 4C 2D A4 jmp $c44d
C265: 4C 8F A4 jmp $c48f

C26C: A5 4E    lda $2e
C26E: F0 03    beq $c273              
C270: 4C 01 A3 jmp $c301
C273: A5 5C    lda $3c
C275: 30 2D    bmi $c2c4
C277: 09 80    ora #$80
C279: 85 5C    sta $3c
C27B: A6 4D    ldx $2d
C27D: C6 4D    dec $2d
C27F: A9 01    lda #$01
C281: 8D 00 7C sta $7c00
C284: 8D 04 7C sta $7c04
C287: BD 7F A3 lda $c37f, x
C28A: 49 FF    eor #$ff
C28C: 8D 02 7C sta $7c02
C28F: 38       sec
C290: E9 10    sbc #$10
C292: 8D 06 7C sta $7c06
C295: A9 E8    lda #$e8
C297: 8D 03 7C sta $7c03
C29A: 8D 07 7C sta $7c07
C29D: BD 84 A3 lda $c384, x
C2A0: 85 CB    sta $ab
C2A2: A9 5F    lda #$3f
C2A4: 85 CC    sta $ac
C2A6: A9 9F    lda #$9f
C2A8: 20 CC BA jsr display_one_life_daac
C2AB: A9 10    lda #$10
C2AD: 85 29    sta $49
C2AF: A5 4C    lda $2c
C2B1: 29 02    and #$02
C2B3: D0 0F    bne $c2c4
C2B5: A5 4C    lda $2c
C2B7: 09 02    ora #$02
C2B9: 85 4C    sta $2c
C2BB: A9 A0    lda #$c0
C2BD: 85 29    sta $49
C2BF: A9 21    lda #$41
C2C1: 20 E7 B9 jsr $d9e7
C2C4: A5 24    lda $44
C2C6: E6 24    inc $44
C2C8: 29 0F    and #$0f
C2CA: 4A       lsr a
C2CB: 4A       lsr a
C2CC: AA       tax
C2CD: BD 89 A3 lda $c389, x
C2D0: 8D 01 7C sta $7c01
C2D3: 8D 05 7C sta $7c05
C2D6: EE 05 7C inc $7c05
C2D9: A5 29    lda $49
C2DB: F0 09    beq $c2e6
C2DD: C6 29    dec $49
C2DF: D0 0B    bne $c2ec
C2E1: A9 1D    lda #$1d
C2E3: 20 E7 B9 jsr $d9e7
C2E6: CE 02 7C dec $7c02
C2E9: CE 06 7C dec $7c06
C2EC: AD 02 7C lda $7c02
C2EF: 49 FF    eor #$ff
C2F1: C9 CF    cmp #$af
C2F3: 90 0B    bcc $c300
C2F5: A9 9D    lda #$9d
C2F7: 20 E7 B9 jsr $d9e7
C2FA: A9 00    lda #$00
C2FC: 85 5C    sta $3c
C2FE: E6 4E    inc $2e
C300: 60       rts

C301: A5 5C    lda $3c
C303: 30 47    bmi $c32c
C305: 09 80    ora #$80
C307: 85 5C    sta $3c
C309: A9 01    lda #$01
C30B: 8D 00 7C sta $7c00
C30E: A9 00    lda #$00
C310: 8D 04 7C sta $7c04
C313: A9 C8    lda #$a8
C315: 85 5E    sta player_x_3e
C317: A9 ED    lda #$ed
C319: 85 5F    sta player_y_3f
C31B: A9 04    lda #$04
C31D: 85 22    sta $42
C31F: 85 23    sta $43
C321: 20 DB A5 jsr $c5bb
C324: A9 60    lda #$60
C326: 85 29    sta $49
C328: 20 B8 B9 jsr $d9d8
C32B: 60       rts

C32C: A5 29    lda $49
C32E: F0 10    beq $c340
C330: C6 29    dec $49
C332: A5 29    lda $49
C334: D0 03    bne $c339
C336: 20 E0 B7 jsr $d7e0
C339: 4A       lsr a
C33A: 90 03    bcc $c33f
C33C: 20 BB A5 jsr $c5db
C33F: 60       rts

C340: 20 FE A4 jsr $c4fe
C343: A5 5F    lda player_y_3f
C345: C9 B2    cmp #$d2
C347: B0 55    bcs $c37e
; here player is just out of the gate,
; entering the maze, reaching Y=0xD2 coordinate
C349: A9 00    lda #$00
C34B: 85 5C    sta $3c
C34D: A5 5B    lda player_state_3b
C34F: 09 01    ora #$01
C351: 85 5B    sta player_state_3b
C353: A9 04    lda #$04
C355: 20 E7 B9 jsr $d9e7
C358: A9 01    lda #$01
C35A: 20 E0 B7 jsr $d7e0
C35D: A5 54    lda $34
C35F: E6 54    inc $34
C361: 29 03    and #$03
C363: AA       tax
C364: BC 8D A3 ldy $c38d, x
C367: A2 02    ldx #$02
C369: A9 92    lda #$92
C36B: 99 2D 7C sta $7c4d, y
C36E: 99 CD 7F sta $7fad, y
C371: C8       iny
C372: CA       dex
C373: 10 F6    bpl $c36b
C375: A5 04    lda $04
C377: F0 05    beq $c37e
C379: A2 4E    ldx #$2e
C37B: 20 4F BC jsr $dc2f
C37E: 60       rts

C391: A5 5C    lda $3c
C393: 30 49    bmi $c3be
C395: 20 FE A4 jsr $c4fe
C398: A5 23    lda $43
C39A: 4A       lsr a
C39B: AA       tax
C39C: A5 5F    lda player_y_3f
C39E: 30 02    bmi $c3a2
C3A0: 49 FF    eor #$ff
C3A2: DD E9 A3 cmp $c3e9, x
C3A5: 90 21    bcc $c3e8
C3A7: A5 5C    lda $3c
C3A9: 09 80    ora #$80
C3AB: 85 5C    sta $3c
C3AD: A9 05    lda #$05
C3AF: 20 E7 B9 jsr $d9e7
C3B2: 20 D7 BB jsr sync_dbb7
C3B5: A9 01    lda #$01
C3B7: 20 E0 B7 jsr $d7e0
C3BA: A9 A0    lda #$c0
C3BC: 85 2A    sta $4a
C3BE: A5 5B    lda player_state_3b
C3C0: 29 20    and #$40
C3C2: D0 1A    bne $c3de
C3C4: 20 66 A4 jsr $c466
C3C7: A5 5C    lda $3c
C3C9: D0 1D    bne $c3e8
C3CB: 09 80    ora #$80
C3CD: 85 5C    sta $3c
C3CF: A5 5B    lda player_state_3b
C3D1: 09 20    ora #$40
C3D3: 85 5B    sta player_state_3b
C3D5: A9 80    lda #$80
C3D7: 8D 01 7C sta $7c01
C3DA: A9 80    lda #$80
C3DC: 85 29    sta $49
C3DE: C6 29    dec $49
C3E0: D0 06    bne $c3e8
C3E2: A5 5B    lda player_state_3b
C3E4: 09 80    ora #$80
C3E6: 85 5B    sta player_state_3b
C3E8: 60       rts

C3ED: A5 5C    lda $3c
C3EF: 30 13    bmi $c404
C3F1: 09 80    ora #$80
C3F3: 85 5C    sta $3c
C3F5: A9 20    lda #$40
C3F7: 85 29    sta $49
C3F9: 20 E0 B9 jsr $d9e0
C3FC: 20 D7 BB jsr sync_dbb7
C3FF: A9 C5    lda #$a5
C401: 20 E7 B9 jsr $d9e7
C404: A5 29    lda $49
C406: D0 51    bne $c439
C408: A5 5B    lda player_state_3b
C40A: 29 20    and #$40
C40C: D0 0F    bne $c41d
C40E: A5 5B    lda player_state_3b
C410: 09 20    ora #$40
C412: 85 5B    sta player_state_3b
C414: A9 00    lda #$00
C416: 85 24    sta $44
C418: A9 22    lda #$42
C41A: 20 E7 B9 jsr $d9e7
C41D: A9 0B    lda #$0b
C41F: 85 29    sta $49
C421: A6 24    ldx $44
C423: E6 24    inc $44
C425: BD 5C A4 lda $c43c, x
C428: D0 0C    bne $c436
C42A: A5 5B    lda player_state_3b
C42C: 09 80    ora #$80
C42E: 85 5B    sta player_state_3b
C430: A9 00    lda #$00
C432: 85 4E    sta $2e
C434: A9 80    lda #$80
C436: 8D 01 7C sta $7c01
C439: C6 29    dec $49
C43B: 60       rts


C44D: A5 5C    lda $3c
C44F: 30 11    bmi $c462
C451: 09 80    ora #$80
C453: 85 5C    sta $3c
C455: A9 80    lda #$80
C457: 8D 01 7C sta $7c01
C45A: A9 5E    lda #$3e
C45C: 85 29    sta $49
C45E: A9 88    lda #$88
C460: 85 2A    sta $4a
C462: A5 29    lda $49
C464: D0 42    bne $c488
C466: A9 02    lda #$02
C468: 20 E7 B9 jsr $d9e7
C46B: A5 24    lda $44
C46D: E6 24    inc $44
C46F: 29 0F    and #$0f
C471: 4A       lsr a
C472: 4A       lsr a
C473: AA       tax
C474: BD 8B A4 lda $c48b, x
C477: 8D 01 7C sta $7c01
C47A: C6 2A    dec $4a
C47C: D0 0C    bne $c48a
C47E: A5 5B    lda player_state_3b
C480: 29 FD    and #$fd
C482: 85 5B    sta player_state_3b
C484: A9 00    lda #$00
C486: 85 5C    sta $3c
C488: C6 29    dec $49
C48A: 60       rts

C48D: 88       dey
C48E: 88       dey
C48F: 20 79 BB jsr $db79
C492: F0 3E    beq $c4f2
C494: A2 00    ldx #$00
C496: B5 80    lda $80, x
C498: F0 0E    beq $c4a8
C49A: A2 04    ldx #$04
C49C: B5 80    lda $80, x
C49E: F0 08    beq $c4a8
C4A0: A9 44    lda #$24
C4A2: 20 E7 B9 jsr $d9e7
C4A5: 4C F2 A4 jmp $c4f2
C4A8: A5 25    lda $45
C4AA: F0 26    beq $c4f2
C4AC: 29 5F    and #$3f
C4AE: A8       tay
C4AF: B9 68 02 lda $0268, y
C4B2: 29 1F    and #$1f
C4B4: D0 5C    bne $c4f2
C4B6: B9 68 02 lda $0268, y
C4B9: 48       pha
C4BA: 09 80    ora #$80
C4BC: 99 68 02 sta $0268, y
C4BF: 68       pla
C4C0: 10 43    bpl $c4e5
C4C2: A5 25    lda $45
C4C4: A0 00    ldy #$00
C4C6: D9 8A 00 cmp $008a, y
C4C9: F0 15    beq $c4e0
C4CB: A0 03    ldy #$03
C4CD: D9 8A 00 cmp $008a, y
C4D0: F0 0E    beq $c4e0
C4D2: A0 06    ldy #$06
C4D4: D9 8A 00 cmp $008a, y
C4D7: F0 07    beq $c4e0
C4D9: A0 09    ldy #$09
C4DB: D9 8A 00 cmp $008a, y
C4DE: D0 12    bne $c4f2
C4E0: A9 00    lda #$00
C4E2: 99 8A 00 sta $008a, y
C4E5: A5 25    lda $45
C4E7: 95 80    sta $80, x
C4E9: A9 00    lda #$00
C4EB: 85 25    sta $45
C4ED: A9 03    lda #$03
C4EF: 20 E7 B9 jsr $d9e7
C4F2: A4 2D    ldy $4d
C4F4: BE 59 A5 ldx $c539, y
C4F7: 30 05    bmi $c4fe
C4F9: 20 6D A5 jsr check_player_vs_maze_bounds_c56d
C4FC: 90 08    bcc $c506
C4FE: A6 23    ldx $43
C500: 20 6D A5 jsr check_player_vs_maze_bounds_c56d
C503: 90 07    bcc $c50c
C505: 60       rts
C506: 86 23    stx $43
C508: A5 2D    lda $4d
C50A: 85 22    sta $42
C50C: C6 5D    dec $3d
C50E: 10 17    bpl $c527
C510: AD 01 80 lda dsw2_8001
C513: 49 FF    eor #$ff
C515: 29 08    and #$08
C517: 08       php
C518: A5 50    lda $30
C51A: 28       plp
C51B: F0 03    beq $c520
C51D: 18       clc
C51E: 69 0A    adc #$0a
C520: AA       tax
C521: BD 29 A5 lda $c549, x
C524: 85 5D    sta $3d
C526: 60       rts
C527: 20 DB A5 jsr $c5bb
C52A: A6 2C    ldx $4c
C52C: BD 3D A5 lda table_c55d, x		; [jump_table]
C52F: 85 CD    sta $ad
C531: BD 3E A5 lda $c55e, x
C534: 85 CE    sta $ae
C536: 6C CD 00 jmp ($00ad)		; [indirect_jump]

; y: 0 or 1 which orientation to check
; y=0: check X
; y=1: check Y
check_player_vs_maze_bounds_c56d:
C56D: A5 5E    lda player_x_3e
C56F: 85 20    sta player_x_copy_40
C571: A5 5F    lda player_y_3f
C573: 85 21    sta player_y_copy_41
C575: BC CB A5 ldy $c5ab, x
C578: B9 20 00 lda $0040, y
C57B: 18       clc				; [disable]
C57C: 69 00    adc #$00			; [disable] useless add with 0
C57E: 29 07    and #$07
C580: C9 00    cmp #$00			; seems useless but actually sets/clear carry
C582: D0 46    bne $c5aa
; character aligned on tile grid Y wise: check next tile
C584: B9 20 00 lda $0040, y
C587: 29 F8    and #$f8
C589: 99 20 00 sta $0040, y
C58C: A5 20    lda player_x_copy_40
C58E: 18       clc
C58F: 7D D3 A5 adc $c5b3, x
C592: 85 CB    sta $ab
C594: A5 21    lda player_y_copy_41
C596: 18       clc
C597: 7D D4 A5 adc $c5b4, x
C59A: 20 C6 BB jsr $dba6
C59D: A0 00    ldy #$00
C59F: B1 CB    lda ($ab), y		; [video_address]
C5A1: 85 2B    sta tile_facing_player_4b
C5A3: A8       tay
C5A4: B9 BE BC lda $dcde, y
C5A7: 0A       asl a
C5A8: 85 2C    sta $4c
; returns carry, caller checks it
C5AA: 60       rts

C5BB: A6 23    ldx $43
C5BD: A5 5E    lda player_x_3e
C5BF: 18       clc
C5C0: 7D 0F A6 adc $c60f, x
C5C3: 85 5E    sta player_x_3e
C5C5: 18       clc
C5C6: 69 0C    adc #$0c
C5C8: 49 FF    eor #$ff
C5CA: 8D 02 7C sta $7c02
C5CD: A5 5F    lda player_y_3f
C5CF: 18       clc
C5D0: 7D 10 A6 adc $c610, x
C5D3: 85 5F    sta player_y_3f
C5D5: 38       sec
C5D6: E9 04    sbc #$04
C5D8: 8D 03 7C sta $7c03
C5DB: A5 23    lda $43
C5DD: 4A       lsr a
C5DE: AA       tax
C5DF: BD FB A5 lda $c5fb, x
C5E2: 8D 00 7C sta $7c00
C5E5: A5 24    lda $44
C5E7: 29 07    and #$07
C5E9: 4A       lsr a
C5EA: 85 C1    sta $a1
C5EC: A5 23    lda $43
C5EE: 0A       asl a
C5EF: 65 C1    adc $a1
C5F1: E6 24    inc $44
C5F3: AA       tax
C5F4: BD FF A5 lda $c5ff, x
C5F7: 8D 01 7C sta $7c01
C5FA: 60       rts

C617: E6 57    inc nb_pellets_picked_37
C619: A0 00    ldy #$00
C61B: 98       tya
C61C: 91 CB    sta ($ab), y		; [video_address]
C61E: A9 03    lda #$03
C620: 20 FD B8 jsr $d8fd
C623: 20 A2 A6 jsr $c6c2
C626: A5 57    lda nb_pellets_picked_37
C628: 29 01    and #$01
C62A: AA       tax
C62B: BD 52 A6 lda $c632, x
C62E: 20 E7 B9 jsr $d9e7
C631: 60       rts
C634: A5 5B    lda player_state_3b
C636: 09 02    ora #$02
C638: 85 5B    sta player_state_3b
C63A: A6 59    ldx $39
C63C: E6 59    inc $39
C63E: BD 30 A6 lda $c650, x
C641: 0A       asl a
C642: 7D 30 A6 adc $c650, x
C645: 85 96    sta $96
C647: 20 FD B8 jsr $d8fd
C64A: A9 0A    lda #$0a
C64C: 20 E7 B9 jsr $d9e7
C64F: 60       rts

C654: A6 50    ldx $30
C656: BD 68 A6 lda $c668, x
C659: 0A       asl a
C65A: 7D 68 A6 adc $c668, x
C65D: 85 99    sta $99
C65F: 20 FD B8 jsr $d8fd
C662: A9 08    lda #$08
C664: 20 E7 B9 jsr $d9e7
C667: 60       rts
C672: A5 23    lda $43
C674: 4A       lsr a
C675: 29 01    and #$01
C677: AA       tax
C678: A5 5E    lda player_x_3e
C67A: 30 02    bmi $c67e
C67C: 49 FF    eor #$ff
C67E: DD 89 A6 cmp $c689, x
C681: 90 05    bcc $c688
C683: BD 8B A6 lda $c68b, x
C686: 85 5E    sta player_x_3e
C688: 60       rts
C68D: A5 5B    lda player_state_3b
C68F: 09 08    ora #$08
C691: 85 5B    sta player_state_3b
C693: A9 00    lda #$00
C695: 20 E0 B7 jsr $d7e0
C698: 20 E0 B9 jsr $d9e0
C69B: 20 D7 BB jsr sync_dbb7
C69E: A9 C5    lda #$a5
C6A0: 20 E7 B9 jsr $d9e7
C6A3: 60       rts
C6A4: A5 26    lda $46
C6A6: 30 1A    bmi $c6c2
C6A8: A5 2B    lda tile_facing_player_4b
C6AA: 38       sec
C6AB: E9 9C    sbc #$9c
C6AD: A8       tay
C6AE: 09 80    ora #$80
C6B0: 85 26    sta $46
C6B2: B9 68 02 lda $0268, y
C6B5: 09 10    ora #$10
C6B7: 99 68 02 sta $0268, y
C6BA: A5 22    lda $42
C6BC: 85 27    sta $47
C6BE: A9 00    lda #$00
C6C0: 85 28    sta $48
C6C2: A5 26    lda $46
C6C4: F0 49    beq $c6ef
C6C6: E6 28    inc $48
C6C8: A5 27    lda $47
C6CA: C5 22    cmp $42
C6CC: F0 04    beq $c6d2
C6CE: C6 28    dec $48
C6D0: C6 28    dec $48
C6D2: A5 28    lda $48
C6D4: 30 08    bmi $c6de
C6D6: C9 10    cmp #$10
C6D8: 90 15    bcc $c6ef
C6DA: A5 26    lda $46
C6DC: 85 25    sta $45
C6DE: A5 26    lda $46
C6E0: 29 5F    and #$3f
C6E2: A8       tay
C6E3: A9 00    lda #$00
C6E5: 85 26    sta $46
C6E7: B9 68 02 lda $0268, y
C6EA: 29 EF    and #$ef
C6EC: 99 68 02 sta $0268, y
C6EF: 60       rts
C6F0: C6 7F    dec $7f
C6F2: 10 04    bpl $c6f8
C6F4: A9 01    lda #$01
C6F6: 85 7F    sta $7f
C6F8: A4 7F    ldy $7f
C6FA: BE 35 A7 ldx $c755, y
C6FD: B5 80    lda $80, x
C6FF: F0 33    beq $c754
C701: 29 20    and #$40
C703: D0 13    bne $c718
C705: B5 80    lda $80, x
C707: 09 20    ora #$40
C709: 95 80    sta $80, x
C70B: A4 50    ldy $30
C70D: B9 39 A7 lda $c759, y
C710: 95 81    sta $81, x
C712: A9 00    lda #$00
C714: 95 82    sta $82, x
C716: 95 83    sta $83, x
C718: B5 80    lda $80, x
C71A: 29 5F    and #$3f
C71C: 85 C1    sta $a1
C71E: D6 83    dec $83, x
C720: 10 52    bpl $c754
C722: D6 81    dec $81, x
C724: 10 1B    bpl $c741
C726: A9 03    lda #$03
C728: 95 83    sta $83, x
C72A: B5 81    lda $81, x
C72C: C9 F5    cmp #$f5
C72E: B0 15    bcs $c745
C730: A4 C1    ldy $a1
C732: B9 68 02 lda $0268, y
C735: 29 7F    and #$7f
C737: 99 68 02 sta $0268, y
C73A: A9 00    lda #$00
C73C: 95 80    sta $80, x
C73E: 4C 2F A7 jmp $c74f
C741: A9 20    lda #$40
C743: 95 83    sta $83, x
C745: B5 82    lda $82, x
C747: F6 82    inc $82, x
C749: 29 01    and #$01
C74B: A8       tay
C74C: B9 37 A7 lda $c757, y
C74F: 85 C2    sta $a2
C751: 20 09 A8 jsr $c809
C754: 60       rts

C763: A5 5B    lda player_state_3b
C765: 29 01    and #$01
C767: F0 6B    beq $c7d4
C769: C6 88    dec $88
C76B: 10 04    bpl $c771
C76D: A9 03    lda #$03
C76F: 85 88    sta $88
C771: A4 88    ldy $88
C773: BE B5 A7 ldx $c7d5, y
C776: B5 8A    lda $8a, x
C778: 30 4F    bmi $c7a9
C77A: C0 02    cpy #$02
C77C: 90 06    bcc $c784
C77E: B9 F1 A7 lda $c7f1, y
C781: 4C 93 A7 jmp $c793
C784: A4 89    ldy $89
C786: B9 F5 A7 lda $c7f5, y
C789: 10 05    bpl $c790
C78B: A0 00    ldy #$00
C78D: 4C 86 A7 jmp $c786
C790: C8       iny
C791: 84 89    sty $89
C793: A8       tay
C794: B9 68 02 lda $0268, y
C797: D0 5B    bne $c7d4
C799: 09 80    ora #$80
C79B: 99 68 02 sta $0268, y
C79E: 98       tya
C79F: 09 80    ora #$80
C7A1: 95 8A    sta $8a, x
C7A3: A9 00    lda #$00
C7A5: 95 8B    sta $8b, x
C7A7: 95 8C    sta $8c, x
C7A9: B5 8A    lda $8a, x
C7AB: 29 5F    and #$3f
C7AD: 85 C1    sta $a1
C7AF: D6 8C    dec $8c, x
C7B1: 10 41    bpl $c7d4
C7B3: B4 8B    ldy $8b, x
C7B5: F6 8B    inc $8b, x
C7B7: B9 E5 A7 lda $c7e5, y
C7BA: 95 8C    sta $8c, x
C7BC: B9 B9 A7 lda $c7d9, y
C7BF: D0 0E    bne $c7cf
C7C1: A4 C1    ldy $a1
C7C3: B9 68 02 lda $0268, y
C7C6: 29 7F    and #$7f
C7C8: 99 68 02 sta $0268, y
C7CB: A9 00    lda #$00
C7CD: 95 8A    sta $8a, x
C7CF: 85 C2    sta $a2
C7D1: 20 09 A8 jsr $c809
C7D4: 60       rts


C809: A9 00    lda #$00                                            
C80B: 8D 03 80 sta charbank_8003
C80E: A5 C1    lda $a1
C810: 0A       asl a
C811: AA       tax
C812: BD 3C A8 lda $c85c, x
C815: 85 CB    sta $ab
C817: BD 3D A8 lda $c85d, x
C81A: 85 CC    sta $ac
C81C: A6 C2    ldx $a2
C81E: C9 7C    cmp #$7c
C820: 90 03    bcc $c825
C822: E8       inx
C823: E8       inx
C824: E8       inx
C825: A0 02    ldy #$02
C827: BD 58 A8 lda $c838, x
C82A: D0 05    bne $c831
C82C: A5 C1    lda $a1
C82E: 18       clc
C82F: 69 9C    adc #$9c
C831: 91 CB    sta ($ab), y	; [video_address]
C833: E8       inx
C834: 88       dey
C835: 10 F0    bpl $c827
C837: 60       rts

C8B4: A9 00    lda #$00
C8B6: 8D 03 80 sta charbank_8003
C8B9: A5 96    lda $96
C8BB: D0 5D    bne $c8fa
C8BD: A6 58    ldx $38
C8BF: A5 57    lda nb_pellets_picked_37
C8C1: DD 21 A9 cmp $c941, x
C8C4: D0 7A    bne $c940
C8C6: E6 58    inc $38
C8C8: 20 B8 B9 jsr $d9d8
C8CB: 20 D7 BB jsr sync_dbb7
C8CE: A9 45    lda #$25
C8D0: 20 E7 B9 jsr $d9e7
C8D3: A9 80    lda #$80
C8D5: 85 96    sta $96
C8D7: A6 50    ldx $30
C8D9: BD 26 A9 lda $c946, x
C8DC: 85 97    sta $97
C8DE: A2 22    ldx #$42
C8E0: 8E AE 5D stx $3dce
C8E3: E8       inx
C8E4: 8E AF 5D stx $3dcf
C8E7: E8       inx
C8E8: 8E B0 5D stx $3dd0
C8EB: E8       inx
C8EC: 8E EE 5D stx $3dee
C8EF: E8       inx
C8F0: 8E EF 5D stx $3def
C8F3: E8       inx
C8F4: 8E F0 5D stx $3df0
C8F7: 4C 5A A9 jmp $c93a
C8FA: 30 12    bmi $c90e
C8FC: A6 96    ldx $96
C8FE: A9 80    lda #$80
C900: 85 96    sta $96
C902: A9 01    lda #$01
C904: 85 97    sta $97
C906: A9 C5    lda #$a5
C908: 20 E7 B9 jsr $d9e7
C90B: 4C 1F A9 jmp $c91f
C90E: A5 98    lda $98
C910: D0 4C    bne $c93e
C912: C6 97    dec $97
C914: D0 44    bne $c93a
C916: A2 00    ldx #$00
C918: 86 96    stx $96
C91A: A9 C5    lda #$a5
C91C: 20 E7 B9 jsr $d9e7
C91F: A0 02    ldy #$02
C921: BD 8A B9 lda $d98a, x
C924: 99 AE 5D sta $3dce, y
C927: E8       inx
C928: 88       dey
C929: 10 F6    bpl $c921
C92B: A9 75    lda #$75
C92D: 8D EE 5D sta $3dee
C930: A9 82    lda #$82
C932: 8D EF 5D sta $3def
C935: A9 76    lda #$76
C937: 8D F0 5D sta $3df0
C93A: A9 20    lda #$40
C93C: 85 98    sta $98
C93E: C6 98    dec $98
C940: 60       rts

C950: A9 00    lda #$00
C952: 8D 03 80 sta charbank_8003
C955: A5 99    lda $99
C957: D0 47    bne $c980
C959: A6 5A    ldx $3a
C95B: A5 57    lda nb_pellets_picked_37
C95D: DD CE A9 cmp $c9ae, x
C960: D0 2B    bne $c9ad
C962: A9 80    lda #$80
C964: 85 99    sta $99
C966: E6 5A    inc $3a
C968: A6 50    ldx $30
C96A: BD D1 A9 lda $c9b1, x
C96D: 85 9A    sta $9a
C96F: BD DB A9 lda $c9bb, x
C972: A0 02    ldy #$02
C974: 99 2E 5E sta $3e4e, y
C977: 38       sec
C978: E9 01    sbc #$01
C97A: 88       dey
C97B: 10 F7    bpl $c974
C97D: 4C C7 A9 jmp $c9a7
C980: 30 0D    bmi $c98f
C982: A6 99    ldx $99
C984: A9 80    lda #$80
C986: 85 99    sta $99
C988: A9 01    lda #$01
C98A: 85 9A    sta $9a
C98C: 4C 9B A9 jmp $c99b
C98F: A5 9B    lda $9b
C991: D0 18    bne $c9ab
C993: C6 9A    dec $9a
C995: D0 10    bne $c9a7
C997: A2 00    ldx #$00
C999: 86 99    stx $99
C99B: A0 02    ldy #$02
C99D: BD 8A B9 lda $d98a, x
C9A0: 99 2E 5E sta $3e4e, y
C9A3: E8       inx
C9A4: 88       dey
C9A5: 10 F6    bpl $c99d
C9A7: A9 20    lda #$40
C9A9: 85 9B    sta $9b
C9AB: C6 9B    dec $9b
C9AD: 60       rts

C9C5: A5 9C    lda $9c
C9C7: 10 03    bpl $c9cc
C9C9: 4C 62 AA jmp $ca62
C9CC: A2 00    ldx #$00
C9CE: AC E6 7E ldy $7ee6
C9D1: B9 BE BC lda $dcde, y
C9D4: 10 08    bpl $c9de
C9D6: AC EA 7E ldy $7eea
C9D9: B9 BE BC lda $dcde, y
C9DC: 30 16    bmi $c9f4
C9DE: E8       inx
C9DF: AC 85 5E ldy $3e85
C9E2: B9 BE BC lda $dcde, y
C9E5: 10 08    bpl $c9ef
C9E7: AC FA 7C ldy $7cfa
C9EA: B9 BE BC lda $dcde, y
C9ED: 30 05    bmi $c9f4
C9EF: A9 00    lda #$00
C9F1: 4C 6D AA jmp $ca6d
C9F4: A5 9C    lda $9c
C9F6: D0 77    bne $ca6f
C9F8: 8A       txa
C9F9: 0A       asl a
C9FA: 85 C1    sta $a1
C9FC: 0A       asl a
C9FD: AA       tax
C9FE: A9 00    lda #$00
CA00: 85 C2    sta $a2
CA02: A9 03    lda #$03
CA04: 85 C3    sta $a3
CA06: A4 C3    ldy $a3
CA08: B9 70 AA lda $ca70, y
CA0B: A8       tay
CA0C: B9 00 02 lda $0200, y
CA0F: DD 74 AA cmp $ca74, x
CA12: 90 14    bcc $ca28
CA14: DD 75 AA cmp $ca75, x
CA17: B0 0F    bcs $ca28
CA19: B9 01 02 lda $0201, y
CA1C: DD 76 AA cmp $ca76, x
CA1F: 90 07    bcc $ca28
CA21: DD 77 AA cmp $ca77, x
CA24: B0 02    bcs $ca28
CA26: E6 C2    inc $a2
CA28: C6 C3    dec $a3
CA2A: 10 BA    bpl $ca06
CA2C: A6 C2    ldx $a2
CA2E: F0 5B    beq $ca6b
CA30: CA       dex
CA31: BD 7C AA lda $ca7c, x
CA34: 20 E7 B9 jsr $d9e7
CA37: BD 80 AA lda $ca80, x
CA3A: 8D 1D 7C sta $7c1d
CA3D: BD 84 AA lda $ca84, x
CA40: 20 FD B8 jsr $d8fd
CA43: A6 C1    ldx $a1
CA45: BD 88 AA lda $ca88, x
CA48: 49 FF    eor #$ff
CA4A: 8D 1E 7C sta $7c1e
CA4D: BD 89 AA lda $ca89, x
CA50: 8D 1F 7C sta $7c1f
CA53: A9 01    lda #$01
CA55: 8D 1C 7C sta $7c1c
CA58: A5 9C    lda $9c
CA5A: 09 80    ora #$80
CA5C: 85 9C    sta $9c
CA5E: A9 80    lda #$80
CA60: 85 9D    sta $9d
CA62: C6 9D    dec $9d
CA64: D0 09    bne $ca6f
CA66: A9 00    lda #$00
CA68: 8D 1C 7C sta $7c1c
CA6B: A9 01    lda #$01
CA6D: 85 9C    sta $9c
CA6F: 60       rts

CA8C: A5 5B    lda player_state_3b
CA8E: 29 01    and #$01
CA90: F0 23    beq $cad5
CA92: A5 57    lda nb_pellets_picked_37
CA94: C5 9E    cmp $9e
CA96: F0 10    beq $caa8
CA98: 85 9E    sta $9e
CA9A: A6 50    ldx $30
CA9C: A5 34    lda $54
CA9E: DD 04 B2 cmp $d204, x
CAA1: F0 4C    beq $cacf
CAA3: C6 34    dec $54
CAA5: 4C AF AA jmp $cacf
CAA8: A5 5B    lda player_state_3b
CAAA: 29 10    and #$10
CAAC: D0 0D    bne $cabb
CAAE: A5 5B    lda player_state_3b
CAB0: 09 10    ora #$10
CAB2: 85 5B    sta player_state_3b
CAB4: A9 08    lda #$08
CAB6: 85 9F    sta $9f
CAB8: 4C DF AA jmp $cabf
CABB: C6 C0    dec $a0
CABD: D0 16    bne $cad5
CABF: A9 20    lda #$40
CAC1: 85 C0    sta $a0
CAC3: C6 9F    dec $9f
CAC5: D0 0E    bne $cad5
CAC7: A5 34    lda $54
CAC9: C9 0A    cmp #$0a
CACB: F0 02    beq $cacf
CACD: E6 34    inc $54
CACF: A5 5B    lda player_state_3b
CAD1: 29 EF    and #$ef
CAD3: 85 5B    sta player_state_3b
CAD5: 60       rts

CAD6: A5 30    lda $50
CAD8: 30 54    bmi $cb0e
CADA: A2 00    ldx #$00
CADC: A5 5B    lda player_state_3b
CADE: 29 6E    and #$6e
CAE0: F0 4D    beq $cb0f
CAE2: 2C 28 AB bit $cb48
CAE5: D0 15    bne $cafc
CAE7: A2 02    ldx #$02
CAE9: 2C 2B AB bit $cb4b
CAEC: D0 41    bne $cb0f
CAEE: A2 04    ldx #$04
CAF0: 2C 29 AB bit $cb49
CAF3: D0 1A    bne $cb0f
CAF5: A2 06    ldx #$06
CAF7: 2C 2A AB bit $cb4a
CAFA: D0 13    bne $cb0f
CAFC: A9 00    lda #$00
CAFE: 8D 08 7C sta $7c08
CB01: 8D 0C 7C sta $7c0c
CB04: 8D 10 7C sta $7c10
CB07: 8D 14 7C sta $7c14
CB0A: A9 FF    lda #$ff
CB0C: 85 30    sta $50
CB0E: 60       rts

CB0F: BD 5C AB lda table_cb3c, x		; [jump_table]
CB12: 85 CD    sta $ad
CB14: BD 5D AB lda $cb3d, x
CB17: 85 CE    sta $ae
CB19: A9 02    lda #$02
CB1B: 85 31    sta $51
CB1D: A6 2F    ldx counter_0to4_4f
CB1F: BC 24 AB ldy $cb44, x
CB22: 20 F4 B2 jsr $d2f4
CB25: 6C CD 00 jmp ($00ad)		; [indirect_jump]

CB28: 20 04 B3 jsr $d304
CB2B: E6 2F    inc counter_0to4_4f
CB2D: A5 2F    lda counter_0to4_4f
CB2F: C9 04    cmp #$04
CB31: 90 04    bcc $cb37
CB33: A9 00    lda #$00
CB35: 85 2F    sta counter_0to4_4f
CB37: C6 31    dec $51
CB39: D0 E2    bne $cb1d
CB3B: 60       rts

CB4C: A5 35    lda $55
CB4E: 29 07    and #$07
CB50: 4A       lsr a
CB51: 90 06    bcc $cb59
CB53: 20 CC AB jsr $cbac
CB56: 4C 80 AB jmp $cb80
CB59: 4A       lsr a
CB5A: 90 06    bcc $cb62
CB5C: 20 0E AC jsr $cc0e
CB5F: 4C 7A AB jmp $cb7a
CB62: 4A       lsr a
CB63: 90 06    bcc $cb6b
CB65: 20 60 AC jsr $cc60
CB68: 4C 83 AB jmp $cb83
CB6B: 20 6E AC jsr $cc6e
CB6E: 20 EA AC jsr $ccea
CB71: 20 93 B2 jsr $d293
CB74: 20 38 B2 jsr $d258
CB77: 20 EE AE jsr $ceee
CB7A: 20 0A B0 jsr player_enemy_collision_d00a
CB7D: 20 CB B0 jsr $d0ab
CB80: 20 48 B1 jsr $d128
CB83: 4C 48 AB jmp $cb28

CB86: 20 52 B0 jsr $d032
CB89: A9 04    lda #$04
CB8B: 20 D3 B0 jsr $d0b3
CB8E: C6 33    dec $53
CB90: D0 06    bne $cb98
CB92: A5 5B    lda player_state_3b
CB94: 29 BF    and #$df
CB96: 85 5B    sta player_state_3b
CB98: 4C 48 AB jmp $cb28
CB9B: 20 CB B0 jsr $d0ab
CB9E: 4C 48 AB jmp $cb28
CBA1: A5 5B    lda player_state_3b
CBA3: 09 40    ora #$20
CBA5: 85 5B    sta player_state_3b
CBA7: A9 7C    lda #$7c
CBA9: 85 33    sta $53
CBAB: 60       rts
CBAC: 20 17 B1 jsr $d117
CBAF: 20 F7 B0 jsr $d0f7
CBB2: 20 CB B0 jsr $d0ab
CBB5: A5 61    lda $61
CBB7: 29 03    and #$03
CBB9: D0 07    bne $cbc2
CBBB: A6 3F    ldx $5f
CBBD: BD F9 AB lda $cbf9, x
CBC0: 85 3F    sta $5f
CBC2: A5 5B    lda player_state_3b
CBC4: 29 01    and #$01
CBC6: F0 47    beq $cbef
CBC8: C6 67    dec $67
CBCA: D0 43    bne $cbef
CBCC: A5 35    lda $55
CBCE: 29 F8    and #$f8
CBD0: 09 02    ora #$02
CBD2: 85 35    sta $55
CBD4: A5 2F    lda counter_0to4_4f
CBD6: 0A       asl a
CBD7: AA       tax
CBD8: BD 02 AC lda $cc02, x
CBDB: 85 39    sta $59
CBDD: BD 03 AC lda $cc03, x
CBE0: 85 3A    sta $5a
CBE2: A6 2F    ldx counter_0to4_4f
CBE4: BD 0A AC lda $cc0a, x
CBE7: 85 3F    sta $5f
CBE9: A9 00    lda #$00
CBEB: 85 3D    sta $5d
CBED: 85 3E    sta $5e
CBEF: 60       rts

CC0E: 20 17 B1 jsr $d117
CC11: A5 39    lda $59
CC13: 05 3A    ora $5a
CC15: 29 07    and #$07
CC17: D0 10    bne $cc29
CC19: A0 00    ldy #$00
CC1B: B1 6B    lda ($6b), y
CC1D: C9 FF    cmp #$ff
CC1F: F0 48    beq $cc49
CC21: 85 3F    sta $5f
CC23: E6 6B    inc $6b
CC25: D0 02    bne $cc29
CC27: E6 6C    inc $6c
CC29: A9 00    lda #$00
CC2B: 85 75    sta $75
CC2D: 85 32    sta $52
CC2F: A4 3F    ldy $5f
CC31: BE F0 AB ldx $cbf0, y
CC34: 86 76    stx $76
CC36: BC 66 AE ldy $ce66, x
CC39: 20 4B AE jsr $ce2b
CC3C: A6 76    ldx $76
CC3E: B5 7B    lda $7b, x
CC40: 30 07    bmi $cc49
CC42: 20 93 B2 jsr $d293
CC45: 20 F7 B0 jsr $d0f7
CC48: 60       rts
CC49: A5 35    lda $55
CC4B: 29 F8    and #$f8
CC4D: 85 35    sta $55
CC4F: A4 3F    ldy $5f
CC51: B9 F9 AB lda $cbf9, y
CC54: 85 3F    sta $5f
CC56: A9 00    lda #$00
CC58: 85 6D    sta $6d
CC5A: 85 64    sta $64
CC5C: 20 82 AC jsr $cc82
CC5F: 60       rts
CC60: C6 67    dec $67
CC62: D0 09    bne $cc6d
CC64: A5 35    lda $55
CC66: 29 F8    and #$f8
CC68: 85 35    sta $55
CC6A: 20 CB B0 jsr $d0ab
CC6D: 60       rts
CC6E: E6 69    inc $69
CC70: A5 69    lda $69
CC72: C9 40    cmp #$20
CC74: 90 0B    bcc $cc81
CC76: A9 00    lda #$00
CC78: 85 69    sta $69
CC7A: C6 6A    dec $6a
CC7C: D0 03    bne $cc81
CC7E: 20 82 AC jsr $cc82
CC81: 60       rts
CC82: A9 00    lda #$00
CC84: 85 6E    sta $6e
CC86: A5 2F    lda counter_0to4_4f
CC88: 0A       asl a
CC89: AA       tax
CC8A: BD D2 AC lda $ccb2, x
CC8D: 85 6F    sta $6f
CC8F: BD D3 AC lda $ccb3, x
CC92: 85 70    sta $70
CC94: A5 64    lda $64
CC96: 0A       asl a
CC97: A8       tay
CC98: B1 6F    lda ($6f), y
CC9A: 85 63    sta $63
CC9C: C8       iny
CC9D: B1 6F    lda ($6f), y
CC9F: 85 6A    sta $6a
CCA1: A9 00    lda #$00
CCA3: 85 69    sta $69
CCA5: E6 64    inc $64
CCA7: A5 64    lda $64
CCA9: C9 06    cmp #$06
CCAB: 90 04    bcc $ccb1
CCAD: A9 00    lda #$00
CCAF: 85 64    sta $64
CCB1: 60       rts
CCEA: A9 00    lda #$00
CCEC: 85 75    sta $75
CCEE: 85 32    sta $52
CCF0: 20 17 B1 jsr $d117
CCF3: 20 BF AD jsr $cddf
CCF6: A9 03    lda #$03
CCF8: 85 76    sta $76
CCFA: 20 07 AE jsr $ce07
CCFD: C6 76    dec $76
CCFF: 10 F9    bpl $ccfa
CD01: A6 3F    ldx $5f
CD03: BD F9 AB lda $cbf9, x
CD06: 49 FF    eor #$ff
CD08: 25 75    and $75
CD0A: 85 75    sta $75
CD0C: A4 63    ldy $63
CD0E: A5 39    lda $59
CD10: 05 3A    ora $5a
CD12: 29 07    and #$07
CD14: F0 02    beq $cd18
CD16: A0 04    ldy #$04
CD18: 98       tya
CD19: 0A       asl a
CD1A: AA       tax
CD1B: BD 48 AD lda table_cd28, x		; [jump_table]
CD1E: 85 6F    sta $6f
CD20: BD 49 AD lda $cd29, x
CD23: 85 70    sta $70
CD25: 6C 6F 00 jmp ($006f)		; [indirect_jump]

CD32: A5 39    lda $59
CD34: 85 77    sta $77
CD36: A5 3A    lda $5a
CD38: 85 78    sta $78
CD3A: A5 5E    lda player_x_3e
CD3C: 85 79    sta $79
CD3E: A5 5F    lda player_y_3f
CD40: 85 7A    sta $7a
CD42: 20 82 AE jsr $ce82
CD45: 85 3F    sta $5f
CD47: 60       rts
CD48: A4 22    ldy $42
CD4A: BE 7E AD ldx $cd7e, y
CD4D: A5 39    lda $59
CD4F: 85 77    sta $77
CD51: A5 3A    lda $5a
CD53: 85 78    sta $78
CD55: A5 5E    lda player_x_3e
CD57: 18       clc
CD58: 7D 74 AD adc $cd74, x
CD5B: 85 79    sta $79
CD5D: A5 5F    lda player_y_3f
CD5F: 18       clc
CD60: 7D 75 AD adc $cd75, x
CD63: 85 7A    sta $7a
CD65: 20 82 AE jsr $ce82
CD68: 85 3F    sta $5f
CD6A: 60       rts
CD6B: A4 22    ldy $42
CD6D: BE F9 AB ldx $cbf9, y
CD70: 20 2D AD jsr $cd4d
CD73: 60       rts

CD87: A5 6E    lda $6e
CD89: F0 06    beq $cd91
CD8B: A5 3F    lda $5f
CD8D: 25 75    and $75
CD8F: D0 4A    bne $cdbb
CD91: 20 84 B8 jsr pseudo_random_d884
CD94: A0 03    ldy #$03
CD96: 29 0F    and #$0f
CD98: AA       tax
CD99: BD A0 AD lda $cdc0, x
CD9C: 48       pha
CD9D: 25 75    and $75
CD9F: D0 0C    bne $cdad
CDA1: 68       pla
CDA2: E8       inx
CDA3: 8A       txa
CDA4: 88       dey
CDA5: 10 EF    bpl $cd96
CDA7: A6 3F    ldx $5f
CDA9: BD F9 AB lda $cbf9, x
CDAC: 48       pha
CDAD: 68       pla
CDAE: 85 3F    sta $5f
CDB0: A6 56    ldx $36
CDB2: BD EA AC lda $ccea, x
CDB5: 29 07    and #$07
CDB7: 09 03    ora #$03
CDB9: 85 6E    sta $6e
CDBB: C6 6E    dec $6e
CDBD: E6 6D    inc $6d
CDBF: 60       rts
CDD0: A4 3F    ldy $5f
CDD2: BE F0 AB ldx $cbf0, y
CDD5: B5 7B    lda $7b, x
CDD7: 10 05    bpl $cdde
CDD9: B9 F9 AB lda $cbf9, y
CDDC: 85 3F    sta $5f
CDDE: 60       rts
CDDF: A2 00    ldx #$00
CDE1: A0 00    ldy #$00
CDE3: A5 3F    lda $5f
CDE5: 48       pha
CDE6: 29 0C    and #$0c
CDE8: F0 01    beq $cdeb
CDEA: E8       inx
CDEB: 68       pla
CDEC: 29 06    and #$06
CDEE: D0 01    bne $cdf1
CDF0: C8       iny
CDF1: B5 39    lda $59, x
CDF3: 29 07    and #$07
CDF5: D9 03 AE cmp $ce03, y
CDF8: D0 08    bne $ce02
CDFA: B5 39    lda $59, x
CDFC: 18       clc
CDFD: 79 05 AE adc $ce05, y
CE00: 95 39    sta $59, x
CE02: 60       rts

CE07: A6 76    ldx $76
CE09: BC 66 AE ldy $ce66, x
CE0C: A5 3F    lda $5f
CE0E: 3D 6A AE and $ce6a, x
CE11: F0 18    beq $ce2b
CE13: BE 6E AE ldx $ce6e, y
CE16: B5 39    lda $59, x
CE18: 18       clc
CE19: 69 01    adc #$01
CE1B: 29 07    and #$07
CE1D: C9 03    cmp #$03
CE1F: B0 0A    bcs $ce2b
CE21: B5 39    lda $59, x
CE23: 29 F8    and #$f8
CE25: 95 39    sta $59, x
CE27: A9 00    lda #$00
CE29: 95 3D    sta $5d, x
CE2B: A5 39    lda $59
CE2D: 18       clc
CE2E: 79 78 AE adc $ce78, y
CE31: 85 CB    sta $ab
CE33: A5 3A    lda $5a
CE35: 18       clc
CE36: 79 79 AE adc $ce79, y
CE39: 20 C6 BB jsr $dba6
CE3C: A6 76    ldx $76
CE3E: A0 00    ldy #$00
CE40: B1 CB    lda ($ab), y		; [video_address]
CE42: A8       tay
CE43: B9 BE BC lda $dcde, y
CE46: 08       php
CE47: C9 05    cmp #$05
CE49: D0 04    bne $ce4f
CE4B: 28       plp
CE4C: A9 80    lda #$80		  ; to set minus flag
CE4E: 08       php
CE4F: 28       plp
CE50: 95 7B    sta $7b, x
CE52: 30 0D    bmi $ce61
CE54: C9 06    cmp #$06
CE56: D0 02    bne $ce5a
CE58: 84 32    sty $52
CE5A: A5 75    lda $75
CE5C: 1D 62 AE ora $ce62, x
CE5F: 85 75    sta $75
CE61: 60       rts



CE82: A2 01    ldx #$01
CE84: A5 77    lda $77
CE86: 38       sec
CE87: E5 79    sbc $79
CE89: B0 04    bcs $ce8f
CE8B: 49 FF    eor #$ff
CE8D: A2 00    ldx #$00
CE8F: 85 73    sta $73
CE91: 86 76    stx $76
CE93: A2 02    ldx #$02
CE95: A5 78    lda $78
CE97: 38       sec
CE98: E5 7A    sbc $7a
CE9A: B0 04    bcs $cea0
CE9C: 49 FF    eor #$ff
CE9E: A2 03    ldx #$03
CEA0: C5 73    cmp $73
CEA2: 90 02    bcc $cea6
CEA4: 86 76    stx $76
CEA6: A6 76    ldx $76
CEA8: A5 75    lda $75
CEAA: 3D BE AE and $cede, x
CEAD: D0 4C    bne $cedb
CEAF: A5 3F    lda $5f
CEB1: 25 75    and $75
CEB3: D0 46    bne $cedb
CEB5: A5 6D    lda $6d
CEB7: 29 01    and #$01
CEB9: F0 07    beq $cec2
CEBB: A5 76    lda $76
CEBD: 18       clc
CEBE: 69 04    adc #$04
CEC0: 85 76    sta $76
CEC2: A0 03    ldy #$03
CEC4: A6 76    ldx $76
CEC6: BD E6 AE lda $cee6, x
CEC9: 85 76    sta $76
CECB: AA       tax
CECC: A5 75    lda $75
CECE: 3D BE AE and $cede, x
CED1: D0 08    bne $cedb
CED3: 88       dey
CED4: 10 EE    bpl $cec4
CED6: A6 3F    ldx $5f
CED8: BD F9 AB lda $cbf9, x
CEDB: E6 6D    inc $6d
CEDD: 60       rts


CEEE: AD 01 80 lda dsw2_8001                                           
CEF1: 49 FF    eor #$ff
CEF3: 29 08    and #$08
CEF5: 08       php
CEF6: A5 34    lda $54
CEF8: 28       plp
CEF9: F0 03    beq $cefe
CEFB: 18       clc
CEFC: 69 0B    adc #$0b
CEFE: 0A       asl a
CEFF: AA       tax
CF00: BD 86 AF lda $cf86, x
CF03: 85 6F    sta $6f
CF05: BD 87 AF lda $cf87, x
CF08: 85 70    sta $70
CF0A: A4 3F    ldy $5f
CF0C: BE 7E AD ldx $cd7e, y
CF0F: A5 35    lda $55
CF11: 29 04    and #$04
CF13: F0 02    beq $cf17
CF15: A2 00    ldx #$00
CF17: BD 44 AF lda table_cf24, x		; [jump_table]
CF1A: 85 71    sta $71
CF1C: BD 45 AF lda $cf25, x
CF1F: 85 72    sta $72
CF21: 6C 71 00 jmp ($0071)		; [indirect_jump]

CF2E: 60       rts
CF2F: 20 73 AF jsr $cf73
CF32: A5 3D    lda $5d
CF34: 18       clc
CF35: 65 77    adc $77
CF37: 85 3D    sta $5d
CF39: A5 39    lda $59
CF3B: 65 78    adc $78
CF3D: 85 39    sta $59
CF3F: 60       rts
CF40: 20 73 AF jsr $cf73
CF43: A5 3D    lda $5d
CF45: 38       sec
CF46: E5 77    sbc $77
CF48: 85 3D    sta $5d
CF4A: A5 39    lda $59
CF4C: E5 78    sbc $78
CF4E: 85 39    sta $59
CF50: 60       rts
CF51: 20 73 AF jsr $cf73
CF54: A5 3E    lda $5e
CF56: 38       sec
CF57: E5 77    sbc $77
CF59: 85 3E    sta $5e
CF5B: A5 3A    lda $5a
CF5D: E5 78    sbc $78
CF5F: 85 3A    sta $5a
CF61: 60       rts
CF62: 20 73 AF jsr $cf73
CF65: A5 3E    lda $5e
CF67: 18       clc
CF68: 65 77    adc $77
CF6A: 85 3E    sta $5e
CF6C: A5 3A    lda $5a
CF6E: 65 78    adc $78
CF70: 85 3A    sta $5a
CF72: 60       rts
CF73: A9 00    lda #$00
CF75: 85 78    sta $78
CF77: A4 63    ldy $63
CF79: A2 03    ldx #$03
CF7B: B1 6F    lda ($6f), y
CF7D: 0A       asl a
CF7E: 26 78    rol $78
CF80: CA       dex
CF81: 10 FA    bpl $cf7d
CF83: 85 77    sta $77
CF85: 60       rts

player_enemy_collision_d00a:
D00A: A5 5B    lda player_state_3b
D00C: 29 04    and #$04
D00E: D0 1A    bne $d02a		; player already killed, skip
D010: A5 37    lda enemy_x_57
D012: 38       sec
D013: E5 5E    sbc player_x_3e
D015: 20 4B B0 jsr $d02b
D018: B0 10    bcs $d02a
D01A: A5 38    lda enemy_y_58
D01C: 38       sec
D01D: E5 5F    sbc player_y_3f
D01F: 20 4B B0 jsr $d02b
D022: B0 06    bcs $d02a
; player killed, insert invincible cheat here
D024: A5 5B    lda player_state_3b
D026: 09 04    ora #$04
D028: 85 5B    sta player_state_3b
D02A: 60       rts
D02B: B0 02    bcs $d02f
D02D: 49 FF    eor #$ff
D02F: C9 05    cmp #$05
D031: 60       rts
D032: A5 2F    lda counter_0to4_4f
D034: 0A       asl a
D035: AA       tax
D036: BD 2B B0 lda $d04b, x
D039: 85 6F    sta $6f
D03B: BD 2C B0 lda $d04c, x
D03E: 85 70    sta $70
D040: BD 33 B0 lda $d053, x
D043: 85 71    sta $71
D045: BD 34 B0 lda $d054, x
D048: 85 72    sta $72
D04A: 60       rts

D0A4: 98       tya
D0A5: 99 99 8D sta $8d99, y
D0A8: 8E 8F 8E stx $8e8f
D0AB: 20 52 B0 jsr $d032
D0AE: A4 3F    ldy $5f
D0B0: B9 F0 AB lda $cbf0, y
D0B3: 85 77    sta $77
D0B5: 0A       asl a
D0B6: 0A       asl a
D0B7: 85 78    sta $78
D0B9: A5 61    lda $61
D0BB: 29 07    and #$07
D0BD: 4A       lsr a
D0BE: 18       clc
D0BF: 65 78    adc $78
D0C1: 85 78    sta $78
D0C3: A6 77    ldx $77
D0C5: A5 35    lda $55
D0C7: 29 04    and #$04
D0C9: F0 02    beq $d0cd
D0CB: A2 05    ldx #$05
D0CD: BD F1 B0 lda $d0f1, x
D0D0: A0 00    ldy #$00
D0D2: 91 6F    sta ($6f), y		; [video_address]
D0D4: A4 78    ldy $78
D0D6: B1 71    lda ($71), y
D0D8: A0 01    ldy #$01
D0DA: 91 6F    sta ($6f), y		; [video_address]
D0DC: C8       iny
D0DD: A5 39    lda $59
D0DF: 18       clc
D0E0: 69 0C    adc #$0c
D0E2: 49 FF    eor #$ff
D0E4: 91 6F    sta ($6f), y		; [video_address]
D0E6: C8       iny
D0E7: A5 3A    lda $5a
D0E9: 38       sec
D0EA: E9 04    sbc #$04
D0EC: 91 6F    sta ($6f), y		; [video_address]
D0EE: E6 61    inc $61
D0F0: 60       rts

D0F7: A4 3F    ldy $5f
D0F9: BE 7E AD ldx $cd7e, y
D0FC: A5 39    lda $59
D0FE: 18       clc
D0FF: 7D 0D B1 adc $d10d, x
D102: 85 39    sta $59
D104: A5 3A    lda $5a
D106: 18       clc
D107: 7D 0E B1 adc $d10e, x
D10A: 85 3A    sta $5a
D10C: 60       rts

D117: A5 37    lda enemy_x_57
D119: 85 39    sta $59
D11B: A5 38    lda enemy_y_58
D11D: 85 3A    sta $5a
D11F: A5 3B    lda $5b
D121: 85 3D    sta $5d
D123: A5 3C    lda $5c
D125: 85 3E    sta $5e
D127: 60       rts

D128: A5 39    lda $59
D12A: 85 37    sta enemy_x_57
D12C: A5 3A    lda $5a
D12E: 85 38    sta enemy_y_58
D130: A5 3D    lda $5d
D132: 85 3B    sta $5b
D134: A5 3E    lda $5e
D136: 85 3C    sta $5c
D138: 60       rts
D139: A9 03    lda #$03
D13B: 85 C3    sta $a3
D13D: A5 C3    lda $a3
D13F: 0A       asl a
D140: AA       tax
D141: BD 94 B1 lda $d194, x
D144: 85 C5    sta $a5
D146: BD 95 B1 lda $d195, x
D149: 85 C6    sta $a6
D14B: BD 9C B1 lda $d19c, x
D14E: 85 C9    sta $a9
D150: BD 9D B1 lda $d19d, x
D153: 85 CA    sta $aa
D155: A0 17    ldy #$17
D157: B1 C9    lda ($a9), y
D159: 91 C5    sta ($a5), y
D15B: 88       dey
D15C: 10 F9    bpl $d157
D15E: C6 C3    dec $a3
D160: 10 BB    bpl $d13d
D162: A6 50    ldx $30
D164: BD 04 B2 lda $d204, x
D167: 85 34    sta $54
D169: E0 04    cpx #$04
D16B: 90 0A    bcc $d177
D16D: A9 30    lda #$50
D16F: 8D 16 02 sta $0216
D172: A9 B2    lda #$d2
D174: 8D 17 02 sta $0217
D177: 8A       txa
D178: 0A       asl a
D179: 0A       asl a
D17A: AA       tax
D17B: BD 0E B2 lda $d20e, x
D17E: 8D 12 02 sta $0212
D181: BD 0F B2 lda $d20f, x
D184: 8D 4C 02 sta $022c
D187: BD 10 B2 lda $d210, x
D18A: 8D 26 02 sta $0246
D18D: BD 11 B2 lda $d211, x
D190: 8D 60 02 sta $0260
D193: 60       rts



D258: A4 3F    ldy $5f
D25A: BE F0 AB ldx $cbf0, y
D25D: B5 7B    lda $7b, x
D25F: C9 04    cmp #$04
D261: D0 4B    bne $d28e
D263: A5 3F    lda $5f
D265: 29 03    and #$03
D267: F0 45    beq $d28e
D269: 4A       lsr a
D26A: AA       tax
D26B: A5 39    lda $59
D26D: 38       sec
D26E: FD 8F B2 sbc $d28f, x
D271: B0 02    bcs $d275
D273: 49 FF    eor #$ff
D275: C9 04    cmp #$04
D277: B0 15    bcs $d28e
D279: A5 35    lda $55
D27B: 29 F8    and #$f8
D27D: 09 04    ora #$04
D27F: 85 35    sta $55
D281: A9 10    lda #$10
D283: 85 67    sta $67
D285: BD 91 B2 lda $d291, x
D288: 85 39    sta $59
D28A: A9 00    lda #$00
D28C: 85 3D    sta $5d
D28E: 60       rts

D293: A4 3F    ldy $5f                                             
D295: BE F0 AB ldx $cbf0, y                                        
D298: B5 7B    lda $7b, x                                          
D29A: C9 06    cmp #$06                                            
D29C: D0 41    bne $d2bf
D29E: A5 65    lda $65
D2A0: 30 41    bmi $d2c3
D2A2: A5 32    lda $52
D2A4: 38       sec
D2A5: E9 9C    sbc #$9c
D2A7: A8       tay
D2A8: 09 80    ora #$80
D2AA: 85 65    sta $65
D2AC: A6 2F    ldx counter_0to4_4f
D2AE: B9 68 02 lda $0268, y
D2B1: 1D EC B2 ora $d2ec, x
D2B4: 99 68 02 sta $0268, y
D2B7: A5 3F    lda $5f
D2B9: 85 60    sta $60
D2BB: A9 00    lda #$00
D2BD: 85 68    sta $68
D2BF: A5 65    lda $65
D2C1: 10 48    bpl $d2eb
D2C3: E6 68    inc $68
D2C5: A5 60    lda $60
D2C7: C5 3F    cmp $5f
D2C9: F0 04    beq $d2cf
D2CB: C6 68    dec $68
D2CD: C6 68    dec $68
D2CF: A5 68    lda $68
D2D1: 30 04    bmi $d2d7
D2D3: C9 0E    cmp #$0e
D2D5: 90 14    bcc $d2eb
D2D7: A6 2F    ldx counter_0to4_4f
D2D9: A5 65    lda $65
D2DB: 29 5F    and #$3f
D2DD: A8       tay
D2DE: A9 00    lda #$00
D2E0: 85 65    sta $65
D2E2: B9 68 02 lda $0268, y
D2E5: 3D F0 B2 and $d2f0, x
D2E8: 99 68 02 sta $0268, y
D2EB: 60       rts
D2F4: 84 C4    sty $a4                                             
D2F6: A2 00    ldx #$00                                            
D2F8: B9 00 02 lda $0200, y
D2FB: 95 35    sta $55, x
D2FD: C8       iny
D2FE: E8       inx
D2FF: E0 1A    cpx #$1a
D301: 90 F5    bcc $d2f8
D303: 60       rts
D304: A4 C4    ldy $a4
D306: A2 00    ldx #$00
D308: B5 35    lda $55, x
D30A: 99 00 02 sta $0200, y
D30D: C8       iny
D30E: E8       inx
D30F: E0 1A    cpx #$1a
D311: 90 F5    bcc $d308
D313: 60       rts

D314: 20 66 BA jsr clear_part_of_screen_da66
D317: 20 AE BB jsr $dbce
D31A: 20 97 B8 jsr $d897
D31D: A9 FF    lda #$ff
D31F: 8D C3 02 sta $02a3
D322: 8D C4 02 sta $02a4
D325: 8D C5 02 sta $02a5
D328: 8D D5 02 sta $02b5
D32B: 8D D6 02 sta $02b6
D32E: 8D D7 02 sta $02b7
D331: 60       rts

D332: 20 66 BA jsr clear_part_of_screen_da66
D335: 20 B8 BB jsr $dbd8
D338: 20 BD BB jsr $dbdd
D33B: 20 C6 B3 jsr $d3a6
D33E: 20 A2 BB jsr $dbc2
D341: 20 E2 BB jsr $dbe2
D344: 20 D7 BB jsr sync_dbb7
D347: 20 CD B3 jsr $d3ad
D34A: 20 A2 BB jsr $dbc2
D34D: 20 E7 BB jsr $dbe7
D350: 20 D7 BB jsr sync_dbb7
D353: 20 D4 B3 jsr $d3b4
D356: 20 A2 BB jsr $dbc2
D359: 20 EC BB jsr $dbec
D35C: 20 D7 BB jsr sync_dbb7
D35F: 20 DB B3 jsr $d3bb
D362: 20 A2 BB jsr $dbc2
D365: 20 F1 BB jsr $dbf1
D368: A9 40    lda #$20
D36A: 20 A4 BB jsr wait_dbc4
D36D: 20 F6 BB jsr $dbf6
D370: 20 FB BB jsr $dbfb
D373: 20 00 BC jsr $dc00
D376: 20 05 BC jsr $dc05
D379: 20 0A BC jsr $dc0a
D37C: 20 F3 B3 jsr $d3f3
D37F: 20 0F BC jsr $dc0f
D382: 20 14 BC jsr $dc14
D385: A9 50    lda #$30
D387: 20 A4 BB jsr wait_dbc4
D38A: 20 94 B4 jsr $d494
D38D: A0 5F    ldy #$3f
D38F: A9 00    lda #$00
D391: 99 E0 5D sta $3de0, y
D394: 88       dey
D395: 10 FA    bpl $d391
D397: 20 19 BC jsr $dc19
D39A: 20 AE B5 jsr $d5ce
D39D: A9 40    lda #$20
D39F: 20 A4 BB jsr wait_dbc4
D3A2: 20 06 B6 jsr $d606
D3A5: 60       rts
D3A6: A2 00    ldx #$00
D3A8: A0 00    ldy #$00
D3AA: 4C DF B3 jmp $d3bf
D3AD: A2 02    ldx #$02
D3AF: A0 01    ldy #$01
D3B1: 4C DF B3 jmp $d3bf
D3B4: A2 04    ldx #$04
D3B6: A0 02    ldy #$02
D3B8: 4C DF B3 jmp $d3bf
D3BB: A2 06    ldx #$06
D3BD: A0 03    ldy #$03
D3BF: BD E2 B3 lda $d3e2, x
D3C2: 85 C5    sta $a5
D3C4: BD E3 B3 lda $d3e3, x
D3C7: 85 C6    sta $a6
D3C9: B9 EA B3 lda $d3ea, y
D3CC: 85 C3    sta $a3
D3CE: A2 03    ldx #$03
D3D0: BC EF B3 ldy $d3ef, x
D3D3: A9 02    lda #$02
D3D5: 8D 03 80 sta charbank_8003
D3D8: A5 C3    lda $a3
D3DA: 91 C5    sta ($a5), y			; [video_address]
D3DC: E6 C3    inc $a3
D3DE: CA       dex
D3DF: 10 EF    bpl $d3d0
D3E1: 60       rts


D3F3: A9 01    lda #$01
D3F5: 8D 03 80 sta charbank_8003
D3F8: A9 04    lda #$04
D3FA: 85 C3    sta $a3
D3FC: A5 C3    lda $a3
D3FE: 0A       asl a
D3FF: AA       tax
D400: BD 71 B4 lda $d471, x
D403: 85 C5    sta $a5
D405: BD 72 B4 lda $d472, x
D408: 85 C6    sta $a6
D40A: BD 7B B4 lda $d47b, x
D40D: 85 C7    sta $a7
D40F: BD 7C B4 lda $d47c, x
D412: 85 C8    sta $a8
D414: BD 85 B4 lda $d485, x
D417: 85 C9    sta $a9
D419: BD 86 B4 lda $d486, x
D41C: 85 CA    sta $aa
D41E: A2 00    ldx #$00
D420: A4 C3    ldy $a3
D422: B9 8F B4 lda $d48f, y
D425: 81 C5    sta ($a5, x)		; [video_address]
D427: 20 7E BA jsr inc_a5_16_bit_pointer_da7e
D42A: A9 C5    lda #$a5
D42C: 81 C5    sta ($a5, x)		; [video_address]
D42E: 20 7E BA jsr inc_a5_16_bit_pointer_da7e
D431: A0 03    ldy #$03
D433: A1 C7    lda ($a7, x)
D435: 81 C5    sta ($a5, x)		; [video_address]
D437: 20 78 BA jsr inc_a7_16_bit_pointer_da78
D43A: 88       dey
D43B: D0 F6    bne $d433
D43D: A5 C5    lda $a5
D43F: 18       clc
D440: 69 03    adc #$03
D442: 85 C5    sta $a5
D444: A9 EA    lda #$ea
D446: 81 C5    sta ($a5, x)		; [video_address]
D448: 20 7E BA jsr inc_a5_16_bit_pointer_da7e
D44B: A0 03    ldy #$03
D44D: A1 C9    lda ($a9, x)
D44F: 20 3D B4 jsr $d45d
D452: 20 85 BA jsr inc_a9_16_bit_pointer_da85
D455: 88       dey
D456: D0 F5    bne $d44d
D458: C6 C3    dec $a3
D45A: 10 C0    bpl $d3fc
D45C: 60       rts
D45D: 48       pha
D45E: 4A       lsr a
D45F: 4A       lsr a
D460: 4A       lsr a
D461: 4A       lsr a
D462: 20 66 B4 jsr $d466
D465: 68       pla
D466: 29 0F    and #$0f
D468: 18       clc
D469: 69 81    adc #$81
D46B: 81 C5    sta ($a5, x)		; [video_address]
D46D: 20 7E BA jsr inc_a5_16_bit_pointer_da7e
D470: 60       rts

D494: A9 00    lda #$00                                            
D496: 85 35    sta $55
D498: 85 36    sta $56
D49A: 85 37    sta enemy_x_57
D49C: 85 38    sta enemy_y_58
D49E: A9 0F    lda #$0f
D4A0: 85 3C    sta $5c
D4A2: 85 39    sta $59
; write character to sprite memory
D4A4: A9 F8    lda #$f8
D4A6: 8D 02 7C sta $7c02
D4A9: A9 94    lda #$94
D4AB: 8D 03 7C sta $7c03
D4AE: 20 D7 BB jsr sync_dbb7
D4B1: 20 B1 BC jsr special_writes_dcd1
D4B4: 20 9C BC jsr $dc9c
D4B7: 20 5C B5 jsr $d53c
D4BA: A5 36    lda $56
D4BC: 10 1D    bpl $d4db
D4BE: C6 38    dec enemy_y_58
D4C0: D0 EC    bne $d4ae
D4C2: E6 36    inc $56
D4C4: A5 36    lda $56
D4C6: 29 7F    and #$7f
D4C8: 85 36    sta $56
D4CA: A9 00    lda #$00
D4CC: 8D 6E 5E sta $3e6e
D4CF: 8D 6F 5E sta $3e6f
D4D2: 8D 70 5E sta $3e70
D4D5: A5 36    lda $56
D4D7: C9 04    cmp #$04
D4D9: B0 36    bcs $d531
D4DB: A6 35    ldx $55
D4DD: BD 81 B5 lda $d581, x
D4E0: 8D 00 7C sta $7c00
D4E3: A5 37    lda enemy_x_57
D4E5: 29 07    and #$07
D4E7: 4A       lsr a
D4E8: A8       tay
D4E9: B9 83 B5 lda $d583, y
D4EC: 8D 01 7C sta $7c01
D4EF: E6 37    inc enemy_x_57
D4F1: AD 02 7C lda $7c02
D4F4: 18       clc
D4F5: 7D 87 B5 adc $d587, x
D4F8: 8D 02 7C sta $7c02
D4FB: DD 89 B5 cmp $d589, x
D4FE: D0 09    bne $d509
D500: A5 35    lda $55
D502: 49 01    eor #$01
D504: 85 35    sta $55
D506: 4C CE B4 jmp $d4ae
D509: DD 8B B5 cmp $d58b, x
D50C: D0 08    bne $d516
D50E: A0 04    ldy #$04
D510: 20 64 B5 jsr $d564
D513: 4C CE B4 jmp $d4ae
D516: C9 7C    cmp #$7c
D518: D0 14    bne $d52e
D51A: A4 36    ldy $56
D51C: 20 64 B5 jsr $d564
D51F: A5 36    lda $56
D521: 09 80    ora #$80
D523: 85 36    sta $56
D525: A9 00    lda #$00
D527: 8D 00 7C sta $7c00
D52A: A9 40    lda #$20
D52C: 85 38    sta enemy_y_58
D52E: 4C CE B4 jmp $d4ae
D531: A5 06    lda $06
D533: 8D 01 80 sta dsw2_8001
D536: A2 0B    ldx #$0b
D538: 20 37 B5 jsr $d557
D53B: 60       rts
D53C: A9 01    lda #$01
D53E: 8D 03 80 sta charbank_8003
D541: C6 39    dec $59
D543: A5 39    lda $59
D545: 29 7F    and #$7f
D547: D0 1A    bne $d563
D549: A5 39    lda $59
D54B: 49 8F    eor #$8f
D54D: 85 39    sta $59
D54F: A2 0B    ldx #$0b
D551: A5 39    lda $59
D553: 10 02    bpl $d557
D555: A2 17    ldx #$17
D557: A0 0B    ldy #$0b
D559: BD 8D B5 lda $d58d, x
D55C: 99 CB 5C sta $3cab, y
D55F: CA       dex
D560: 88       dey
D561: 10 F6    bpl $d559
D563: 60       rts
D564: B9 C5 B5 lda $d5a5, y
D567: 85 C3    sta $a3
D569: A2 05    ldx #$05
D56B: A4 C3    ldy $a3
D56D: A9 00    lda #$00
D56F: 8D 03 80 sta charbank_8003
D572: B9 CA B5 lda $d5aa, y
D575: BC A8 B5 ldy $d5c8, x
D578: 99 6E 5E sta $3e6e, y
D57B: E6 C3    inc $a3
D57D: CA       dex
D57E: 10 EB    bpl $d56b
D580: 60       rts


D5CE: A0 06    ldy #$06
D5D0: A9 01    lda #$01
D5D2: 8D 03 80 sta charbank_8003
D5D5: A9 11    lda #$11
D5D7: 85 C5    sta $a5
D5D9: A9 5E    lda #$3e
D5DB: 85 C6    sta $a6
D5DD: A2 00    ldx #$00
D5DF: A5 0D    lda $0d
D5E1: C9 FF    cmp #$ff
D5E3: F0 0E    beq $d5f3
D5E5: 20 66 B4 jsr $d466
D5E8: A5 0C    lda $0c
D5EA: 20 3D B4 jsr $d45d
D5ED: A5 0B    lda $0b
D5EF: 20 3D B4 jsr $d45d
D5F2: 60       rts
D5F3: A2 06    ldx #$06
D5F5: BD FF B5 lda $d5ff, x
D5F8: 9D 11 5E sta $3e11, x
D5FB: CA       dex
D5FC: 10 F7    bpl $d5f5
D5FE: 60       rts
D606: A9 00    lda #$00
D608: 85 35    sta $55
D60A: 85 36    sta $56
D60C: 85 37    sta enemy_x_57
D60E: 85 38    sta enemy_y_58
D610: 85 3B    sta $5b
D612: A9 0F    lda #$0f
D614: 85 39    sta $59
D616: A9 F8    lda #$f8
D618: 8D 02 7C sta $7c02
D61B: 8D 06 7C sta $7c06
D61E: A9 94    lda #$94
D620: 8D 03 7C sta $7c03
D623: 8D 07 7C sta $7c07
D626: 20 D7 BB jsr sync_dbb7
D629: 20 B1 BC jsr special_writes_dcd1
D62C: 20 9C BC jsr $dc9c
D62F: 20 5C B5 jsr $d53c
D632: A5 36    lda $56
D634: 10 50    bpl $d666
D636: C6 36    dec $56
D638: A5 36    lda $56
D63A: 29 7F    and #$7f
D63C: D0 E8    bne $d626
D63E: 85 36    sta $56
D640: 85 3A    sta $5a
D642: A2 00    ldx #$00
D644: 20 E8 B6 jsr $d6e8
D647: 20 22 B7 jsr $d742
D64A: A9 A0    lda #$c0
D64C: 85 3B    sta $5b
D64E: E6 35    inc $55
D650: A5 35    lda $55
D652: C9 02    cmp #$02
D654: 90 10    bcc $d666
D656: A0 02    ldy #$02
D658: A9 01    lda #$01
D65A: 8D 03 80 sta charbank_8003
D65D: B9 4D B7 lda $d72d, y
D660: 99 6E 5E sta $3e6e, y
D663: 88       dey
D664: 10 F2    bpl $d658
D666: A9 03    lda #$03
D668: 8D 00 7C sta $7c00
D66B: A5 38    lda enemy_y_58
D66D: 29 07    and #$07
D66F: 4A       lsr a
D670: AA       tax
D671: BD 83 B5 lda $d583, x
D674: 8D 01 7C sta $7c01
D677: E6 38    inc enemy_y_58
D679: A5 37    lda enemy_x_57
D67B: 30 0B    bmi $d688
D67D: AD 02 7C lda $7c02
D680: C9 B7    cmp #$d7
D682: B0 59    bcs $d6bd
D684: A9 80    lda #$80
D686: 85 37    sta enemy_x_57
D688: A9 03    lda #$03
D68A: 8D 04 7C sta $7c04
D68D: BD E4 B6 lda $d6e4, x
D690: 8D 05 7C sta $7c05
D693: A5 3B    lda $5b
D695: 10 43    bpl $d6ba
D697: C6 3B    dec $5b
D699: A5 3B    lda $5b
D69B: 29 7F    and #$7f
D69D: D0 87    bne $d626
D69F: 85 3B    sta $5b
D6A1: A5 35    lda $55
D6A3: C9 02    cmp #$02
D6A5: 90 DF    bcc $d666
D6A7: A5 06    lda $06
D6A9: 8D 01 80 sta dsw2_8001
D6AC: A9 00    lda #$00
D6AE: 85 3A    sta $5a
D6B0: AA       tax
D6B1: 20 E8 B6 jsr $d6e8
D6B4: A9 20    lda #$40
D6B6: 20 A4 BB jsr wait_dbc4
D6B9: 60       rts
D6BA: CE 06 7C dec $7c06
D6BD: CE 02 7C dec $7c02
D6C0: A6 35    ldx $55
D6C2: AD 02 7C lda $7c02
D6C5: DD E2 B6 cmp $d6e2, x
D6C8: D0 15    bne $d6df
D6CA: A9 00    lda #$00
D6CC: 8D 00 7C sta $7c00
D6CF: 8D 04 7C sta $7c04
D6D2: A9 01    lda #$01
D6D4: 85 3A    sta $5a
D6D6: A2 02    ldx #$02
D6D8: 20 E8 B6 jsr $d6e8
D6DB: A9 A0    lda #$c0
D6DD: 85 36    sta $56
D6DF: 4C 46 B6 jmp $d626
D6E8: BD 05 B7 lda $d705, x
D6EB: 85 3B    sta $5b
D6ED: BD 06 B7 lda $d706, x
D6F0: 85 3C    sta $5c
D6F2: A0 11    ldy #$11
D6F4: BE 50 B7 ldx $d730, y
D6F7: A5 3A    lda $5a
D6F9: 8D 03 80 sta charbank_8003
D6FC: B1 3B    lda ($5b), y
D6FE: 9D 2D 5E sta $3e4d, x
D701: 88       dey
D702: 10 F0    bpl $d6f4
D704: 60       rts


D742: A5 35    lda $55                                             
D744: 0A       asl a                                               
D745: AA       tax
D746: BD 3B B7 lda $d75b, x
D749: 85 3B    sta $5b
D74B: BD 3C B7 lda $d75c, x
D74E: 85 3C    sta $5c
D750: A0 02    ldy #$02
D752: B9 3F B7 lda $d75f, y
D755: 91 3B    sta ($5b), y		; [video_address]
D757: 88       dey
D758: 10 F8    bpl $d752
D75A: 60       rts

D762: 20 66 BA jsr clear_part_of_screen_da66
D765: 20 B8 BB jsr $dbd8
D768: 20 1E BC jsr $dc1e
D76B: 20 F6 BB jsr $dbf6
D76E: 20 FB BB jsr $dbfb
D771: 20 00 BC jsr $dc00
D774: 20 05 BC jsr $dc05
D777: 20 0A BC jsr $dc0a
D77A: 20 F3 B3 jsr $d3f3
D77D: 20 0F BC jsr $dc0f
D780: 20 4D BC jsr $dc2d
D783: A5 02    lda nb_credits_02
D785: C9 02    cmp #$02
D787: B0 06    bcs $d78f
D789: 20 43 BC jsr $dc23
D78C: 4C 92 B7 jmp $d792
D78F: 20 48 BC jsr $dc28
D792: A5 02    lda nb_credits_02
D794: 48       pha
D795: A0 00    ldy #$00
D797: 4A       lsr a
D798: 4A       lsr a
D799: 4A       lsr a
D79A: 4A       lsr a
D79B: 20 C0 B7 jsr $d7a0
D79E: C8       iny
D79F: 68       pla
D7A0: 29 0F    and #$0f
D7A2: 18       clc
D7A3: 48       pha
D7A4: A9 01    lda #$01
D7A6: 8D 03 80 sta charbank_8003
D7A9: 68       pla
D7AA: 69 01    adc #$01
D7AC: 99 BA 5F sta $3fda, y
D7AF: 60       rts
D7B0: A5 5B    lda player_state_3b
D7B2: 29 01    and #$01
D7B4: F0 49    beq $d7df
D7B6: A5 5B    lda player_state_3b
D7B8: 29 08    and #$08
D7BA: D0 43    bne $d7df
D7BC: A5 57    lda nb_pellets_picked_37
D7BE: C9 89    cmp #$89
D7C0: D0 1D    bne $d7df
D7C2: A5 D0    lda exit_open_flag_b0
D7C4: 30 0F    bmi $d7d5
; all pellets have been picked: open the exits
D7C6: 09 80    ora #$80
D7C8: 49 02    eor #$02
D7CA: 85 D0    sta exit_open_flag_b0
D7CC: 29 02    and #$02
D7CE: 20 E0 B7 jsr $d7e0
D7D1: A9 04    lda #$04
D7D3: 85 D1    sta $b1
D7D5: C6 D1    dec $b1
D7D7: D0 06    bne $d7df
D7D9: A5 D0    lda exit_open_flag_b0
D7DB: 29 7F    and #$7f
D7DD: 85 D0    sta exit_open_flag_b0
D7DF: 60       rts
D7E0: 85 C1    sta $a1
D7E2: 0A       asl a
D7E3: 65 C1    adc $a1
D7E5: 0A       asl a
D7E6: 0A       asl a
D7E7: AA       tax
D7E8: A9 03    lda #$03
D7EA: 85 C1    sta $a1
D7EC: A5 C1    lda $a1
D7EE: 0A       asl a
D7EF: A8       tay
D7F0: B9 0F B8 lda $d80f, y
D7F3: 85 CB    sta $ab
D7F5: B9 10 B8 lda $d810, y
D7F8: 85 CC    sta $ac
D7FA: A0 02    ldy #$02
D7FC: A9 00    lda #$00
D7FE: 8D 03 80 sta charbank_8003
D801: BD 17 B8 lda $d817, x
D804: 91 CB    sta ($ab), y		; [video_address]
D806: E8       inx
D807: 88       dey
D808: 10 F7    bpl $d801
D80A: C6 C1    dec $a1
D80C: 10 BE    bpl $d7ec
D80E: 60       rts

D83B: A9 00    lda #$00
D83D: 8D 03 80 sta charbank_8003
D840: A5 CF    lda $af
D842: 29 7F    and #$7f
D844: D0 4E    bne $d874
D846: A5 CF    lda $af
D848: 49 8A    eor #$8a
D84A: 85 CF    sta $af
D84C: A9 5C    lda #$3c
D84E: 85 C6    sta $a6
D850: A5 06    lda $06
D852: 29 01    and #$01
D854: A8       tay
D855: BE 79 B8 ldx $d879, y
D858: B9 77 B8 lda $d877, y
D85B: 85 C5    sta $a5
D85D: A5 CF    lda $af
D85F: 10 08    bpl $d869
D861: A5 5B    lda player_state_3b
D863: 29 0C    and #$0c
D865: D0 02    bne $d869
D867: A2 08    ldx #$08
D869: A0 02    ldy #$02
D86B: BD 7B B8 lda $d87b, x
D86E: 91 C5    sta ($a5), y		; [video_address]
D870: CA       dex
D871: 88       dey
D872: 10 F7    bpl $d86b
D874: C6 CF    dec $af
D876: 60       rts

pseudo_random_d884:
D884: A6 56    ldx $36
D886: BD B6 AA lda $cad6, x
D889: 18       clc
D88A: 65 55    adc $35
D88C: 85 55    sta $35
D88E: 2A       rol a
D88F: 2A       rol a
D890: 2A       rol a
D891: 2A       rol a
D892: 55 00    eor $00, x
D894: E6 56    inc $36
D896: 60       rts

D897: A2 0A    ldx #$0a
D899: A0 02    ldy #$02
D89B: 4C C5 B8 jmp $d8a5
D89E: A2 53    ldx #$33
D8A0: A5 06    lda $06
D8A2: 29 01    and #$01
D8A4: A8       tay
D8A5: A9 00    lda #$00
D8A7: 8D 03 80 sta charbank_8003
D8AA: B9 AF B8 lda $d8cf, y
D8AD: 85 C5    sta $a5
D8AF: A9 5C    lda #$3c
D8B1: 85 C6    sta $a6
D8B3: A9 03    lda #$03
D8B5: 85 75    sta $75
D8B7: A9 05    lda #$05
D8B9: 85 76    sta $76
D8BB: B5 00    lda $00, x
D8BD: 48       pha
D8BE: 4A       lsr a
D8BF: 4A       lsr a
D8C0: 4A       lsr a
D8C1: 4A       lsr a
D8C2: 20 B2 B8 jsr $d8d2
D8C5: 68       pla
D8C6: 20 B2 B8 jsr $d8d2
D8C9: CA       dex
D8CA: C6 75    dec $75
D8CC: D0 ED    bne $d8bb
D8CE: 60       rts

D8D2: 29 0F    and #$0f
D8D4: D0 18    bne $d8ee
D8D6: A4 76    ldy $76
D8D8: F0 18    beq $d8f2
D8DA: C6 76    dec $76
D8DC: D0 17    bne $d8f5
D8DE: 48       pha
D8DF: A0 00    ldy #$00
D8E1: 84 76    sty $76
D8E3: A9 0B    lda #$0b
D8E5: 91 C5    sta ($a5), y		; [video_address]
D8E7: 20 7E BA jsr inc_a5_16_bit_pointer_da7e
D8EA: 68       pla
D8EB: 4C F2 B8 jmp $d8f2
D8EE: A4 76    ldy $76
D8F0: D0 EC    bne $d8de
D8F2: 18       clc
D8F3: 69 01    adc #$01
D8F5: A0 00    ldy #$00
D8F7: 91 C5    sta ($a5), y		; [video_address]
D8F9: 20 7E BA jsr inc_a5_16_bit_pointer_da7e
D8FC: 60       rts

D8FD: AA       tax
D8FE: F8       sed
D8FF: BD 3A B9 lda $d95a, x
D902: 18       clc
D903: 65 51    adc $31
D905: 85 51    sta $31
D907: BD 3B B9 lda $d95b, x
D90A: 65 52    adc $32
D90C: 85 52    sta $32
D90E: BD 3C B9 lda $d95c, x
D911: 65 53    adc $33
D913: 85 53    sta $33
D915: D8       cld
D916: 38       sec
D917: A5 51    lda $31
D919: E5 08    sbc $08
D91B: A5 52    lda $32
D91D: E5 09    sbc $09
D91F: A5 53    lda $33
D921: E5 0A    sbc $0a
D923: 90 0C    bcc $d931
D925: A5 51    lda $31
D927: 85 08    sta $08
D929: A5 52    lda $32
D92B: 85 09    sta $09
D92D: A5 53    lda $33
D92F: 85 0A    sta $0a
D931: A5 4C    lda $2c
D933: 29 01    and #$01
D935: D0 42    bne $d959
D937: 38       sec
D938: A5 51    lda $31
D93A: E5 0B    sbc $0b
D93C: A5 52    lda $32
D93E: E5 0C    sbc $0c
D940: A5 53    lda $33
D942: E5 0D    sbc $0d
D944: 90 13    bcc $d959
D946: A5 4C    lda $2c
D948: 09 01    ora #$01
D94A: 85 4C    sta $2c
D94C: E6 4D    inc $2d
D94E: 20 8C BA jsr display_nb_lives_da8c
D951: A9 0B    lda #$0b
D953: 20 E7 B9 jsr $d9e7
D956: 20 D7 BB jsr sync_dbb7
D959: 60       rts

clear_zero_page_d9ba:
D9BA: A2 02    ldx #$02
D9BC: A9 00    lda #$00
D9BE: 95 00    sta $00, x
D9C0: E8       inx
D9C1: E0 E4    cpx #$e4
D9C3: 90 F9    bcc $d9be
D9C5: 60       rts

D9C6: A2 93    ldx #$93
D9C8: 4C AD B9 jmp $d9cd

clear_page_2_d9cb:
D9CB: A2 FF    ldx #$ff
D9CD: A9 00    lda #$00
D9CF: 9D 00 02 sta $0200, x
D9D2: CA       dex
D9D3: E0 FF    cpx #$ff
D9D5: D0 F6    bne $d9cd
D9D7: 60       rts

D9D8: A6 58    ldx $38
D9DA: BD F3 B9 lda $d9f3, x
D9DD: 4C E7 B9 jmp $d9e7

D9E0: A6 58    ldx $38
D9E2: BD F3 B9 lda $d9f3, x
D9E5: 09 80    ora #$80
D9E7: 86 D2    stx $b2
D9E9: A6 04    ldx $04
D9EB: F0 03    beq $d9f0
D9ED: 8D 02 90 sta system_9002
D9F0: A6 D2    ldx $b2
D9F2: 60       rts

one_less_credit_d9f8:
D9F8: F8       sed
D9F9: 38       sec
D9FA: A5 02    lda nb_credits_02
D9FC: E9 01    sbc #$01
D9FE: 85 02    sta nb_credits_02
DA00: D8       cld
DA01: 60       rts

DA02: AD 01 80 lda dsw2_8001
DA05: 49 FF    eor #$ff
DA07: 48       pha
DA08: 29 01    and #$01
DA0A: AA       tax
DA0B: BD 4B BA lda $da2b, x
DA0E: 38       sec
DA0F: E9 01    sbc #$01
DA11: 85 07    sta $07
DA13: 68       pla
DA14: 4A       lsr a
DA15: 29 03    and #$03
DA17: A8       tay
DA18: BE 4D BA ldx $da2d, y
DA1B: BD 51 BA lda $da31, x
DA1E: 85 0B    sta $0b
DA20: BD 52 BA lda $da32, x
DA23: 85 0C    sta $0c
DA25: BD 53 BA lda $da33, x
DA28: 85 0D    sta $0d
DA2A: 60       rts

clear_screen_and_sprites_da3d:
DA3D: A9 04    lda #$04                                            
DA3F: 85 C3    sta $a3                                             
DA41: A9 00    lda #$00                                            
DA43: 85 C5    sta $a5
DA45: A9 5C    lda #$3c
DA47: 85 C6    sta $a6		; $3C00
DA49: A0 00    ldy #$00

clear_part_of_screen_da4b:
DA4B: A9 00    lda #$00
DA4D: 8D 03 80 sta charbank_8003
DA50: 91 C5    sta ($a5), y		; [video_address]
DA52: C8       iny
DA53: D0 FB    bne $da50
DA55: E6 C6    inc $a6
DA57: C6 C3    dec $a3
DA59: D0 F0    bne clear_part_of_screen_da4b
; now sprites on 7C00->7C1F
DA5B: A0 1F    ldy #$1f
DA5D: A9 00    lda #$00
DA5F: 99 00 7C sta $7c00, y		; [video_address]
DA62: 88       dey
DA63: 10 F8    bpl $da5d
DA65: 60       rts

clear_part_of_screen_da66:
DA66: A9 04    lda #$04
DA68: 85 C3    sta $a3
DA6A: A9 00    lda #$00
DA6C: 85 C5    sta $a5
DA6E: A9 5C    lda #$3c
DA70: 85 C6    sta $a6
DA72: A0 60    ldy #$60
DA74: 20 2B BA jsr clear_part_of_screen_da4b
DA77: 60       rts

inc_a7_16_bit_pointer_da78:
DA78: E6 C7    inc $a7
DA7A: D0 02    bne inc_a5_16_bit_pointer_da7e
DA7C: E6 C8    inc $a8
inc_a5_16_bit_pointer_da7e:
DA7E: E6 C5    inc $a5
DA80: D0 02    bne $da84
DA82: E6 C6    inc $a6
DA84: 60       rts

inc_a9_16_bit_pointer_da85:
DA85: E6 C9    inc $a9
DA87: D0 02    bne $da8b
DA89: E6 CA    inc $aa
DA8B: 60       rts

display_nb_lives_da8c:
DA8C: A5 4D    lda $2d
DA8E: 30 16    bmi $daa6
DA90: 85 C1    sta $a1
DA92: A6 C1    ldx $a1
DA94: BD C7 BA lda $daa7, x
DA97: 85 CB    sta $ab
DA99: A9 5F    lda #$3f
DA9B: 85 CC    sta $ac
DA9D: A9 1D    lda #$1d
DA9F: 20 CC BA jsr display_one_life_daac
DAA2: C6 C1    dec $a1
DAA4: 10 EC    bpl $da92
DAA6: 60       rts

display_one_life_daac:
DAAC: A2 00    ldx #$00
DAAE: 8E 03 80 stx charbank_8003
DAB1: A2 03    ldx #$03
DAB3: BC DF BA ldy $dabf, x
DAB6: 91 CB    sta ($ab), y		; [video_address]
DAB8: 38       sec
DAB9: E9 01    sbc #$01
DABB: CA       dex
DABC: 10 F5    bpl $dab3
DABE: 60       rts

DAC3: A6 4F    ldx $2f
DAC5: F0 08    beq $dacf
DAC7: A5 50    lda $30
DAC9: C9 09    cmp #$09
DACB: B0 02    bcs $dacf
DACD: E6 50    inc $30
DACF: 8A       txa
DAD0: F8       sed
DAD1: 18       clc
DAD2: 69 01    adc #$01
DAD4: 85 4F    sta $2f
DAD6: D8       cld
DAD7: 60       rts

display_current_bonus_and_level_dad8:
DAD8: A6 50    ldx $30
DADA: A9 00    lda #$00
DADC: 8D 03 80 sta charbank_8003
DADF: 8A       txa
DAE0: 0A       asl a
DAE1: A8       tay
DAE2: B9 11 BB lda $db11, y
DAE5: 85 CB    sta $ab
DAE7: B9 12 BB lda $db12, y
DAEA: 85 CC    sta $ac
DAEC: BD 45 BB lda $db25, x
DAEF: A0 02    ldy #$02
DAF1: 91 CB    sta ($ab), y		; [video_address]
DAF3: 38       sec
DAF4: E9 01    sbc #$01
DAF6: 88       dey
DAF7: 10 F8    bpl $daf1
DAF9: CA       dex
DAFA: 10 BE    bpl $dada
DAFC: A5 4F    lda $2f
DAFE: 48       pha
DAFF: 4A       lsr a
DB00: 4A       lsr a
DB01: 4A       lsr a
DB02: 4A       lsr a
DB03: 20 07 BB jsr $db07
DB06: 68       pla
DB07: 29 0F    and #$0f
DB09: 18       clc
DB0A: 69 01    adc #$01
DB0C: C8       iny
DB0D: 99 9C 5F sta $3f9c, y  ; [video_address]
DB10: 60       rts

DB2F: A9 00    lda #$00
DB31: 8D 03 80 sta charbank_8003
DB34: 20 16 A9 jsr $c916
DB37: 20 97 A9 jsr $c997
DB3A: A9 05    lda #$05
DB3C: 85 C3    sta $a3
DB3E: A9 00    lda #$00
DB40: 85 C2    sta $a2
DB42: A4 C3    ldy $a3
DB44: BE 70 BB ldx $db70, y
DB47: B5 00    lda $00, x
DB49: F0 07    beq $db52
DB4B: 29 5F    and #$3f
DB4D: 85 C1    sta $a1
DB4F: 20 09 A8 jsr $c809
DB52: C6 C3    dec $a3
DB54: 10 EC    bpl $db42
DB56: A2 02    ldx #$02
DB58: BD 76 BB lda $db76, x
DB5B: 9D 2D 7C sta $7c4d, x  ; [video_address]
DB5E: 9D 31 7C sta $7c51, x  ; [video_address]
DB61: 9D CD 7F sta $7fad, x  ; [video_address]
DB64: 9D D1 7F sta $7fb1, x  ; [video_address]
DB67: CA       dex
DB68: 10 EE    bpl $db58
DB6A: A9 01    lda #$01
DB6C: 20 E0 B7 jsr $d7e0
DB6F: 60       rts
DB79: A5 04    lda $04
DB7B: F0 43    beq $dba0
DB7D: A0 00    ldy #$00
DB7F: AD 00 80 lda dsw1_8000
DB82: 29 20    and #$40
DB84: F0 02    beq $db88
DB86: A4 06    ldy $06
DB88: B9 00 90 lda player_1_controls_9000, y
DB8B: 49 FF    eor #$ff
DB8D: 85 C1    sta $a1
DB8F: 29 0F    and #$0f
DB91: 85 2D    sta $4d
DB93: A5 C1    lda $a1
DB95: 29 10    and #$10
DB97: F0 04    beq $db9d
DB99: 45 2E    eor $4e
DB9B: F0 02    beq $db9f
DB9D: 85 2E    sta $4e
DB9F: 60       rts
DBA0: 20 BA EA jsr $eada
DBA3: 4C 8D BB jmp $db8d

DBA6: 4A       lsr a
DBA7: 4A       lsr a
DBA8: 4A       lsr a
DBA9: A0 03    ldy #$03
DBAB: 4A       lsr a
DBAC: 66 CB    ror $ab
DBAE: 88       dey
DBAF: D0 FA    bne $dbab
DBB1: 18       clc
DBB2: 69 5C    adc #$3c
DBB4: 85 CC    sta $ac
DBB6: 60       rts

sync_dbb7:
DBB7: AD 00 80 lda dsw1_8000
DBBA: 10 FB    bpl sync_dbb7
DBBC: AD 00 80 lda dsw1_8000
DBBF: 30 FB    bmi $dbbc
DBC1: 60       rts
DBC2: A9 18    lda #$18

; < A: number of ticks to wait
wait_dbc4:
DBC4: 85 C3    sta $a3
DBC6: 20 D7 BB jsr sync_dbb7
DBC9: C6 C3    dec $a3
DBCB: D0 F9    bne $dbc6
DBCD: 60       rts

DBCE: A2 00    ldx #$00
DBD0: 4C 4F BC jmp $dc2f
DBD3: A2 02    ldx #$02
DBD5: 4C 4F BC jmp $dc2f
DBD8: A2 04    ldx #$04
DBDA: 4C 4F BC jmp $dc2f
DBDD: A2 06    ldx #$06
DBDF: 4C 4F BC jmp $dc2f
DBE2: A2 08    ldx #$08
DBE4: 4C 4F BC jmp $dc2f
DBE7: A2 0A    ldx #$0a
DBE9: 4C 4F BC jmp $dc2f
DBEC: A2 0C    ldx #$0c
DBEE: 4C 4F BC jmp $dc2f
DBF1: A2 0E    ldx #$0e
DBF3: 4C 4F BC jmp $dc2f
DBF6: A2 10    ldx #$10
DBF8: 4C 4F BC jmp $dc2f
DBFB: A2 12    ldx #$12
DBFD: 4C 4F BC jmp $dc2f
DC00: A2 14    ldx #$14
DC02: 4C 4F BC jmp $dc2f
DC05: A2 16    ldx #$16
DC07: 4C 4F BC jmp $dc2f
DC0A: A2 18    ldx #$18
DC0C: 4C 4F BC jmp $dc2f
DC0F: A2 1A    ldx #$1a
DC11: 4C 4F BC jmp $dc2f
DC14: A2 1C    ldx #$1c
DC16: 4C 4F BC jmp $dc2f
DC19: A2 1E    ldx #$1e
DC1B: 4C 4F BC jmp $dc2f
DC1E: A2 40    ldx #$20
DC20: 4C 4F BC jmp $dc2f
DC23: A2 42    ldx #$22
DC25: 4C 4F BC jmp $dc2f
DC28: A2 44    ldx #$24
DC2A: 4C 4F BC jmp $dc2f
DC2D: A2 46    ldx #$26
DC2F: BD 66 BC lda $dc66, x
DC32: 85 C9    sta $a9
DC34: BD 67 BC lda $dc67, x
DC37: 85 CA    sta $aa
DC39: A2 00    ldx #$00
DC3B: A0 00    ldy #$00
DC3D: B1 C9    lda ($a9), y
DC3F: 85 C5    sta $a5
DC41: C8       iny
DC42: B1 C9    lda ($a9), y
DC44: 85 C6    sta $a6
DC46: C8       iny
DC47: B1 C9    lda ($a9), y
DC49: C8       iny
DC4A: C9 FE    cmp #$fe
DC4C: F0 EF    beq $dc3d
DC4E: C9 FF    cmp #$ff
DC50: F0 0E    beq $dc60
DC52: 8D 03 80 sta charbank_8003
DC55: B1 C9    lda ($a9), y
DC57: 81 C5    sta ($a5, x)		; [video_address]
DC59: C8       iny
DC5A: 20 7E BA jsr inc_a5_16_bit_pointer_da7e
DC5D: 4C 27 BC jmp $dc47
DC60: A9 00    lda #$00
DC62: 8D 03 80 sta charbank_8003
DC65: 60       rts

DC9C: A5 02    lda nb_credits_02
DC9E: F0 18    beq $dcb8
DCA0: 20 83 B7 jsr $d783
DCA3: A9 00    lda #$00
DCA5: 85 05    sta $05
DCA7: AD 02 90 lda system_9002
DCAA: 49 FF    eor #$ff
DCAC: 29 03    and #$03
DCAE: F0 08    beq $dcb8
DCB0: C9 01    cmp #$01
DCB2: F0 10    beq $dcc4
DCB4: C9 02    cmp #$02
DCB6: F0 01    beq $dcb9
DCB8: 60       rts
DCB9: A5 02    lda nb_credits_02
DCBB: C9 02    cmp #$02
DCBD: 90 F9    bcc $dcb8
DCBF: 20 F8 B9 jsr one_less_credit_d9f8
DCC2: E6 05    inc $05
DCC4: 20 F8 B9 jsr one_less_credit_d9f8
DCC7: E6 05    inc $05
DCC9: A5 06    lda $06
DCCB: 8D 01 80 sta dsw2_8001
DCCE: 4C B9 A0 jmp $c0d9

; not sure of what this does...
; seems to serve no purpose at all
special_writes_dcd1:
DCD1: A9 08    lda #$08
DCD3: 05 06    ora $06
DCD5: 8D 01 80 sta dsw2_8001
DCD8: A9 0F    lda #$0f
DCDA: 8D 00 80 sta dsw1_8000
DCDD: 60       rts

run_length_uncompress_e1b8:
E1B8: 0A       asl a
E1B9: 65 06    adc $06
E1BB: AA       tax
; load pointers
E1BC: BC F1 E1 ldy $e1f1, x
E1BF: B9 F7 E1 lda $e1f7, y
E1C2: 85 C9    sta $a9
E1C4: B9 F8 E1 lda $e1f8, y
E1C7: 85 CA    sta $aa
E1C9: B9 F9 E1 lda $e1f9, y
E1CC: 85 C5    sta $a5
E1CE: B9 FA E1 lda $e1fa, y
E1D1: 85 C6    sta $a6
E1D3: B9 FB E1 lda $e1fb, y
E1D6: 85 C1    sta $a1
E1D8: A0 00    ldy #$00
E1DA: 8C 03 80 sty charbank_8003
E1DD: A2 1F    ldx #$1f
E1DF: B1 C9    lda ($a9), y		; [video_address_maybe]
; writes to video but also to regular memory
E1E1: 91 C5    sta ($a5), y		; [video_address_maybe]
E1E3: 20 85 BA jsr inc_a9_16_bit_pointer_da85
E1E6: 20 7E BA jsr inc_a5_16_bit_pointer_da7e
E1E9: CA       dex
E1EA: 10 F3    bpl $e1df
E1EC: C6 C1    dec $a1
E1EE: D0 ED    bne $e1dd
E1F0: 60       rts





E595: A9 00    lda #$00
E597: 85 7C    sta $7c
E599: A2 02    ldx #$02
E59B: A0 00    ldy #$00
E59D: B9 51 00 lda $0031, y
E5A0: 95 68    sta $68, x
E5A2: C8       iny
E5A3: CA       dex
E5A4: 10 F7    bpl $e59d
E5A6: A9 94    lda #$94
E5A8: 85 63    sta $63
E5AA: A9 02    lda #$02
E5AC: 85 64    sta $64
E5AE: A0 02    ldy #$02
E5B0: B1 63    lda ($63), y
E5B2: 99 65 00 sta $0065, y
E5B5: 88       dey
E5B6: 10 F8    bpl $e5b0
E5B8: A5 65    lda $65
E5BA: C9 FF    cmp #$ff
E5BC: D0 01    bne $e5bf
E5BE: 60       rts
E5BF: A5 63    lda $63
E5C1: 18       clc
E5C2: 69 03    adc #$03
E5C4: 85 63    sta $63
E5C6: A5 64    lda $64
E5C8: 69 00    adc #$00
E5CA: 85 64    sta $64
E5CC: E6 7C    inc $7c
E5CE: F8       sed
E5CF: A5 67    lda $67
E5D1: 38       sec
E5D2: E5 6A    sbc $6a
E5D4: A5 66    lda $66
E5D6: E5 69    sbc $69
E5D8: A5 65    lda $65
E5DA: E5 68    sbc $68
E5DC: D8       cld
E5DD: B0 AF    bcs $e5ae
E5DF: A6 7C    ldx $7c
E5E1: BD 19 E6 lda $e619, x
E5E4: 18       clc
E5E5: 69 94    adc #$94
E5E7: 85 35    sta $55
E5E9: A9 02    lda #$02
E5EB: 85 36    sta $56
E5ED: A9 02    lda #$02
E5EF: 85 37    sta enemy_x_57
E5F1: 20 45 E6 jsr $e625
E5F4: A2 02    ldx #$02
E5F6: A9 00    lda #$00
E5F8: 95 68    sta $68, x
E5FA: CA       dex
E5FB: 10 F9    bpl $e5f6
E5FD: A6 7C    ldx $7c
E5FF: BD 1F E6 lda $e61f, x
E602: 18       clc
E603: 69 94    adc #$94
E605: 85 35    sta $55
E607: A9 02    lda #$02
E609: 85 36    sta $56
E60B: A9 02    lda #$02
E60D: 85 37    sta enemy_x_57
E60F: 20 45 E6 jsr $e625
E612: 20 3B E6 jsr $e65b
E615: 20 66 BA jsr clear_part_of_screen_da66
E618: 60       rts

E625: A4 37    ldy enemy_x_57
E627: B1 35    lda ($55), y
E629: 99 72 00 sta $0072, y
E62C: 88       dey
E62D: 10 F8    bpl $e627
E62F: A5 72    lda $72
E631: C9 FF    cmp #$ff
E633: D0 01    bne $e636
E635: 60       rts
E636: A4 37    ldy enemy_x_57
E638: B9 68 00 lda $0068, y
E63B: 91 35    sta ($55), y
E63D: 88       dey
E63E: 10 F8    bpl $e638
E640: A6 37    ldx enemy_x_57
E642: B5 72    lda $72, x
E644: 95 68    sta $68, x
E646: CA       dex
E647: 10 F9    bpl $e642
E649: A6 37    ldx enemy_x_57
E64B: E8       inx
E64C: 8A       txa
E64D: 18       clc
E64E: 65 35    adc $55
E650: 85 35    sta $55
E652: A5 36    lda $56
E654: 69 00    adc #$00
E656: 85 36    sta $56
E658: 4C 45 E6 jmp $e625

E65B: A9 5C    lda #$3c
E65D: 85 36    sta $56
E65F: A9 00    lda #$00
E661: 85 35    sta $55
E663: 85 37    sta enemy_x_57
E665: A9 20    lda #$40
E667: 85 38    sta enemy_y_58
E669: A0 60    ldy #$60
E66B: 20 07 E8 jsr $e807
E66E: A9 01    lda #$01
E670: 8D 03 80 sta charbank_8003
E673: 20 26 E7 jsr $e746
E676: 20 55 E8 jsr $e835
E679: 20 61 E8 jsr $e861
E67C: 20 43 E7 jsr $e723
E67F: A9 00    lda #$00
E681: 85 3D    sta $5d
E683: A9 06    lda #$06
E685: 85 3E    sta $5e
E687: A9 06    lda #$06
E689: 85 3F    sta $5f
E68B: A9 00    lda #$00
E68D: 85 60    sta $60
E68F: 85 61    sta $61
E691: 85 62    sta $62
E693: 20 FC E7 jsr $e7fc
E696: 20 B1 BC jsr special_writes_dcd1
E699: 20 17 E8 jsr $e817
E69C: A5 61    lda $61
E69E: 29 0F    and #$0f
E6A0: C9 0F    cmp #$0f
E6A2: D0 0E    bne $e6b2
E6A4: A5 06    lda $06
E6A6: 8D 02 90 sta system_9002
E6A9: 20 FC E7 jsr $e7fc
E6AC: A9 00    lda #$00
E6AE: 8D 02 90 sta system_9002
E6B1: 60       rts

E6B2: A5 61    lda $61
E6B4: 10 12    bpl $e6c8
E6B6: A5 62    lda $62
E6B8: 30 0E    bmi $e6c8
E6BA: A9 80    lda #$80
E6BC: 85 3D    sta $5d
E6BE: A5 62    lda $62
E6C0: 09 80    ora #$80
E6C2: 85 62    sta $62
E6C4: A9 00    lda #$00
E6C6: 85 3E    sta $5e
E6C8: A5 3D    lda $5d
E6CA: 05 3E    ora $5e
E6CC: D0 0C    bne $e6da
E6CE: A5 61    lda $61
E6D0: 10 04    bpl $e6d6
E6D2: 09 0F    ora #$0f
E6D4: 85 61    sta $61
E6D6: 09 80    ora #$80
E6D8: 85 61    sta $61
E6DA: 20 C1 E8 jsr $e8a1
E6DD: 20 AF E8 jsr $e8cf
E6E0: 20 1C E9 jsr $e91c
E6E3: 20 36 E9 jsr $e956
E6E6: 20 5F EA jsr $ea3f
E6E9: A5 61    lda $61
E6EB: 29 40    and #$20
E6ED: F0 17    beq $e706
E6EF: 20 26 E7 jsr $e746
E6F2: 20 43 E7 jsr $e723
E6F5: 20 55 E8 jsr $e835
E6F8: A5 61    lda $61
E6FA: 49 40    eor #$20
E6FC: AA       tax
E6FD: A5 62    lda $62
E6FF: 29 20    and #$40
E701: D0 01    bne $e704
E703: E8       inx
E704: 86 61    stx $61
E706: 20 D1 EA jsr $eab1
E709: A5 62    lda $62
E70B: 29 DF    and #$bf
E70D: 85 62    sta $62
E70F: A5 61    lda $61
E711: 29 0F    and #$0f
E713: C9 03    cmp #$03
E715: B0 03    bcs $e71a
E717: 4C 93 E6 jmp $e693
E71A: A5 62    lda $62
E71C: 09 40    ora #$20
E71E: 85 62    sta $62
E720: 4C 93 E6 jmp $e693
E723: A9 D4    lda #$b4
E725: 8D 02 7C sta $7c02
E728: A9 20    lda #$40
E72A: 8D 03 7C sta $7c03
E72D: A9 81    lda #$81
E72F: 8D 01 7C sta $7c01
E732: A9 01    lda #$01
E734: 8D 00 7C sta $7c00
E737: A9 00    lda #$00
E739: 8D 04 7C sta $7c04
E73C: 85 7D    sta $7d
E73E: 85 7E    sta $7e
E740: A9 7F    lda #$7f
E742: 8D 05 7C sta $7c05
E745: 60       rts

E746: A9 06    lda #$06
E748: 85 3A    sta $5a
E74A: A5 3A    lda $5a
E74C: 0A       asl a
E74D: AA       tax
E74E: BD 75 E7 lda $e775, x
E751: 85 35    sta $55
E753: BD 83 E7 lda $e783, x
E756: 85 37    sta enemy_x_57
E758: E8       inx
E759: BD 75 E7 lda $e775, x
E75C: 85 36    sta $56
E75E: BD 83 E7 lda $e783, x
E761: 85 38    sta enemy_y_58
E763: A6 3A    ldx $5a
E765: BD 91 E7 lda $e791, x
E768: A8       tay
E769: B1 35    lda ($55), y
E76B: 91 37    sta ($57), y
E76D: 88       dey
E76E: 10 F9    bpl $e769
E770: C6 3A    dec $5a
E772: 10 B6    bpl $e74a
E774: 60       rts


E7FC: AD 00 80 lda dsw1_8000
E7FF: 10 FB    bpl $e7fc
E801: AD 00 80 lda dsw1_8000
E804: 30 FB    bmi $e801
E806: 60       rts
E807: A5 37    lda enemy_x_57
E809: 91 35    sta ($55), y
E80B: C8       iny
E80C: D0 FB    bne $e809
E80E: E6 36    inc $56
E810: A5 36    lda $56
E812: C5 38    cmp enemy_y_58
E814: 90 F1    bcc $e807
E816: 60       rts
E817: A5 3D    lda $5d
E819: 38       sec
E81A: E9 01    sbc #$01
E81C: 85 3D    sta $5d
E81E: A5 3E    lda $5e
E820: E9 00    sbc #$00
E822: 85 3E    sta $5e
E824: C6 3F    dec $5f
E826: 10 04    bpl $e82c
E828: A9 04    lda #$04
E82A: 85 3F    sta $5f
E82C: C6 60    dec $60
E82E: 10 04    bpl $e834
E830: A9 00    lda #$00
E832: 85 60    sta $60
E834: 60       rts
E835: A9 8B    lda #$8b
E837: 85 35    sta $55
E839: A9 5E    lda #$3e
E83B: 85 36    sta $56
E83D: A2 00    ldx #$00
E83F: A0 00    ldy #$00
E841: BD C6 02 lda $02a6, x
E844: 91 35    sta ($55), y
E846: E8       inx
E847: E0 0F    cpx #$0f
E849: D0 01    bne $e84c
E84B: 60       rts
E84C: C8       iny
E84D: C0 03    cpy #$03
E84F: D0 F0    bne $e841
E851: A5 35    lda $55
E853: 18       clc
E854: 69 20    adc #$40
E856: 85 35    sta $55
E858: A5 36    lda $56
E85A: 69 00    adc #$00
E85C: 85 36    sta $56
E85E: 4C 5F E8 jmp $e83f
E861: A9 92    lda #$92
E863: 85 35    sta $55
E865: A9 5E    lda #$3e
E867: 85 36    sta $56
E869: A2 00    ldx #$00
E86B: A0 00    ldy #$00
E86D: BD 94 02 lda $0294, x
E870: 29 F0    and #$f0
E872: 4A       lsr a
E873: 4A       lsr a
E874: 4A       lsr a
E875: 4A       lsr a
E876: 18       clc
E877: 69 81    adc #$81
E879: 91 35    sta ($55), y
E87B: C8       iny
E87C: BD 94 02 lda $0294, x
E87F: 29 0F    and #$0f
E881: 18       clc
E882: 69 81    adc #$81
E884: 91 35    sta ($55), y
E886: E8       inx
E887: E0 0F    cpx #$0f
E889: D0 01    bne $e88c
E88B: 60       rts
E88C: C8       iny
E88D: C0 06    cpy #$06
E88F: D0 BC    bne $e86d
E891: A5 35    lda $55
E893: 18       clc
E894: 69 20    adc #$40
E896: 85 35    sta $55
E898: A5 36    lda $56
E89A: 69 00    adc #$00
E89C: 85 36    sta $56
E89E: 4C 6B E8 jmp $e86b
E8A1: A5 3F    lda $5f
E8A3: D0 49    bne $e8ce
E8A5: A5 61    lda $61
E8A7: 29 10    and #$10
E8A9: 4A       lsr a
E8AA: 4A       lsr a
E8AB: 4A       lsr a
E8AC: 4A       lsr a
E8AD: 18       clc
E8AE: 69 81    adc #$81
E8B0: 8D 01 7C sta $7c01
E8B3: A5 61    lda $61
E8B5: 10 11    bpl $e8c8
E8B7: 29 10    and #$10
E8B9: 4A       lsr a
E8BA: 4A       lsr a
E8BB: 4A       lsr a
E8BC: 4A       lsr a
E8BD: 18       clc
E8BE: 69 87    adc #$87
E8C0: 8D 01 7C sta $7c01
E8C3: A9 02    lda #$02
E8C5: 20 E7 B9 jsr $d9e7
E8C8: A5 61    lda $61
E8CA: 49 10    eor #$10
E8CC: 85 61    sta $61
E8CE: 60       rts
E8CF: A5 3F    lda $5f
E8D1: D0 56    bne $e909
E8D3: A5 61    lda $61
E8D5: 29 E0    and #$e0
E8D7: D0 50    bne $e909
E8D9: A6 06    ldx $06
E8DB: AD 00 80 lda dsw1_8000
E8DE: 29 20    and #$40
E8E0: D0 02    bne $e8e4
E8E2: A2 00    ldx #$00
E8E4: BD 00 90 lda player_1_controls_9000, x
E8E7: 49 FF    eor #$ff
E8E9: 29 0F    and #$0f
E8EB: AA       tax
E8EC: BD 0A E9 lda $e90a, x
E8EF: C5 7E    cmp $7e
E8F1: F0 16    beq $e909
E8F3: 85 7E    sta $7e
E8F5: 18       clc
E8F6: 65 7D    adc $7d
E8F8: 10 02    bpl $e8fc
E8FA: A9 00    lda #$00
E8FC: C9 44    cmp #$24
E8FE: 90 02    bcc $e902
E900: A9 43    lda #$23
E902: 85 7D    sta $7d
E904: A9 1E    lda #$1e
E906: 20 E7 B9 jsr $d9e7
E909: 60       rts

E91C: A5 61    lda $61
E91E: 29 E0    and #$e0
E920: D0 49    bne $e94b
E922: A2 78    ldx #$78
E924: A5 7D    lda $7d
E926: C9 1E    cmp #$1e
E928: B0 0E    bcs $e938
E92A: A2 60    ldx #$60
E92C: C9 14    cmp #$14
E92E: B0 08    bcs $e938
E930: A2 28    ldx #$48
E932: C9 0A    cmp #$0a
E934: B0 02    bcs $e938
E936: A2 50    ldx #$30
E938: 8E 03 7C stx $7c03
E93B: A5 7D    lda $7d
E93D: 38       sec
E93E: E9 0A    sbc #$0a
E940: B0 FC    bcs $e93e
E942: 69 0A    adc #$0a
E944: AA       tax
E945: BD 2C E9 lda $e94c, x
E948: 8D 02 7C sta $7c02
E94B: 60       rts

E956: A5 60    lda $60
E958: D0 20    bne $e99a
E95A: A5 61    lda $61
E95C: 29 E0    and #$e0
E95E: D0 5A    bne $e99a
E960: A6 06    ldx $06
E962: AD 00 80 lda dsw1_8000
E965: 29 20    and #$40
E967: D0 02    bne $e96b
E969: A2 00    ldx #$00
E96B: BD 00 90 lda player_1_controls_9000, x
E96E: 49 FF    eor #$ff
E970: 29 10    and #$10
E972: F0 46    beq $e99a
E974: A9 03    lda #$03
E976: 20 E7 B9 jsr $d9e7
E979: A5 7D    lda $7d
E97B: C9 1E    cmp #$1e
E97D: 90 1C    bcc $e99b
E97F: 38       sec
E980: E9 1E    sbc #$1e
E982: 0A       asl a
E983: AA       tax
E984: BD BB E9 lda table_e9db, x	; [jump_table]
E987: 85 35    sta $55
E989: BD BC E9 lda $e9dc, x
E98C: 85 36    sta $56
E98E: A9 5F    lda #$3f
E990: 85 60    sta $60
E992: A9 0A    lda #$0a
E994: 20 E7 B9 jsr $d9e7
E997: 6C 35 00 jmp ($0055)        ; [indirect_jump]
E99A: 60       rts
E99B: A5 62    lda $62
E99D: 29 40    and #$20
E99F: D0 F9    bne $e99a
E9A1: A9 00    lda #$00
E9A3: 85 35    sta $55
E9A5: A9 6A    lda #$6a
E9A7: 85 36    sta $56
E9A9: A6 7D    ldx $7d
E9AB: A9 30    lda #$50
E9AD: 85 35    sta $55
E9AF: A5 35    lda $55
E9B1: 18       clc
E9B2: 69 08    adc #$08
E9B4: 85 35    sta $55
E9B6: A5 36    lda $56
E9B8: 69 00    adc #$00
E9BA: 85 36    sta $56
E9BC: CA       dex
E9BD: 10 F0    bpl $e9af
E9BF: A9 E0    lda #$e0
E9C1: 85 37    sta enemy_x_57
E9C3: A9 6F    lda #$6f
E9C5: 85 38    sta enemy_y_58
E9C7: EA       nop
E9C8: EA       nop
E9C9: EA       nop
E9CA: EA       nop
E9CB: EA       nop
E9CC: 20 17 EA jsr $ea17
E9CF: A9 00    lda #$00
E9D1: A8       tay
E9D2: 91 35    sta ($55), y
E9D4: A5 61    lda $61
E9D6: 09 20    ora #$40
E9D8: 85 61    sta $61
E9DA: 60       rts
E9E7: A5 62    lda $62
E9E9: 29 40    and #$20
E9EB: D0 ED    bne $e9da
E9ED: A9 F5    lda #$f5
E9EF: 85 7D    sta $7d
E9F1: A6 7C    ldx $7c
E9F3: 4C 90 EA jmp $ea90
E9F6: A5 61    lda $61
E9F8: 09 80    ora #$80
E9FA: 85 61    sta $61
E9FC: 60       rts
E9FD: A5 61    lda $61
E9FF: 29 0F    and #$0f
EA01: F0 13    beq $ea16
EA03: C6 61    dec $61
EA05: A9 F5    lda #$f5
EA07: 85 7D    sta $7d
EA09: A6 7C    ldx $7c
EA0B: 20 90 EA jsr $ea90
EA0E: A5 62    lda $62
EA10: 09 20    ora #$40
EA12: 29 BF    and #$df
EA14: 85 62    sta $62
EA16: 60       rts
EA17: AD 07 7C lda $7c07
EA1A: 85 36    sta $56
EA1C: AD 06 7C lda $7c06
EA1F: 49 FF    eor #$ff
EA21: 85 35    sta $55
EA23: 46 36    lsr $56
EA25: 46 36    lsr $56
EA27: 46 36    lsr $56
EA29: 46 36    lsr $56
EA2B: 66 35    ror $55
EA2D: 46 36    lsr $56
EA2F: 66 35    ror $55
EA31: 46 36    lsr $56
EA33: 66 35    ror $55
EA35: A5 36    lda $56
EA37: 18       clc
EA38: 69 A0    adc #$c0
EA3A: 85 36    sta $56
EA3C: C6 35    dec $55
EA3E: 60       rts
EA3F: A5 61    lda $61
EA41: 29 E0    and #$e0
EA43: C9 20    cmp #$40
EA45: F0 01    beq $ea48
EA47: 60       rts
EA48: A9 9C    lda #$9c
EA4A: 85 35    sta $55
EA4C: A5 61    lda $61
EA4E: 29 0F    and #$0f
EA50: F0 0B    beq $ea5d
EA52: AA       tax
EA53: A5 35    lda $55
EA55: 38       sec
EA56: E9 08    sbc #$08
EA58: 85 35    sta $55
EA5A: CA       dex
EA5B: D0 F6    bne $ea53
EA5D: A6 7C    ldx $7c
EA5F: BD 8A EA lda $ea8a, x
EA62: 85 36    sta $56
EA64: A5 35    lda $55
EA66: CD 02 7C cmp $7c02
EA69: F0 0A    beq $ea75
EA6B: 90 05    bcc $ea72
EA6D: EE 02 7C inc $7c02
EA70: D0 03    bne $ea75
EA72: CE 02 7C dec $7c02
EA75: A5 36    lda $56
EA77: CD 03 7C cmp $7c03
EA7A: F0 04    beq $ea80
EA7C: EE 03 7C inc $7c03
EA7F: 60       rts
EA80: A5 35    lda $55
EA82: CD 02 7C cmp $7c02
EA85: F0 09    beq $ea90
EA87: 4C 7F EA jmp $ea7f
EA8B: C8       iny
EA8C: D8       cld
EA8D: A8       tay
EA8E: B8       clv
EA8F: E8       inx
EA90: A5 61    lda $61
EA92: 09 40    ora #$20
EA94: 29 DF    and #$bf
EA96: 85 61    sta $61
EA98: BD 1F E6 lda $e61f, x
EA9B: 18       clc
EA9C: 69 94    adc #$94
EA9E: 85 35    sta $55
EAA0: A9 02    lda #$02
EAA2: 85 36    sta $56
EAA4: A5 61    lda $61
EAA6: 29 0F    and #$0f
EAA8: A8       tay
EAA9: A5 7D    lda $7d
EAAB: 18       clc
EAAC: 69 2B    adc #$4b
EAAE: 91 35    sta ($55), y
EAB0: 60       rts
EAB1: AD 02 90 lda system_9002
EAB4: 49 FF    eor #$ff
EAB6: 29 03    and #$03
EAB8: F0 06    beq $eac0
EABA: A5 61    lda $61
EABC: 09 0F    ora #$0f
EABE: 85 61    sta $61
EAC0: A5 61    lda $61
EAC2: 10 15    bpl $ead9
EAC4: A9 B0    lda #$d0
EAC6: 8D 02 7C sta $7c02
EAC9: A6 7C    ldx $7c
EACB: BD 8A EA lda $ea8a, x
EACE: 38       sec
EACF: E9 0C    sbc #$0c
EAD1: 8D 03 7C sta $7c03
EAD4: A9 00    lda #$00
EAD6: 8D 04 7C sta $7c04
EAD9: 60       rts
EADA: A5 D3    lda $b3
EADC: 30 43    bmi $eb01
EADE: A6 D4    ldx $b4
EAE0: BD 5F EB lda $eb3f, x
EAE3: C9 FF    cmp #$ff
EAE5: D0 09    bne $eaf0
EAE7: A5 D3    lda $b3
EAE9: 49 01    eor #$01
EAEB: 85 D3    sta $b3
EAED: 4C 19 EB jmp $eb19
EAF0: 85 D5    sta $b5
EAF2: 85 C1    sta $a1
EAF4: E8       inx
EAF5: BD 5F EB lda $eb3f, x
EAF8: 85 D6    sta $b6
EAFA: A5 D3    lda $b3
EAFC: 09 80    ora #$80
EAFE: 85 D3    sta $b3
EB00: 60       rts
EB01: A5 5D    lda $3d
EB03: F0 43    beq $eb28
EB05: A5 22    lda $42
EB07: 29 0F    and #$0f
EB09: A8       tay
EB0A: BE 4D EB ldx $eb2d, y
EB0D: B5 5E    lda player_x_3e, x
EB0F: 29 07    and #$07
EB11: D0 02    bne $eb15
EB13: C6 D6    dec $b6
EB15: A5 D6    lda $b6
EB17: D0 0F    bne $eb28
EB19: A5 D3    lda $b3
EB1B: 29 01    and #$01
EB1D: 85 D3    sta $b3
EB1F: AA       tax
EB20: BD 5D EB lda $eb3d, x
EB23: 18       clc
EB24: 65 D4    adc $b4
EB26: 85 D4    sta $b4
EB28: A5 D5    lda $b5
EB2A: 85 C1    sta $a1
EB2C: 60       rts


insert_coin_irq_f000:
F000: 4C AD F1 jmp $f1cd

reset_f003:
F003: 4C 09 F0 jmp reset_f009

F006: 4C 05 F2 jmp $f205

reset_f009:
F009: A2 FF    ldx #$ff
F00B: 9A       txs				; set stack on top
F00C: 78       sei				; no interrupts
F00D: D8       cld				; no decimal mode
F00E: A9 00    lda #$00
F010: 8D 00 80 sta dsw1_8000	; nop
F013: 8D 00 90 sta player_1_controls_9000	; nop
F016: AD 00 80 lda dsw1_8000
F019: 29 50    and #$30
F01B: C9 50    cmp #$30
F01D: D0 0C    bne $f02b		; locks up if branches (wrong DSW settings)
; boot continues here
F01F: 20 11 F2 jsr $f211
F022: 20 6F F2 jsr wait_1_second_f26f
F025: 20 6F F2 jsr wait_1_second_f26f
F028: 4C 03 A0 jmp boot_continues_c003

F02B: A9 00    lda #$00
F02D: 8D 02 90 sta system_9002
F030: A2 00    ldx #$00
F032: A0 00    ldy #$00
F034: A9 00    lda #$00
F036: 99 00 00 sta $0000, y
F039: C8       iny
F03A: D0 FA    bne $f036
F03C: A9 FF    lda #$ff
F03E: 95 00    sta $00, x
F040: B5 01    lda $01, x
F042: 49 00    eor #$00
F044: D0 61    bne $f0a7
F046: B5 00    lda $00, x
F048: 49 FF    eor #$ff
F04A: D0 3B    bne $f0a7
F04C: B5 01    lda $01, x
F04E: 49 00    eor #$00
F050: D0 35    bne $f0a7
F052: B5 02    lda nb_credits_02, x
F054: 49 00    eor #$00
F056: D0 2F    bne $f0a7
F058: B5 00    lda $00, x
F05A: 49 FF    eor #$ff
F05C: D0 29    bne $f0a7
F05E: B5 02    lda nb_credits_02, x
F060: 49 00    eor #$00
F062: D0 23    bne $f0a7
F064: A9 00    lda #$00
F066: 95 00    sta $00, x
F068: E8       inx
F069: E0 FE    cpx #$fe
F06B: 90 AF    bcc $f03c
F06D: A9 FF    lda #$ff
F06F: 95 00    sta $00, x
F071: B5 01    lda $01, x
F073: 49 00    eor #$00
F075: D0 50    bne $f0a7
F077: B5 00    lda $00, x
F079: 49 FF    eor #$ff
F07B: D0 4A    bne $f0a7
F07D: BD FF FF lda $ffff, x
F080: 49 00    eor #$00
F082: D0 43    bne $f0a7
F084: B5 00    lda $00, x
F086: 49 FF    eor #$ff
F088: D0 1D    bne $f0a7
F08A: A9 00    lda #$00
F08C: 95 00    sta $00, x
F08E: E8       inx
F08F: A9 FF    lda #$ff
F091: 95 00    sta $00, x
F093: BD FF FF lda $ffff, x
F096: 45 00    eor $00
F098: D0 0D    bne $f0a7
F09A: B5 00    lda $00, x
F09C: 49 FF    eor #$ff
F09E: D0 07    bne $f0a7
F0A0: A9 00    lda #$00
F0A2: 95 00    sta $00, x
F0A4: 4C A8 F0 jmp $f0c8
F0A7: A9 44    lda #$24
F0A9: 8D 46 5D sta $3d26
F0AC: A9 0F    lda #$0f
F0AE: 8D 47 5D sta $3d27
F0B1: A9 1C    lda #$1c
F0B3: 8D 48 5D sta $3d28
F0B6: A9 19    lda #$19
F0B8: 8D 49 5D sta $3d29
F0BB: A9 0F    lda #$0f
F0BD: 8D 4B 5D sta $3d2b
F0C0: A9 1C    lda #$1c
F0C2: 8D 4C 5D sta $3d2c
F0C5: 4C 50 F0 jmp $f030
F0C8: A2 00    ldx #$00
F0CA: A0 00    ldy #$00
F0CC: A9 00    lda #$00
F0CE: 99 00 01 sta $0100, y
F0D1: C8       iny
F0D2: D0 FA    bne $f0ce
F0D4: A9 FF    lda #$ff
F0D6: 9D 00 01 sta $0100, x
F0D9: BD 01 01 lda $0101, x
F0DC: 49 00    eor #$00
F0DE: D0 74    bne $f154
F0E0: BD 00 01 lda $0100, x
F0E3: 49 FF    eor #$ff
F0E5: D0 6D    bne $f154
F0E7: BD 01 01 lda $0101, x
F0EA: 49 00    eor #$00
F0EC: D0 66    bne $f154
F0EE: BD 02 01 lda $0102, x
F0F1: 49 00    eor #$00
F0F3: D0 3F    bne $f154
F0F5: BD 00 01 lda $0100, x
F0F8: 49 FF    eor #$ff
F0FA: D0 38    bne $f154
F0FC: BD 02 01 lda $0102, x
F0FF: 49 00    eor #$00
F101: D0 31    bne $f154
F103: A9 00    lda #$00
F105: 9D 00 01 sta $0100, x
F108: E8       inx
F109: E0 FE    cpx #$fe
F10B: 90 A7    bcc $f0d4
F10D: A9 FF    lda #$ff
F10F: 9D 00 01 sta $0100, x
F112: BD 01 01 lda $0101, x
F115: 49 00    eor #$00
F117: D0 5B    bne $f154
F119: BD 00 01 lda $0100, x
F11C: 49 FF    eor #$ff
F11E: D0 54    bne $f154
F120: BD 01 01 lda $0101, x
F123: 49 00    eor #$00
F125: D0 4D    bne $f154
F127: B5 FF    lda $ff, x
F129: 49 00    eor #$00
F12B: D0 47    bne $f154
F12D: BD 00 01 lda $0100, x
F130: 49 FF    eor #$ff
F132: D0 40    bne $f154
F134: A9 00    lda #$00
F136: 9D 00 01 sta $0100, x
F139: E8       inx
F13A: A9 FF    lda #$ff
F13C: 9D 00 01 sta $0100, x
F13F: B5 FF    lda $ff, x
F141: 49 00    eor #$00
F143: D0 0F    bne $f154
F145: BD 00 01 lda $0100, x
F148: 49 FF    eor #$ff
F14A: D0 08    bne $f154
F14C: A9 00    lda #$00
F14E: 9D 00 01 sta $0100, x
F151: 4C 75 F1 jmp $f175
F154: A9 1D    lda #$1d
F156: 8D 46 5D sta $3d26
F159: A9 1E    lda #$1e
F15B: 8D 47 5D sta $3d27
F15E: A9 0B    lda #$0b
F160: 8D 48 5D sta $3d28
F163: A9 15    lda #$15
F165: 8D 49 5D sta $3d29
F168: A9 0F    lda #$0f
F16A: 8D 4B 5D sta $3d2b
F16D: A9 1C    lda #$1c
F16F: 8D 4C 5D sta $3d2c
F172: 4C A8 F0 jmp $f0c8
F175: 20 11 F2 jsr $f211
F178: 20 6F F2 jsr wait_1_second_f26f
F17B: 20 6F F2 jsr wait_1_second_f26f
F17E: AD 00 80 lda dsw1_8000
F181: 29 50    and #$30
F183: C9 00    cmp #$00		; [disabled]
F185: D0 03    bne $f18a
F187: 4C 62 F3 jmp $f362
F18A: C9 40    cmp #$20
F18C: D0 03    bne $f191
F18E: 4C 7B F2 jmp $f27b
F191: A9 00    lda #$00
F193: 85 08    sta $08
F195: 8D 02 90 sta system_9002
F198: A9 00    lda #$00
F19A: 8D 02 90 sta system_9002
F19D: A5 08    lda $08
F19F: 0A       asl a
F1A0: AA       tax
F1A1: BD CE F1 lda table_f1ae, x		; [jump_table]
F1A4: 85 09    sta $09
F1A6: BD CF F1 lda $f1af, x
F1A9: 85 0A    sta $0a
F1AB: 6C 09 00 jmp ($0009)		; [indirect_jump]

F1BA: A9 00    lda #$00
F1BC: 8D 02 90 sta system_9002
F1BF: E6 08    inc $08
F1C1: A5 08    lda $08
F1C3: C9 06    cmp #$06
F1C5: B0 03    bcs $f1ca
F1C7: 4C 98 F1 jmp $f198
F1CA: 4C 09 F0 jmp reset_f009
F1CD: 48       pha
F1CE: 8A       txa
F1CF: 48       pha
F1D0: 98       tya
F1D1: 48       pha
F1D2: AD 00 80 lda dsw1_8000
F1D5: 29 50    and #$30
F1D7: C9 50    cmp #$30
F1D9: D0 08    bne $f1e3
F1DB: 68       pla
F1DC: A8       tay
F1DD: 68       pla
F1DE: AA       tax
F1DF: 68       pla
F1E0: 4C 00 A0 jmp $c000
F1E3: C9 00    cmp #$00
F1E5: F0 16    beq $f1fd
F1E7: C9 40    cmp #$20
F1E9: F0 12    beq $f1fd
F1EB: E6 08    inc $08
F1ED: A5 08    lda $08
F1EF: C9 06    cmp #$06
F1F1: B0 03    bcs $f1f6
F1F3: 4C 06 F2 jmp $f206
F1F6: A9 00    lda #$00
F1F8: 85 08    sta $08
F1FA: 4C 06 F2 jmp $f206
F1FD: 68       pla
F1FE: A8       tay
F1FF: 68       pla
F200: AA       tax
F201: 68       pla
F202: 8D 00 90 sta player_1_controls_9000
F205: 40       rti
F206: 68       pla
F207: A8       tay
F208: 68       pla
F209: AA       tax
F20A: 68       pla
F20B: 8D 00 90 sta player_1_controls_9000
F20E: 4C 98 F1 jmp $f198

F211: A0 00    ldy #$00
F213: A9 00    lda #$00
F215: 85 0B    sta $0b
F217: A9 7C    lda #$7c
F219: 85 0C    sta $0c
F21B: A9 00    lda #$00
F21D: 91 0B    sta ($0b), y		; [video_address]
F21F: C8       iny
F220: D0 F9    bne $f21b
F222: E6 0C    inc $0c
F224: A5 0C    lda $0c
F226: C9 80    cmp #$80
F228: D0 F1    bne $f21b
F22A: 60       rts
F22B: A9 01    lda #$01
F22D: 8D 03 80 sta charbank_8003
F230: A0 00    ldy #$00
F232: BD F4 F7 lda $f7f4, x
F235: 99 46 5D sta $3d26, y		; [video_address]
F238: C8       iny
F239: E8       inx
F23A: C0 11    cpy #$11
F23C: 90 F4    bcc $f232
F23E: 60       rts

sync_f23f:
F23F: AD 00 80 lda dsw1_8000
F242: 10 FB    bpl sync_f23f
F244: AD 00 80 lda dsw1_8000
F247: 30 FB    bmi $f244
F249: 60       rts

F24A: A9 05    lda #$05
F24C: 85 12    sta $12
F24E: A9 00    lda #$00
F250: 85 11    sta $11
F252: E6 11    inc $11
F254: D0 FC    bne $f252
F256: C6 12    dec $12
F258: D0 F4    bne $f24e
F25A: 60       rts
F25B: A9 01    lda #$01
F25D: 85 06    sta $06
F25F: A9 00    lda #$00
F261: 85 07    sta $07
F263: 20 5F F2 jsr sync_f23f
F266: E6 07    inc $07
F268: D0 F9    bne $f263
F26A: C6 06    dec $06
F26C: D0 F1    bne $f25f
F26E: 60       rts

wait_1_second_f26f:
F26F: A9 5F    lda #$3f
F271: 85 13    sta $13
F273: 20 5F F2 jsr sync_f23f
F276: C6 13    dec $13
F278: D0 F9    bne $f273
F27A: 60       rts

F27B: 20 11 F2 jsr $f211
F27E: A2 00    ldx #$00
F280: 20 4B F2 jsr $f22b
F283: A9 01    lda #$01
F285: 8D 03 80 sta charbank_8003
F288: A9 82    lda #$82
F28A: 8D 2F 5E sta $3e4f
F28D: A9 0F    lda #$0f
F28F: 8D 00 80 sta dsw1_8000
F292: A9 08    lda #$08
F294: 8D 01 80 sta dsw2_8001
F297: 20 0C F3 jsr $f30c
F29A: A9 00    lda #$00
F29C: 8D 01 80 sta dsw2_8001
F29F: 20 6F F2 jsr wait_1_second_f26f
F2A2: A9 83    lda #$83
F2A4: 8D 2F 5E sta $3e4f
F2A7: A9 0F    lda #$0f
F2A9: 8D 00 80 sta dsw1_8000
F2AC: A9 08    lda #$08
F2AE: 8D 01 80 sta dsw2_8001
F2B1: 20 0C F3 jsr $f30c
F2B4: 20 0C F3 jsr $f30c
F2B7: A9 00    lda #$00
F2B9: 8D 01 80 sta dsw2_8001
F2BC: 20 6F F2 jsr wait_1_second_f26f
F2BF: A9 84    lda #$84
F2C1: 8D 2F 5E sta $3e4f
F2C4: A9 0F    lda #$0f
F2C6: 8D 00 80 sta dsw1_8000
F2C9: A9 08    lda #$08
F2CB: 8D 01 80 sta dsw2_8001
F2CE: 20 0C F3 jsr $f30c
F2D1: 20 0C F3 jsr $f30c
F2D4: 20 0C F3 jsr $f30c
F2D7: A9 00    lda #$00
F2D9: 8D 01 80 sta dsw2_8001
F2DC: 20 6F F2 jsr wait_1_second_f26f
F2DF: A9 85    lda #$85
F2E1: 8D 2F 5E sta $3e4f
F2E4: A9 0F    lda #$0f
F2E6: 8D 00 80 sta dsw1_8000
F2E9: A9 08    lda #$08
F2EB: 8D 01 80 sta dsw2_8001
F2EE: 20 0C F3 jsr $f30c
F2F1: 20 0C F3 jsr $f30c
F2F4: 20 0C F3 jsr $f30c
F2F7: 20 0C F3 jsr $f30c
F2FA: A9 00    lda #$00
F2FC: 8D 01 80 sta dsw2_8001
F2FF: A9 0F    lda #$0f
F301: 8D 55 5D sta $3d35
F304: A9 1C    lda #$1c
F306: 8D 56 5D sta $3d36
F309: 4C 09 F3 jmp $f309
F30C: A9 04    lda #$04
F30E: 85 43    sta $23
F310: 20 5F F2 jsr sync_f23f
F313: C6 43    dec $23
F315: A5 43    lda $23
F317: D0 F7    bne $f310
F319: 60       rts
F31A: 20 11 F2 jsr $f211
F31D: A2 11    ldx #$11
F31F: 20 4B F2 jsr $f22b
F322: A9 F1    lda #$f1
F324: 8D 02 90 sta system_9002
F327: 20 5F F2 jsr sync_f23f
F32A: A9 00    lda #$00
F32C: 85 00    sta $00
F32E: A5 00    lda $00
F330: 8D 02 90 sta system_9002
F333: 20 2A F2 jsr $f24a
F336: E6 00    inc $00
F338: D0 F4    bne $f32e
F33A: A9 10    lda #$10
F33C: 85 14    sta $14
F33E: 20 5F F2 jsr sync_f23f
F341: C6 14    dec $14
F343: D0 F9    bne $f33e
F345: A9 F2    lda #$f2
F347: 85 01    sta $01
F349: A5 01    lda $01
F34B: 8D 02 90 sta system_9002
F34E: 20 3B F2 jsr $f25b
F351: 20 6F F2 jsr wait_1_second_f26f
F354: 20 6F F2 jsr wait_1_second_f26f
F357: E6 01    inc $01
F359: A5 01    lda $01
F35B: C9 F8    cmp #$f8
F35D: 90 EA    bcc $f349
F35F: 4C DA F1 jmp $f1ba
F362: 20 11 F2 jsr $f211
F365: A9 0E    lda #$0e
F367: 8D 46 5D sta $3d26
F36A: A9 1C    lda #$1c
F36C: 8D 47 5D sta $3d27
F36F: A9 0B    lda #$0b
F371: 8D 48 5D sta $3d28
F374: A9 17    lda #$17
F376: 8D 49 5D sta $3d29
F379: 20 6F F2 jsr wait_1_second_f26f
F37C: A2 00    ldx #$00
F37E: A0 00    ldy #$00
F380: A9 08    lda #$08
F382: 85 15    sta $15
F384: A9 00    lda #$00
F386: 85 00    sta $00
F388: 85 16    sta $16
F38A: A9 02    lda #$02
F38C: 85 01    sta $01
F38E: A9 00    lda #$00
F390: 91 00    sta ($00), y
F392: C8       iny
F393: D0 F9    bne $f38e
F395: E6 01    inc $01
F397: A5 01    lda $01
F399: C9 20    cmp #$40
F39B: 90 F1    bcc $f38e
F39D: A9 02    lda #$02
F39F: 85 01    sta $01
F3A1: A9 FF    lda #$ff
F3A3: 91 00    sta ($00), y
F3A5: C8       iny
F3A6: B1 00    lda ($00), y
F3A8: 49 00    eor #$00
F3AA: D0 26    bne $f3f2
F3AC: 88       dey
F3AD: B1 00    lda ($00), y
F3AF: 49 FF    eor #$ff
F3B1: D0 5F    bne $f3f2
F3B3: C8       iny
F3B4: B1 00    lda ($00), y
F3B6: 45 00    eor $00
F3B8: D0 58    bne $f3f2
F3BA: C8       iny
F3BB: B1 00    lda ($00), y
F3BD: 45 00    eor $00
F3BF: D0 51    bne $f3f2
F3C1: 88       dey
F3C2: 88       dey
F3C3: B1 00    lda ($00), y
F3C5: 45 FF    eor $ff
F3C7: D0 49    bne $f3f2
F3C9: C8       iny
F3CA: C8       iny
F3CB: B1 00    lda ($00), y
F3CD: 45 00    eor $00
F3CF: D0 41    bne $f3f2
F3D1: 88       dey
F3D2: 88       dey
F3D3: A9 00    lda #$00
F3D5: 91 00    sta ($00), y
F3D7: E6 00    inc $00
F3D9: F0 09    beq $f3e4
F3DB: A5 00    lda $00
F3DD: C9 FE    cmp #$fe
F3DF: B0 08    bcs $f3e9
F3E1: 4C C1 F3 jmp $f3a1
F3E4: E6 01    inc $01
F3E6: 4C C1 F3 jmp $f3a1
F3E9: A5 01    lda $01
F3EB: C9 5F    cmp #$3f
F3ED: D0 D2    bne $f3a1
F3EF: 4C F9 F3 jmp $f3f9
F3F2: 05 16    ora $16
F3F4: A0 00    ldy #$00
F3F6: 4C B3 F3 jmp $f3d3
F3F9: A9 FF    lda #$ff
F3FB: 91 00    sta ($00), y
F3FD: C8       iny
F3FE: B1 00    lda ($00), y
F400: 49 00    eor #$00
F402: D0 07    bne $f40b
F404: 88       dey
F405: B1 00    lda ($00), y
F407: 49 FF    eor #$ff
F409: F0 03    beq $f40e
F40B: 88       dey
F40C: 05 16    ora $16
F40E: A9 00    lda #$00
F410: 91 00    sta ($00), y
F412: C8       iny
F413: A9 FF    lda #$ff
F415: 91 00    sta ($00), y
F417: 88       dey
F418: B1 00    lda ($00), y
F41A: 49 00    eor #$00
F41C: D0 07    bne $f425
F41E: C8       iny
F41F: B1 00    lda ($00), y
F421: 49 FF    eor #$ff
F423: F0 02    beq $f427
F425: 05 16    ora $16
F427: 20 11 F2 jsr $f211
F42A: A5 16    lda $16
F42C: F0 1D    beq $f44b
F42E: A2 99    ldx #$99
F430: 20 4B F2 jsr $f22b
F433: A2 00    ldx #$00
F435: 06 16    asl $16
F437: 90 06    bcc $f43f
F439: A5 17    lda $17
F43B: 9D 4B 5D sta $3d2b, x
F43E: E8       inx
F43F: C6 15    dec $15
F441: A5 15    lda $15
F443: D0 F0    bne $f435
F445: 20 3B F2 jsr $f25b
F448: 4C 62 F3 jmp $f362
F44B: A2 42    ldx #$22
F44D: 20 4B F2 jsr $f22b
F450: 4C 25 F4 jmp $f445
F453: 20 11 F2 jsr $f211
F456: A9 00    lda #$00
F458: 85 18    sta $18
F45A: A9 08    lda #$08
F45C: 85 15    sta $15
F45E: A9 CA    lda #$aa
F460: 85 02    sta nb_credits_02
F462: A2 00    ldx #$00
F464: A0 00    ldy #$00
F466: A9 00    lda #$00
F468: 85 00    sta $00
F46A: A9 02    lda #$02
F46C: 85 01    sta $01
F46E: A5 02    lda nb_credits_02
F470: 91 00    sta ($00), y
F472: C8       iny
F473: D0 F9    bne $f46e
F475: E6 01    inc $01
F477: A5 01    lda $01
F479: C9 20    cmp #$40
F47B: 90 F1    bcc $f46e
F47D: A9 02    lda #$02
F47F: 85 01    sta $01
F481: A0 00    ldy #$00
F483: B1 00    lda ($00), y
F485: 45 02    eor nb_credits_02
F487: F0 02    beq $f48b
F489: 05 18    ora $18
F48B: C8       iny
F48C: D0 F5    bne $f483
F48E: E6 01    inc $01
F490: A5 01    lda $01
F492: C9 20    cmp #$40
F494: D0 ED    bne $f483
F496: E8       inx
F497: BD AC F4 lda $f4cc, x
F49A: 85 02    sta nb_credits_02
F49C: C9 66    cmp #$66
F49E: D0 A6    bne $f466
F4A0: 20 11 F2 jsr $f211
F4A3: A5 18    lda $18
F4A5: F0 1D    beq $f4c4
F4A7: A2 88    ldx #$88
F4A9: 20 4B F2 jsr $f22b
F4AC: A2 00    ldx #$00
F4AE: 06 18    asl $18
F4B0: 90 06    bcc $f4b8
F4B2: A5 17    lda $17
F4B4: 9D 4A 5D sta $3d2a, x
F4B7: E8       inx
F4B8: C6 17    dec $17
F4BA: A5 17    lda $17
F4BC: D0 F0    bne $f4ae
F4BE: 20 6F F2 jsr wait_1_second_f26f
F4C1: 4C DA F1 jmp $f1ba
F4C4: A2 53    ldx #$33
F4C6: 20 4B F2 jsr $f22b
F4C9: 4C DE F4 jmp $f4be

F4DD: 20 11 F2 jsr $f211
F4E0: A2 24    ldx #$44
F4E2: 20 4B F2 jsr $f22b
F4E5: A9 00    lda #$00
F4E7: 85 00    sta $00
F4E9: 85 01    sta $01
F4EB: 85 02    sta nb_credits_02
F4ED: A9 01    lda #$01
F4EF: 85 05    sta $05
F4F1: A9 A0    lda #$c0
F4F3: 85 03    sta $03
F4F5: A9 B0    lda #$d0
F4F7: 85 04    sta $04
F4F9: A0 00    ldy #$00
F4FB: A2 00    ldx #$00
F4FD: B1 02    lda ($02), y
F4FF: 18       clc
F500: 65 00    adc $00
F502: 85 00    sta $00
F504: A9 00    lda #$00
F506: 65 01    adc $01
F508: 85 01    sta $01
F50A: C8       iny
F50B: D0 F0    bne $f4fd
F50D: E6 03    inc $03
F50F: A5 03    lda $03
F511: C5 04    cmp $04
F513: D0 E8    bne $f4fd
F515: BD F4 FF lda $fff4, x
F518: C5 00    cmp $00
F51A: D0 4D    bne $f549
F51C: E8       inx
F51D: BD F4 FF lda $fff4, x
F520: C5 01    cmp $01
F522: D0 45    bne $f549
F524: E6 05    inc $05
F526: A9 00    lda #$00
F528: 85 00    sta $00
F52A: 85 01    sta $01
F52C: E8       inx
F52D: A9 10    lda #$10
F52F: 18       clc
F530: 65 04    adc $04
F532: 85 04    sta $04
F534: F0 03    beq $f539
F536: 4C FD F4 jmp $f4fd
F539: A9 19    lda #$19
F53B: 8D 4F 5D sta $3d2f
F53E: A9 15    lda #$15
F540: 8D 50 5D sta $3d30
F543: 20 6F F2 jsr wait_1_second_f26f
F546: 4C DA F1 jmp $f1ba
F549: A9 0F    lda #$0f
F54B: 8D 4F 5D sta $3d2f
F54E: A9 1C    lda #$1c
F550: 8D 50 5D sta $3d30
F553: A5 05    lda $05
F555: 8D 52 5D sta $3d32
F558: 20 6F F2 jsr wait_1_second_f26f
F55B: 4C DA F1 jmp $f1ba
F55E: A9 00    lda #$00
F560: 85 44    sta $24
F562: 20 11 F2 jsr $f211
F565: A2 35    ldx #$55
F567: A9 01    lda #$01
F569: 8D 03 80 sta charbank_8003
F56C: A0 00    ldy #$00
F56E: BD F4 F7 lda $f7f4, x
F571: 99 66 5C sta $3c66, y
F574: C8       iny
F575: E8       inx
F576: C0 11    cpy #$11
F578: 90 F4    bcc $f56e
F57A: A9 82    lda #$82
F57C: 8D 4D 5D sta $3d2d
F57F: A9 83    lda #$83
F581: 8D 6D 5D sta $3d6d
F584: A9 84    lda #$84
F586: 8D CD 5D sta $3dad
F589: A9 85    lda #$85
F58B: 8D ED 5D sta $3ded
F58E: A9 86    lda #$86
F590: 8D 4D 5E sta $3e2d
F593: A9 87    lda #$87
F595: 8D 6D 5E sta $3e6d
F598: A9 88    lda #$88
F59A: 8D CD 5E sta $3ead
F59D: A9 89    lda #$89
F59F: 8D ED 5E sta $3eed
F5A2: A9 02    lda #$02
F5A4: 8D 03 80 sta charbank_8003
F5A7: A9 01    lda #$01
F5A9: 85 00    sta $00
F5AB: A9 00    lda #$00
F5AD: 85 02    sta nb_credits_02
F5AF: A2 00    ldx #$00
F5B1: A9 85    lda #$85
F5B3: 9D 01 7C sta $7c01, x
F5B6: E8       inx
F5B7: E8       inx
F5B8: E8       inx
F5B9: E8       inx
F5BA: E0 40    cpx #$20
F5BC: 30 F5    bmi $f5b3
F5BE: A9 00    lda #$00
F5C0: 85 01    sta $01
F5C2: A5 00    lda $00
F5C4: A2 00    ldx #$00
F5C6: 9D 00 7C sta $7c00, x
F5C9: E8       inx
F5CA: E8       inx
F5CB: E8       inx
F5CC: E8       inx
F5CD: E0 40    cpx #$20
F5CF: 30 F5    bmi $f5c6
F5D1: A5 01    lda $01
F5D3: A2 00    ldx #$00
F5D5: 65 01    adc $01
F5D7: 9D 02 7C sta $7c02, x
F5DA: E8       inx
F5DB: E8       inx
F5DC: E8       inx
F5DD: E8       inx
F5DE: E0 40    cpx #$20
F5E0: 30 F5    bmi $f5d7
F5E2: A2 00    ldx #$00
F5E4: A5 01    lda $01
F5E6: 9D 03 7C sta $7c03, x
F5E9: 18       clc
F5EA: 69 10    adc #$10
F5EC: E8       inx
F5ED: E8       inx
F5EE: E8       inx
F5EF: E8       inx
F5F0: E0 40    cpx #$20
F5F2: 30 F2    bmi $f5e6
F5F4: A5 01    lda $01
F5F6: C9 20    cmp #$40
F5F8: D0 03    bne $f5fd
F5FA: 4C 1B F6 jmp $f61b
F5FD: E6 01    inc $01
F5FF: 20 5F F2 jsr sync_f23f
F602: A5 01    lda $01
F604: C9 74    cmp #$74
F606: D0 A9    bne $f5d1
F608: E6 00    inc $00
F60A: E6 00    inc $00
F60C: A5 00    lda $00
F60E: C9 09    cmp #$09
F610: D0 CC    bne $f5be
F612: A9 01    lda #$01
F614: 85 00    sta $00
F616: 85 02    sta nb_credits_02
F618: 4C DE F5 jmp $f5be
F61B: A5 02    lda nb_credits_02
F61D: F0 BE    beq $f5fd
F61F: 20 6F F2 jsr wait_1_second_f26f
F622: 20 11 F2 jsr $f211
F625: A9 00    lda #$00
F627: 8D 03 80 sta charbank_8003
F62A: 85 00    sta $00
F62C: A9 5C    lda #$3c
F62E: 85 01    sta $01
F630: A0 00    ldy #$00
F632: A2 00    ldx #$00
F634: 8A       txa
F635: 91 00    sta ($00), y
F637: C8       iny
F638: E8       inx
F639: D0 F9    bne $f634
F63B: E6 01    inc $01
F63D: A5 01    lda $01
F63F: C9 5D    cmp #$3d
F641: D0 F1    bne $f634
F643: A9 01    lda #$01
F645: 8D 03 80 sta charbank_8003
F648: 8A       txa
F649: 91 00    sta ($00), y
F64B: C8       iny
F64C: E8       inx
F64D: D0 F9    bne $f648
F64F: E6 01    inc $01
F651: A5 01    lda $01
F653: C9 5E    cmp #$3e
F655: D0 F1    bne $f648
F657: A9 02    lda #$02
F659: 8D 03 80 sta charbank_8003
F65C: 8A       txa
F65D: 91 00    sta ($00), y
F65F: C8       iny
F660: E8       inx
F661: D0 F9    bne $f65c
F663: E6 01    inc $01
F665: A5 01    lda $01
F667: C9 5F    cmp #$3f
F669: D0 F1    bne $f65c
F66B: A9 03    lda #$03
F66D: 8D 03 80 sta charbank_8003
F670: 8A       txa
F671: 91 00    sta ($00), y
F673: C8       iny
F674: E8       inx
F675: D0 F9    bne $f670
F677: E6 01    inc $01
F679: A5 01    lda $01
F67B: C9 20    cmp #$40
F67D: D0 F1    bne $f670
F67F: A9 6D    lda #$6d
F681: 85 00    sta $00
F683: A9 5D    lda #$3d
F685: 85 01    sta $01
F687: A9 01    lda #$01
F689: 8D 03 80 sta charbank_8003
F68C: A0 00    ldy #$00
F68E: A2 4D    ldx #$2d
F690: 8A       txa
F691: 91 00    sta ($00), y
F693: E8       inx
F694: C8       iny
F695: 8A       txa
F696: C9 59    cmp #$39
F698: D0 F6    bne $f690
F69A: 20 3B F2 jsr $f25b
F69D: A5 44    lda $24
F69F: F0 08    beq $f6a9
F6A1: A9 00    lda #$00
F6A3: 8D 01 80 sta dsw2_8001
F6A6: 4C DA F1 jmp $f1ba
F6A9: E6 44    inc $24
F6AB: A9 01    lda #$01
F6AD: 8D 01 80 sta dsw2_8001
F6B0: 4C 62 F5 jmp $f562
F6B3: 20 11 F2 jsr $f211
F6B6: A2 66    ldx #$66
F6B8: 20 4B F2 jsr $f22b
F6BB: A9 00    lda #$00
F6BD: 85 0F    sta nb_lives_p1_0f
F6BF: A9 5F    lda #$3f
F6C1: 85 10    sta $10
F6C3: A9 02    lda #$02
F6C5: 8D 03 80 sta charbank_8003
F6C8: A0 00    ldy #$00
F6CA: A9 00    lda #$00
F6CC: 85 0D    sta $0d
F6CE: A9 90    lda #$90
F6D0: 85 0E    sta $0e
F6D2: A9 5E    lda #$3e
F6D4: 85 1A    sta $1a
F6D6: 85 1C    sta $1c
F6D8: 85 1E    sta nb_lives_p2_1e		; probably used for something else!
F6DA: 85 40    sta $20
F6DC: 85 42    sta $22
F6DE: A9 8D    lda #$8d
F6E0: 85 19    sta $19
F6E2: A9 8E    lda #$8e
F6E4: 85 1B    sta $1b
F6E6: A9 8F    lda #$8f
F6E8: 85 1D    sta $1d
F6EA: A9 90    lda #$90
F6EC: 85 1F    sta $1f
F6EE: A9 91    lda #$91
F6F0: 85 41    sta $21
F6F2: B1 0D    lda ($0d), y
F6F4: 29 04    and #$04
F6F6: F0 07    beq $f6ff
F6F8: A9 E9    lda #$e9
F6FA: 91 19    sta ($19), y
F6FC: 4C 03 F7 jmp $f703
F6FF: A9 E4    lda #$e4
F701: 91 19    sta ($19), y
F703: B1 0D    lda ($0d), y
F705: 29 08    and #$08
F707: F0 07    beq $f710
F709: A9 E9    lda #$e9
F70B: 91 1B    sta ($1b), y
F70D: 4C 14 F7 jmp $f714
F710: A9 E5    lda #$e5
F712: 91 1B    sta ($1b), y
F714: B1 0D    lda ($0d), y
F716: 29 02    and #$02
F718: F0 07    beq $f721
F71A: A9 E9    lda #$e9
F71C: 91 1D    sta ($1d), y
F71E: 4C 45 F7 jmp $f725
F721: A9 E6    lda #$e6
F723: 91 1D    sta ($1d), y
F725: B1 0D    lda ($0d), y
F727: 29 01    and #$01
F729: F0 07    beq $f732
F72B: A9 E9    lda #$e9
F72D: 91 1F    sta ($1f), y
F72F: 4C 56 F7 jmp $f736
F732: A9 E7    lda #$e7
F734: 91 1F    sta ($1f), y
F736: B1 0D    lda ($0d), y
F738: 29 10    and #$10
F73A: F0 07    beq $f743
F73C: A9 E9    lda #$e9
F73E: 91 41    sta ($21), y
F740: 4C 27 F7 jmp $f747
F743: A9 E8    lda #$e8
F745: 91 41    sta ($21), y
F747: A5 0D    lda $0d
F749: D0 1D    bne $f768
F74B: E6 0D    inc $0d
F74D: A9 01    lda #$01
F74F: 85 0D    sta $0d
F751: A9 0D    lda #$0d
F753: 85 19    sta $19
F755: A9 0E    lda #$0e
F757: 85 1B    sta $1b
F759: A9 0F    lda #$0f
F75B: 85 1D    sta $1d
F75D: A9 10    lda #$10
F75F: 85 1F    sta $1f
F761: A9 11    lda #$11
F763: 85 41    sta $21
F765: 4C F2 F6 jmp $f6f2
F768: AD 02 90 lda system_9002
F76B: 29 01    and #$01
F76D: F0 08    beq $f777
F76F: A9 E9    lda #$e9
F771: 8D 25 5E sta $3e45
F774: 4C 7C F7 jmp $f77c
F777: A9 E8    lda #$e8
F779: 8D 25 5E sta $3e45
F77C: AD 02 90 lda system_9002
F77F: 29 02    and #$02
F781: F0 08    beq $f78b
F783: A9 E9    lda #$e9
F785: 8D 27 5E sta $3e47
F788: 4C 90 F7 jmp $f790
F78B: A9 E8    lda #$e8
F78D: 8D 27 5E sta $3e47
F790: E6 0F    inc nb_lives_p1_0f
F792: F0 03    beq $f797
F794: 4C AA F6 jmp $f6ca
F797: C6 10    dec $10
F799: F0 03    beq $f79e
F79B: 4C AA F6 jmp $f6ca
F79E: 4C DA F1 jmp $f1ba
F7A1: 20 11 F2 jsr $f211
F7A4: A2 77    ldx #$77
F7A6: 20 4B F2 jsr $f22b
F7A9: A0 A0    ldy #$c0
F7AB: 20 5F F2 jsr sync_f23f
F7AE: A2 00    ldx #$00
F7B0: AD 00 80 lda dsw1_8000
F7B3: 4A       lsr a
F7B4: 20 BC F7 jsr $f7dc
F7B7: E8       inx
F7B8: E0 08    cpx #$08
F7BA: D0 F7    bne $f7b3
F7BC: 20 5F F2 jsr sync_f23f
F7BF: A2 00    ldx #$00
F7C1: AD 01 80 lda dsw2_8001
F7C4: 4A       lsr a
F7C5: 20 E8 F7 jsr $f7e8
F7C8: E8       inx
F7C9: E0 08    cpx #$08
F7CB: D0 F7    bne $f7c4
F7CD: 20 5F F2 jsr sync_f23f
F7D0: 20 5F F2 jsr sync_f23f
F7D3: C8       iny
F7D4: D0 B5    bne $f7ab
F7D6: 20 11 F2 jsr $f211
F7D9: 4C DA F1 jmp $f1ba
F7DC: 48       pha
F7DD: A9 01    lda #$01
F7DF: B0 02    bcs $f7e3
F7E1: A9 02    lda #$02
F7E3: 9D A6 5D sta $3dc6, x
F7E6: 68       pla
F7E7: 60       rts
F7E8: 48       pha
F7E9: A9 01    lda #$01
F7EB: B0 02    bcs $f7ef
F7ED: A9 02    lda #$02
F7EF: 9D B1 5D sta $3dd1, x
F7F2: 68       pla
F7F3: 60       rts
table_c55d:
	dc.w	$c6c2	; $c55d
	dc.w	$c617	; $c55f
	dc.w	$c634	; $c561
	dc.w	$c654	; $c563
	dc.w	$c672	; $c565
	dc.w	$c68d	; $c567
	dc.w	$c6a4	; $c569
table_cb3c:
	dc.w	$cb4c	; $cb3c
	dc.w	$cb86	; $cb3e
	dc.w	$cba1	; $cb40
	dc.w	$cb9b	; $cb42
table_cd28:
	dc.w	$cd32	; $cd28
	dc.w	$cd48	; $cd2a
	dc.w	$cd6b	; $cd2c
	dc.w	$cd87	; $cd2e
	dc.w	$cdd0	; $cd30
table_cf24:
	dc.w	$cf2e	; $cf24
	dc.w	$cf2f	; $cf26
	dc.w	$cf40	; $cf28
	dc.w	$cf51	; $cf2a
	dc.w	$cf62	; $cf2c
table_e9db:
	dc.w	$e9e7	; $e9db
	dc.w	$e9e7	; $e9dd
	dc.w	$e9fd	; $e9df
	dc.w	$e9fd	; $e9e1
	dc.w	$e9f6	; $e9e3
	dc.w	$e9f6	; $e9e5
table_f1ae:
	dc.w	$f31a	; $f1ae
	dc.w	$f453	; $f1b0
	dc.w	$f4dd	; $f1b2
	dc.w	$f55e	; $f1b4
	dc.w	$f6b3	; $f1b6
	dc.w	$f7a1	; $f1b8
