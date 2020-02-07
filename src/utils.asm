textAssets: incbin "assets/font.fx"
textAssetsEnd:

loadTextAsset::
	call waitVBLANK
	reg LCD_CONTROL, $00
	ld hl, textAssets
	ld bc, textAssetsEnd - textAssets
	ld de, VRAM_START
	call copyMemory
	ret

copyMemory::
	xor a
	or b
	or c
	ret z
	xor a
	or c
	jr z, .loop
	inc b
.loop:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	ret

fillMemory::
	push af
	xor a
	or b
	or c
	ret z
	xor a
	or c
	pop af
	jr z, .loop
	inc b
.loop:
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	ret

waitVBLANK::
	ld a, [LCD_CONTROL]
	bit 7, a
	ret z

	ld hl, sp-2
	ld a, [INTERRUPT_ENABLED]
	push af
	reg INTERRUPT_ENABLED, $01
.loop:
	halt
	pop af
	ld [INTERRUPT_ENABLED], a
	ret

displayText::
	call waitVBLANK
	reg LCD_CONTROL, $00
	ld de, VRAM_BG_START
	call copyMemory
	reg LCD_CONTROL, %10010001
	ret

waitFrames::
	ld hl, FRAME_COUNTER
	or [hl]
	ret z
	halt
	jp nz, waitFrames

waitTime::
	xor a
	dec bc
	or b
	or c
	jr nz, waitTime
	ret
