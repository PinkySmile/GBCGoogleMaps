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