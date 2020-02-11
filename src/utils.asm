; The fonts used.
textAssets: incbin "assets/font.fx"
textAssetsEnd:

; Generates a pseudo random number.
; Params:
;    None
; Return:
;    a -> The number generated
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
random::
	push hl

	ld a, [RANDOM_REGISTER]
	ld hl, DIV_REGISTER
	add a, [hl]
	ld [RANDOM_REGISTER], a

	pop hl
	ret

; Puts randm values in VRAM
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Not preserved
trashVRAM::
	call waitVBLANK
	reg LCD_CONTROL, $00
	ld hl, $9FFF
.start:
	call random
	ld [hl-], a
	bit 7, h
	jr nz, .start
	ret

; Loads the font into VRAM
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
loadTextAsset::
	; Save registers
	push af
	push hl
	push bc
	push de

	call waitVBLANK
	; Disable LCD
	reg LCD_CONTROL, $00
	ld hl, textAssets
	ld bc, textAssetsEnd - textAssets
	ld de, VRAM_START
	; Copy text font info VRAM
	call copyMemory

	; Restore registers
	pop de
	pop bc
	pop hl
	pop af
	ret

; Copies a chunk of memory into another
; Params:
;    bc -> The length of the chunk to copy
;    de -> The destination address
;    hl -> The source address
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
copyMemory::
	xor a ; Check if size is 0
	or b
	or c
	ret z

	; Copy a byte of memory from hl to de
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	jr copyMemory ; Recurse until bc is 0

; Fill a chunk of memory with a single value
; Params:
;    a  -> Value to fill
;    bc -> The length of the chunk to copy
;    de -> The destination address
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Preserved
fillMemory::
	push af ; Save a
	xor a   ; Check if bc is 0
	or b
	or c
	jr z, .return
	pop af

	; Load a into de
	ld [de], a
	inc de
	dec bc
	jr fillMemory ; Recurse intil bc is 0
.return: ; End of recursion
	pop af
	ret

; Wait for VBLANK. Only returns when a VBLANK occurs.
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
waitVBLANK::
	ld a, [LCD_CONTROL] ; Check if LCD is disabled
	bit 7, a
	ret z

	ld a, [INTERRUPT_ENABLED] ; Save old interrupt enabled
	push af
	reg INTERRUPT_REQUEST, $00; Clear old requests
	reg INTERRUPT_ENABLED, $01; Enable only VBLANK interrupt
.loop:
	halt   ; Wait for interrupt
	pop af ; Restore old interrupt enabled
	ld [INTERRUPT_ENABLED], a
	ret

; Displays text on screen.
; Params:
;    bc -> Length of the text.
;    hl -> Pointer to the start of the text.
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
displayText::
	call waitVBLANK
	reg LCD_CONTROL, $00
	ld de, VRAM_BG_START
	call copyMemory
	reg LCD_CONTROL, %10010001
	ret

; Wait for VBLANK. Only returns when a VBLANK occurs.
; Params:
;    a -> The number of frames to wait for.
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Not preserved
waitFrames::
	ld hl, FRAME_COUNTER
	ld [hl], a
	reg INTERRUPT_ENABLED, $01
	xor a
.loop:
	or [hl]
	ret z
	halt
	jr nz, .loop

; Opens the window to type text in.
; Params:
;    a  -> Character which replace typed text (\0 for no covering)
;    hl -> Pointer to a buffer.
;    bc -> Buffer max size.
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
typeText::
	call loadTextAsset
