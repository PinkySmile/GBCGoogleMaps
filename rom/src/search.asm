search::
	call loadTextAsset

	; Change SSID
	ld hl, searchText
	call displayText
	xor a
	call typeText

	; Prepare the command
	ld hl, myCmdBuffer
	ld a, SERVER_REQU
	ld [hli], a

	push hl
	ld hl, typedTextBuffer
	call getStrLen
	pop hl
	inc a
	ld [hli], a
	xor a
	ld [hli], a

	ld a, 2
	ld [hli], a

	ld bc, $100
	ld d, h
	ld e, l
	ld hl, typedTextBuffer
	call copyStr

	xor a
	ld [cartIntTrigger], a

	call waitVBLANK
	reset lcdCtrl
	xor a
	ld de, VRAMBgStart
	ld bc, $300
	call fillMemory
	call loadTiles
	reg lcdCtrl, LCD_BASE_CONTROL_BYTE

	jp map