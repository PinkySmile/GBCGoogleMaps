loadMap::
	call waitVBLANK
	reset lcdCtrl
	xor a
	ld de, VRAMBgStart
	ld bc, $300
	call fillMemory
	call getTileMap
	reg lcdCtrl, LCD_BASE_CONTROL_BYTE

map::
	call waitVBLANK
	call handlePacket
	jr map