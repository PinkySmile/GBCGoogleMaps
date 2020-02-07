initRAM::
	ld hl, $DFFF
.loop:
	ld [hl-], a
	bit 6, h
	jr nz, .loop
	ret

init::
	ei
	push af
	xor a
	call initRAM
	pop af
	ret