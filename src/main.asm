include "src/constants.asm"
include "src/macro.asm"

SECTION "Main", ROM0

lockup::

	halt

testSGB::
	xor a
	ld hl, MLT_REQ
	call sendSGBCommand
	ld a, [JOYPAD_REGISTER]
	and a, 1
	ret

DMG:
	jr onlyGBCScreen
GBC:
	reg HARDWARE_TYPE, $01
	jr run
SGB:
	reg HARDWARE_TYPE, $02
	jr run

main::
	call init
	ld sp, $E000

	cp a, CGB_A_INIT
	jr z, GBC
	call testSGB
	or a
	jr nz, DMG
	jr SGB

run::
	jp lockup

include "src/init.asm"
include "src/fatal_error.asm"
include "src/utils.asm"
include "src/sgb_utils.asm"
include "src/interrupts.asm"