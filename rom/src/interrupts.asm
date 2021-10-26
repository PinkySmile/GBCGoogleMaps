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
	ld hl, frameCounter
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
