; SGB Opcodes
MLT_REQ_PAR:
MASK_EN_FREEZE_PAR:
	db $01
CHR_TRN_PAR:
PCT_TRN_PAR:
PAL_TRN_PAR:
MASK_EN_CANCEL_PAR:
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
DATA_SND_PAR:
	db $5D, $08, $00, $0B, $8C, $D0, $F4, $60, $00, $00, $00, $00, $00, $00, $00
	db $52, $08, $00, $0B, $A9, $E7, $9F, $01, $C0, $7E, $E8, $E8, $E8, $E8, $E0
	db $47, $08, $00, $0B, $C4, $D0, $16, $A5, $CB, $C9, $05, $D0, $10, $A2, $28
	db $3C, $08, $00, $0B, $F0, $12, $A5, $C9, $C9, $C8, $D0, $1C, $A5, $CA, $C9
	db $31, $08, $00, $0B, $0C, $A5, $CA, $C9, $7E, $D0, $06, $A5, $CB, $C9, $7E
	db $26, $08, $00, $0B, $39, $CD, $48, $0C, $D0, $34, $A5, $C9, $C9, $80, $D0
	db $1B, $08, $00, $0B, $EA, $EA, $EA, $EA, $EA, $A9, $01, $CD, $4F, $0C, $D0
	db $10, $08, $00, $0B, $4C, $20, $08, $EA, $EA, $EA, $EA, $EA, $60, $EA, $EA

loadSGBBorder::
	reg PALETTE_REGISTER, $E4
	ld a, MASK_EN
	ld hl, MASK_EN_FREEZE_PAR
	call sendSGBCommand

	ld e, $8
	ld hl, DATA_SND_PAR
.loop:
	ld a, DATA_SND
	call sendSGBCommand
	dec hl
	dec e
	jr nz, .loop

	call trashVRAM
	ld a, CHR_TRN
	ld hl, CHR_TRN_PAR
	reg LCD_CONTROL, %10010001
	call sendSGBCommand

	call trashVRAM
	ld a, PCT_TRN
	ld hl, PCT_TRN_PAR
	reg LCD_CONTROL, %10010001
	call sendSGBCommand
	
	call trashVRAM
	ld a, PAL_TRN
	ld hl, PAL_TRN_PAR
	reg LCD_CONTROL, %10010001
	call sendSGBCommand

	ld a, MASK_EN
	ld hl, MASK_EN_CANCEL_PAR
	call sendSGBCommand

sendSGBVal::
	ld [JOYPAD_REGISTER], a
	nop
	reg JOYPAD_REGISTER, %00110000
	ret

sendSGBPacketBit::
	push af

	bit 0, a
	jr z, .val2
	ld a, $10
	jr .end
.val2:
	ld a, $20
.end:

	call sendSGBVal
	pop af
	ret

sendSGBPacketByte::
	ld d, 8
.loop:
	call sendSGBPacketBit
	rra
	dec d
	jr nz, .loop
	ret

sendSGBCommand::
	push de
	push af
	xor a
	call sendSGBVal
	ld e, $10
	pop af

.loop:
	call sendSGBPacketByte
	ld a, [hli]
	dec e
	jr nz, .loop

	ld a, $20
	call sendSGBVal
	pop de
	ret
