; Routine in HRAM that start DMA.
; Params:
;    a The start address divided by $100.
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
initDMA::
	ld [START_DMA], a
	ld a, DMA_DELAY
.wait:
	dec a
	jr nz, .wait
	ret
initDMA_end:

; Enable interupts and init RAM
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
init::
	push af

	call waitVBLANK
	reset LCD_CONTROL
	ld de, VRAM_START + $10
	ld bc, $190
	call fillMemory

	ld bc, $2000
	ld de, $C000
	call fillMemory

	ld bc, initDMA_end - initDMA
	ld de, DMA
	ld hl, initDMA
	call copyMemory

	pop af
	ret

; Setups the GBC palette data
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Not preserved
setupGBCPalette::
	call waitVBLANK
	ld a, $86;
	ld hl, BGPI
	ld [hli], a
	xor a
	ld [hl], a
	ld [hli], a

	ld a, $86;
	ld [hli], a
	xor a
	ld [hl], a
	ld [hl], a
	ret