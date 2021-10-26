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

reset: MACRO
	xor a
	ld [\1], a
ENDM

send_command: MACRO
	ld de, SEND_COMMAND_REGISTER + 1
	ld hl, commandBuffer
	ld bc, \2
	call copyMemory

	ld a, \1
	ld [SEND_COMMAND_REGISTER], a
ENDM