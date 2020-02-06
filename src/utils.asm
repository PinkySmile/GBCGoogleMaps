textAssets: incbin "assets/font.fx"

loadTextAsset::
	reg [LCD_CONTROL], $00
	ld hl, textAssets
	ld bc, loadTextAsset - textAssets
	ld de, VRAM_START
	call copyMemory
	ret

copyMemory::
	xor a
	or b
	or c
	ret z
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

displayText::
	reg [LCD_CONTROL], $00
	ld de, VRAM_BG_START
	call copyMemory
	reg [LCD_CONTROL], %10010001
	ret