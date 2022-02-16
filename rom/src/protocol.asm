; Sends a command to the micro controller
; Params:
;    a  -> Opecode
;    hl -> Command data buffer
;    bc -> Data size
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
sendCommand: MACRO
	ld de, $A001
	call copyMemory
	ld a, \1
	ld [$A000], a
ENDM

; Fetch the current tilemap to display from the server
; Params:
;    a  -> Opcode
;    hl -> Command data buffer
;    bc -> Data size
; Return:
;    [tileMap - tileMap + $3FF] -> Loaded tilemap
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
getTileMap:
	; Prepare the command
	ld hl, myCmdBuffer
	ld a, SERVER_REQU
	ld [hli], a

	ld a, 4
	ld [hli], a
	xor a
	ld [hli], a

	inc a
	ld [hli], a

	ld a, [bgScrollX]
	sub $30
	ld [hli], a

	ld a, [bgScrollY]
	sub $38
	ld [hli], a

	ld a, [zoomLevel]
	ld [hli], a

	xor a
	ld [cartIntTrigger], a
	ret

handlePacket::
	ld hl, cartCmdBuffer
.loop:
	ld a, [hli]
	or a
	ret z
	dec a
	jr z, .wifi ; 1 WiFi status
	dec a
	jr z, .srvResp ; 2 Server Response
	dec a
	jr z, .err ; 3 Error
	;dec a
	;jr z, .queueFull ; 4 Data queue is full
.end:
	xor a
	ld [cartCmdBuffer], a
	ret
.wifi:
	ld a, [hli]
	ld [wifiLevel], a
	jr .loop
.srvResp:
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	call handleServerPacket
	jr .loop
.err:
	ld de, VRAMBgStart
.errLoop:
	ld a, [hli]
	or a
	jr z, .loop
	ld [de], a
	inc de
	jr .errLoop

handleServerPacket::
	ld a, [hli]
	or a
	ret z
	dec a
	jr z, .tilemap ; 1 Map data
	dec a
	jr z, .err ; 2 Error
	ret
.err:
	ld de, VRAMBgStart
	jp copyMemory
	;ret
.tilemap:
	ld bc, 32 * 32
	add hl, bc
	ret