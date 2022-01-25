; Called when the pc is at $0038
; Params:
;    None
; Return:
;    None
; Registers:
;    N/A
pcAt38Error::
	ld hl, pc38hText

; Displays an error message and lock CPU
; Params:
;    hl -> Text to display
; Return:
;    None
; Registers:
;    N/A
dispError::
	; Load text fonts
	call loadTextAsset
	; Display given text
	call displayText
	reg lcdCtrl, LCD_BASE_CONTROL_BYTE
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
	reg NR52, $80
	reset chan2Volume
	ld [chan3Enable], a
	ld [chan4Volume], a
	ld c, $03
	ld d, a
.loop:
	reg chan1Len, %10000000
	reg chan1Volume, %11110001
        reg chan1FrequH,%10000001
	reg chan1FrequL, $FF
	ld b, a
.loopWait:
	dec d
	jr nz, .loopWait
	dec b
	jr nz, .loopWait
	dec c
	jr nz, .loop
	jp lockup