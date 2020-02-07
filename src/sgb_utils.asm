; SGB Opcodes
MLT_REQ:
	db $89, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

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
	push af
	xor a
	call sendSGBVal
	ld e, $00

.loop:
	ld a, [hli]
	call sendSGBPacketByte
	dec e
	jr nz, .loop

	ld a, $10
	call sendSGBVal
	pop af
	ret
