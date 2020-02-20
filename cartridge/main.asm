include "constants.asm"
include "macro.asm"

SECTION "Main", ROM0

main::
	ld c, (programEnd - programStart) / 20 + 1
	ld b, c
	ld hl, programStart
	ld de, $C000
	reset $FF80
	reg INTERRUPT_ENABLED, $01
.loop:
	reset INTERRUPT_REQUEST
	halt
	dec b
	jr nz, .skip

	ld b, c
	push hl
	ld a, [$FF80]
	ld h, $98
	ld l, a
	ld [hl], $03
	pop hl
	inc a
	ld [$FF80], a
.skip:
	ld a, [hli]
	ld [de], a
	inc de

	ld a, programEnd & $FF
	cp l
	jr nz, .loop

	ld a, programEnd >> 8
	cp h
	jr nz, .loop

	jp $C000



programStart::
	ld hl, $9800
	reg INTERRUPT_ENABLED, $01

	reg DISABLE_CHANNELS_REGISTERS, $80
	reset CHANNEL2_VOLUME
	reset CHANNEL3_ON_OFF
	reset CHANNEL4_VOLUME
.start:
	ld c, $03
	ld d, $00
.loop1:
	reg CHANNEL1_LENGTH, %10000000
	reg CHANNEL1_VOLUME, %11110001
	reg CHANNEL1_LOW_FREQ, $FF
        reg CHANNEL1_HIGH_FREQ,%10000001
	ld b, $FF
.loopWait:
	dec d
	jr nz, .loopWait
	dec b
	jr nz, .loopWait
	dec c
	jr nz, .loop1

	reset INTERRUPT_REQUEST
	halt
	xor a
	ld [$FF0F], a
	ld [hli], a
	inc a
	ld [hl], a

	jr .start
programEnd::
