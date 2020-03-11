SECTION "Text", ROMX[$7000], BANK[1]

include "src/constants.asm"

; The text displayed when playing on a Gameboy
onlyGBCtext::
	db "You need a", 10
	db "Gameboy Color", TM_CHARACTER, " or a", 10
	db "Super Gameboy", TM_CHARACTER, 10
	db "to run this.", 0

pc38hText::
	db "Fatal error: PC 38h", 0

generalInfos::
	db "Google Maps", 10, 10
	db "[A]: Search location", 10, 10, 10
	db "[B]: Network", 10
	db "     configuration", 10, 10, 10
	db "Select: Go back", 10
	db "        to map", 10, 10, 10
	db "Directions: Move map", 0