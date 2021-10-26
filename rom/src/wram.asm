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
commandBuffer::
	ds $30
bankPtr::
	ds $2

SECTION "OAM", WRAM0[$C500]
oamSrc::
	ds $A0

stackTop::
	ds $C800 - stackTop
stackBottom::

SECTION "MAP", WRAMX[$D000]
tileMap::
	ds $1000