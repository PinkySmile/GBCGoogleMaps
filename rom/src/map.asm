ZOOM_MAX = 20

loadTiles::
	ld de, $9000
	ld hl, tilemap
	ld bc, $800
	call copyMemory

	ld de, $8800
	ld hl, tilemap + $800
	ld bc, $800
	jp copyMemory

loadMap::
	call waitVBLANK
	reset lcdCtrl
	xor a
	ld de, VRAMBgStart
	ld bc, $300
	call fillMemory
	call loadTiles
	ld bc, 0
	call getTileMap
	reg lcdCtrl, LCD_BASE_CONTROL_BYTE

map::
	call waitVBLANK
	call handlePacket
	call getKeysFiltered
	ld bc, $0000
	bit 7, a ; Start
	jp z, welcomeScreen
	bit 5, a ; B
	jr z, .zoomOut
	bit 4, a ; A
	jr z, .zoomIn
	bit 0, a ; Right
	jr z, .scrollRight
	bit 1, a ; Left
	jr z, .scrollLeft
	bit 2, a ; Up
	jr z, .scrollUp
	bit 3, a ; Down
	jr nz, map

.scrollDown:
	ld c, $EE
	call getTileMap
	jr map
.scrollLeft:
	ld b, $EC
	call getTileMap
	jr map
.scrollRight:
	ld b, $14
	call getTileMap
	jr map
.scrollUp:
	ld c, $12
	call getTileMap
	jr map

.zoomOut:
	ld hl, zoomLevel
	xor a
	or [hl]
	jr z, map
	dec [hl]
	call getTileMap
	jr map
.zoomIn:
	ld hl, zoomLevel
	ld a, ZOOM_MAX
	cp [hl]
	jr z, map
	inc [hl]
	call getTileMap
	jr map