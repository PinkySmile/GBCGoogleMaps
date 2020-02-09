include "src/constants.asm"
include "src/macro.asm"

SECTION "Main", ROM0

lockup::
	reg INTERRUPT_ENABLED, $00
	halt

testSGB::
	ld a, MLT_REQ
	ld hl, MLT_REQ_PAR
	call sendSGBCommand
	ld hl, JOYPAD_REGISTER
	ld b, [hl]
	ld [hl], %11100000
	ld [hl], %11010000
	ld [hl], %11110000
	ld a, [hl]
	xor b
	ret

DMG:
	jp onlyGBCScreen
GBC:
	reg HARDWARE_TYPE, $01
	jr run
SGB:
	call loadSGBBorder
	reg HARDWARE_TYPE, $02
	jr run

main::
	call init
	ld sp, $E000

	cp a, CGB_A_INIT
	jr z, GBC
	call testSGB
	jr z, DMG
	jr SGB

run::
	jp lockup

include "src/init.asm"
include "src/fatal_error.asm"
include "src/utils.asm"
include "src/sgb_utils.asm"
include "src/interrupts.asm"