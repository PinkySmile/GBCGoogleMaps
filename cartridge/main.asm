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
	ld [hl], $19
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
	reset INTERRUPT_REQUEST
	reg INTERRUPT_ENABLED, $01
	halt
	reset $FF40
	ld hl, $8000
.loop:
	ld [hli], a
	bit 5, h
	jr z, .loop

	ld a, 4
	ld de, $8010
	ld hl, (EpitechLogo + $C000 - programStart)
.loop2:
	push af

	ld bc, (EpitechLogoEnd - EpitechLogo) / 4
	call uncompress

	ld bc, $70
	push hl
	ld h, d
	ld l, e
	add hl, bc
	ld d, h
	ld e, l
	pop hl

	pop af
	dec a
	jr nz, .loop2

	xor a
	inc a
	ld e, 4
	ld hl, $98E8
	ld bc, $07
	ld d, 14
.loop3:
	ld [hli], a
	inc a
	dec d
	jr nz, .loop3
	push de
	ld de, $20 - 14
	add hl, de
	ld d, 7
	add d
	pop de
	ld d, 14
	dec e
	jr nz, .loop3

	reg $FF40, %10010001

	ld a, [$7EE]
.start:
	call (getInputs + $C000 - programStart)
	ld hl, $FF42
	bit 2, a
	jr nz, .skip1
	inc [hl]

.skip1:
	bit 3, a
	jr nz, .skip2
	dec [hl]

.skip2:
	ld hl, $FF43
	bit 1, a
	jr nz, .skip3
	inc [hl]

.skip3:
	bit 0, a
	jr nz, .skip4
	dec [hl]

.skip4:
	bit 4, a
	reg $FF47, %11111100
	jr z, .skip5
	reg $FF47, %00000011
.skip5:
	reset INTERRUPT_REQUEST
	halt
	jr .start

getInputs::
	ld hl, $7FF
	ld a, [hl]
	ret
uncompress::
	ld a, [hli]

	ld [de], a
	inc de
	ld [de], a
	inc de

	dec bc
	xor a
	or b
	or c
	jr nz, uncompress
	ret
EpitechLogo::
	incbin "epitech.fx"
EpitechLogoEnd::
programEnd::
