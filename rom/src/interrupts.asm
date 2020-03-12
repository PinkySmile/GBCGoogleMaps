; VBLANK interrupt handler
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
vblank_interrupt::
	push af
	push hl
	xor a
	ld hl, FRAME_COUNTER
	or [hl]
	jr z, .skip
	dec [hl]
.skip:
	ld a, OAM_SRC_START / $100
	call DMA
	pop hl
	pop af
	reti

; HBLANK interrupt handler
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
hblank_interrupt::
	push hl
	push af
	ld a, 1
	ld hl, CREDITS_SLIDING
	xor [hl]
	ld [hl], a
	bit 0, a
	jr z, .reset

	ld hl, TYPED_TEXT_BUFFER
	call str_len

	sub $13
	jr c, .skip

	inc a
	rla
	rla
	rla
	and %11111000

	ld [SCROLL_X], a

.skip:
	ld hl, LYC
	ld a, [hl]
	add $10
	ld [hl], a
	jr .end
.reset:
	reset SCROLL_X
	ld hl, LYC
	ld a, [hl]
	sub $10
	ld [hl], a

.end:
	pop af
	pop hl
	reti

; Timer interrupt handler
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
timer_interrupt::
	reti

; Serial interrupt handler
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
serial_interrupt::
	reti

; Joypad interrupt handler
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
joypad_interrupt::
	reti
