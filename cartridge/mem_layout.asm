; Crash handler
SECTION "rst 38h", ROM0
	rst $38

SECTION "vblank", ROM0
	ret

SECTION "hblank", ROM0
	rst $38

SECTION "timer", ROM0
	rst $38

SECTION "serial", ROM0
	rst $38

SECTION "joypad", ROM0
	rst $38

SECTION "Start", ROM0
	nop
	jp main

SECTION "Header", ROM0
	ds $150 - $104
