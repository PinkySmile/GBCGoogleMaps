vblank_interrupt::
	push hl
	ld hl, FRAME_COUNTER
	or [hl]
	jr z, .skip
	dec [hl]
.skip:
	pop hl
	reti

hblank_interrupt::
	reti

timer_interrupt::
	reti

serial_interrupt::
	reti

joypad_interrupt::
	reti
