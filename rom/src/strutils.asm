; Gets the length of a null terminated string
; Params:
;    hl -> A pointer to the string
; Return:
;    hl -> A pointer to the end of the string
;    a  -> The length computed
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Not preserved
str_len::
	xor a
.loop:
	push af
	ld a, [hli]
	or a
	jr z, .end
	pop af
	inc a
	jr .loop
.end:
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

; Displays text on screen.
; Params:
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
	reset LCD_CONTROL
	ld de, VRAM_BG_START
.loop:
	ld a, [hli]

	or a
	ret z

	cp 10
	jr z, .newLine

	ld [de], a
	inc de

	jr .loop
.newLine:
	inc de
	ld a, %11111
	and e
	jr nz, .newLine
	jr .loop
