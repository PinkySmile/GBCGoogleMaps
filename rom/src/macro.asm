; Like doing ld [**], *
; VBLANK interrupt handler
; Params:
;    \1 -> Address to write to
;    \2 -> Value to write
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
reg: MACRO
	ld a, \2
	ld [\1], a
ENDM

min: MACRO
	cp \1
	jr c, .skip\@
	ld a, \1
.skip\@::
ENDM

reset: MACRO
	xor a
	ld [\1], a
ENDM

send_command_nodata: MACRO
	ld a, \1
	ld [SEND_COMMAND_REGISTER], a
ENDM

send_command: MACRO
	send_command_nodata CLEAR_BUFFER1

	ld hl, \2
	call getStrLen
	min \3
	ld b, 0
	ld c, a
	ld hl, \2
	ld de, BUFFER1_STREAM_REGISTER
	call copyMemorySingleAddr

	ld a, \1
	ld [SEND_COMMAND_REGISTER], a
ENDM