onlyGBCtext::
	db "You need a Gameboy              Color", TM_CHARACTER, " to run this."
onlyGBCtextEnd:

onlyGBCScreen::
	call loadTextAsset
	ld hl, onlyGBCtext
	ld bc, onlyGBCtextEnd - onlyGBCtext
	call displayText
	jp fatalError

fatalError::
	reg DISABLE_CHANNELS_REGISTERS, $80
	reg CHANNEL2_VOLUME, $00
	reg CHANNEL3_ON_OFF, $00
	reg CHANNEL4_VOLUME, $00
	ld c, $03
	ld d, $00
.loop:
	reg CHANNEL1_LENGTH, %10000000
	reg CHANNEL1_VOLUME, %11110001
	reg CHANNEL1_LOW_FREQ, $FF
        reg CHANNEL1_HIGH_FREQ,%10000001
	ld b, $FF
.loopWait:
	dec d
	jr nz, .loopWait
	dec b
	jr nz, .loopWait
	dec c
	jr nz, .loop
	jp lockup