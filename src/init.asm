initRAM::
	ld b, a
	ld a, [RANDOM_REGISTER]
	push af
	ld a, b
	ld hl, $DFFF
.loop:
	ld [hl-], a
	bit 6, h
	jr nz, .loop
	pop af
	ld [RANDOM_REGISTER], a
	ret

init::
	ei
	push af
	xor a
	call initRAM
	pop af
	ret