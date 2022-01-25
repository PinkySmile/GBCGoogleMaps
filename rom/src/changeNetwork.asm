changeNetworkConfig::
	call loadTextAsset

	; Change SSID
	ld hl, changeSSIDText
	call displayText
	xor a
	call typeText

	; Set harware SSID
	ld bc, $100
	ld de, myCmdBuffer
	ld hl, typedTextBuffer
	call copyStr
	push bc
	push de

	; Change passwd
	ld hl, networkPasswdText
	call displayText
	ld a, "*"
	call typeText

	; Set hardware passwd
	pop de
	pop bc
	ld hl, typedTextBuffer
	call copyStr

	; Calculate data size
	xor a
	ld b, a
	sub c
	ld c, a
	or a
	jr nz, .skip
	inc b
.skip:
	; Connect to wifi
	xor a
	ld [cartIntTrigger], a

	jp loadMap