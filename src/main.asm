include "src/constants.asm"
include "src/macro.asm"

SECTION "Main", ROM0

lockup::
	jr lockup

main::
	cp a, CGB_A_INIT
	jp nz, onlyGBCScreen
	jp lockup

include "src/fatal_error.asm"