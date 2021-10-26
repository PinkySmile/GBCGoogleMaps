include "src/constants.asm"
include "src/macro.asm"
include "src/registers.asm"

SECTION "Main", ROM0

; Locks the CPU
; Params:
;    None
; Return:
;    None
; Registers:
;    N/A
lockup::
	reset interruptEnable
	halt

; Tests if the current hardware is SGB
; Params:
;    None
; Return:
;    a      -> 0 if on DMG. 1 if on SGB.
;    Flag Z -> 1 if on DMG. 0 if on SGB.
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
testSGB::
	ld a, MLT_REQ
	ld hl, MLT_REQ_PAR_EN
	call sendSGBCommand
	ld hl, joypad
	ld b, [hl]
	ld [hl], %11100000
	ld [hl], %11010000
	ld [hl], %11110000
	ld a, [hl]
	xor b
	push af
	ld a, MLT_REQ
	ld hl, MLT_REQ_PAR_DS
	call sendSGBCommand
	pop af
	ret

; Main function
main::
	call init               ; Init
	ld sp, $E000            ; Init stack

	cp a, CGB_A_INIT        ; Check if on Gameboy Color
	jr z, GBC
	call testSGB            ; Check if on SGB
	jr z, DMG
	jr SGB

DMG:                            ; We are on monochrome Gameboy
	ld hl, onlyGBCtext
	jp dispError            ; Display error message

GBC:                            ; We are on Gameboy Color
	call setupGBCPalette    ; Setup palettes
	reg hardwareType, $01  ; Sets the hardware type register to GBC
	ei
	jr welcomeScreen        ; Run main program

SGB:                            ; We are on Super Gameboy
	call loadSGBBorder      ; Load the SGB boarder and display it
	reg hardwareType, $02  ; Sets the hardware type register to SGB
	ei
	jr welcomeScreen        ; Run main program

; Runs the main program
welcomeScreen::
	call loadTextAsset

	ld de, BGPI
	ld a, $88
	ld [de], a
	inc de

	ld hl, googleLogoLeftPal
	ld bc, $10
	call copyMemorySingleAddr

	ld de, $8010
	ld hl, googleLogoLeft
	ld bc, googleLogoRightEnd - googleLogoLeft
	call copyMemory

	xor a
	ld de, VRAMBgStart
	ld bc, $800
	call fillMemory

	ld hl, generalInfos
	call displayText
	reg lcdCtrl, LCD_BASE_CONTROL_BYTE
.loop:
	call waitVBLANK
	call getKeysFiltered

	ld b, a
	bit 4, a ; A
	jr nz, .aEnd
	jp search
.aEnd:

	ld b, a
	bit 6, a ; Select
	jr nz, .selectEnd
	jp map
.selectEnd:

	ld a, b
	bit 5, a
	jr nz, .loop
	jp changeNetworkConfig


include "src/changeNetwork.asm"
include "src/search.asm"
include "src/map.asm"
include "src/init.asm"
include "src/fatal_error.asm"
include "src/utils.asm"
include "src/sgb_utils.asm"
include "src/interrupts.asm"
include "src/strutils.asm"
include "src/palettes.asm"
include "src/sgb_border.asm"