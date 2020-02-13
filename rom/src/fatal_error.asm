; Displays an error message and lock CPU
; Params:
;    hl -> Text to display
;    bc -> Length of the text
; Return:
;    None
; Registers:
;    N/A
dispError::
	; Load text fonts
	call loadTextAsset
	; Display given text
	call displayText
	; Play a sound and lock CPU
	jp fatalError

; Plays sound and locks CPU
; Params:
;    None
; Return:
;    None
; Registers:
;    N/A
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