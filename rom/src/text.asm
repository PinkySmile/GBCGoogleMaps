SECTION "Text", ROMX[$7000], BANK[1]

include "src/constants.asm"

; The text displayed when playing on a Gameboy
onlyGBCtext::
	db "You need a   ", " ",          "                  "
	db "Gameboy Color", TM_CHARACTER, " or a             "
	db "Super Gameboy", TM_CHARACTER, "                  "
	db "to run this."
onlyGBCtextEnd::

pc38hText::
	db "Fatal error: PC 38h"
pc38hTextEnd::
