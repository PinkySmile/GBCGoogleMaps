include "constants.asm"
include "macro.asm"

SECTION "Main", ROM0

main::
	ld hl, $9800
	reg INTERRUPT_ENABLED, $01
.loop:
	xor a
	ld [$FF0F], a
	ld [hli], a
	inc a
	ld [hl], a
	halt
	jr .loop
