include "src/constants.asm"
include "src/macro.asm"

SECTION "Main", ROM0

; Locks the CPU
; Params:
;    None
; Return:
;    None
; Registers:
;    N/A
lockup::
	reset INTERRUPT_ENABLED
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
	reg HARDWARE_TYPE, $01  ; Sets the hardware type register to GBC
	ei
	jr welcomeScreen        ; Run main program

SGB:                            ; We are on Super Gameboy
	call loadSGBBorder      ; Load the SGB boarder and display it
	reg HARDWARE_TYPE, $02  ; Sets the hardware type register to SGB
	ei
	jr welcomeScreen        ; Run main program

; Runs the main program
welcomeScreen::
	call loadTextAsset

	xor a
	ld de, VRAM_BG_START
	ld bc, $800
	call fillMemory

	ld hl, generalInfos
	call displayText
	reg LCD_CONTROL, LCD_BASE_CONTROL_BYTE
.loop:
	call getKeysFiltered
	xor $FF
	jr z, .loop

changeSSID::
	ld hl, COMMAND_BUFFER
	push hl

	call loadTextAsset
	ld hl, changeSSIDText
	call displayText
	xor a
	call typeText

	pop de
	ld hl, TYPED_TEXT_BUFFER
	ld bc, MAX_TYPED_BUFFER_SIZE
	call copyMemory
	push de

	; Change passwd
	ld hl, networkPasswdText
	call displayText
	ld a, "*"
	call typeText

	pop de
	ld hl, TYPED_TEXT_BUFFER
	ld bc, MAX_TYPED_BUFFER_SIZE
	call copyMemory

	; Connect to wifi
	send_command CONNECT_WIFI, $3E

	jp welcomeScreen


include "src/init.asm"
include "src/fatal_error.asm"
include "src/utils.asm"
include "src/sgb_utils.asm"
include "src/interrupts.asm"
include "src/strutils.asm"