changeNetworkConfig::
	call loadTextAsset

	; Change SSID
	ld hl, changeSSIDText
	call displayText
	xor a
	call typeText

	; Set harware SSID
	send_command SET_SSID, typedTextBuffer, MAX_TYPED_BUFFER_SIZE

	; Change passwd
	ld hl, networkPasswdText
	call displayText
	ld a, "*"
	call typeText

	; Set harware passwd
	send_command SET_PASSWD, typedTextBuffer, MAX_TYPED_BUFFER_SIZE

	; Connect to wifi
	send_command_nodata CONNECT_WIFI
	jp map