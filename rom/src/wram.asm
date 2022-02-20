SECTION "RAM", WRAM0

include "src/constants.asm"

frameCounter::
	ds $1
hardwareType::
	ds $1
randomRegister::
	ds $1
keysDisabled::
	ds $1
typedTextBuffer::
	ds MAX_TYPED_BUFFER_SIZE
zoomLevel::
	ds $1
wifiLevel::
	ds $1

SECTION "OAM", WRAM0[$C500]
oamSrc::
	ds $A0

stackTop::
	ds $C800 - stackTop
stackBottom::

SECTION "MAP", WRAMX[$D000]
tileMap::
	ds $400

SECTION "CDATA", SRAM[$A000]
myCmdBuffer::
	ds $100
cartCmdBuffer::
	ds $2FE
cartIntTrigger::
	ds $1
myIntTrigger::
	ds $1

SECTION "CCTRL", SRAM[$B3FE]
cartCtrl::
	ds $1