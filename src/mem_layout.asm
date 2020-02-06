; Crash handler
SECTION "rst 38h", ROM0
	jp fatalError

SECTION "vblank", ROM0
	reti

SECTION "hblank", ROM0
	reti

SECTION "timer", ROM0 
	reti

SECTION "serial", ROM0
	reti

SECTION "joypad", ROM0
	reti

SECTION "Start", ROM0
	nop
	jp main

SECTION "Header", ROM0
	ds $150 - $104
