changeNetworkConfig::
	ld hl, commandBuffer
	push hl

	call loadTextAsset
	ld hl, changeSSIDText
	call displayText
	xor a
	call typeText

	pop de
	ld hl, typedTextBuffer
	ld bc, MAX_TYPED_BUFFER_SIZE
	call copyMemory
	push de

	; Change passwd
	ld hl, networkPasswdText
	call displayText
	ld a, "*"
	call typeText

	pop de
	ld hl, typedTextBuffer
	ld bc, MAX_TYPED_BUFFER_SIZE
	call copyMemory

	; Connect to wifi
	send_command CONNECT_WIFI, $3E
	jp map