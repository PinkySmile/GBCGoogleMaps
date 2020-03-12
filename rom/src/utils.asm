; Uncompress compressed data
; Params:
;    hl -> Pointer to the compressed data
;    de -> Destination address
;    bc -> Data size
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
uncompress::
	ld a, [hli]

	ld [de], a
	inc de
	ld [de], a
	inc de

	dec bc
	xor a
	or b
	or c
	jr nz, uncompress
	ret

; Generates a pseudo random number.
; Params:
;    None
; Return:
;    a -> The number generated
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
random::
	push hl

	ld a, [RANDOM_REGISTER]
	ld hl, DIV_REGISTER
	add a, [hl]
	ld [RANDOM_REGISTER], a

	pop hl
	ret

; Puts randm values in VRAM
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Not preserved
trashVRAM::
	call waitVBLANK
	reset LCD_CONTROL
	ld hl, $9FFF
.start:
	call random
	ld [hl-], a
	bit 7, h
	jr nz, .start
	ret

; Loads the font into VRAM
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
loadTextAsset::
	; Save registers
	push af
	push hl
	push bc
	push de

	call waitVBLANK
	; Disable LCD
	reset LCD_CONTROL
	ld hl, textAssets
	ld bc, textAssetsEnd - textAssets
	ld de, VRAM_START
	; Copy text font info VRAM
	call uncompress

	; Restore registers
	pop de
	pop bc
	pop hl
	pop af
	ret

; Wait for VBLANK. Only returns when a VBLANK occurs.
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
waitVBLANK::
	ld a, [LCD_CONTROL] ; Check if LCD is disabled
	bit 7, a
	ret z

	ld a, [INTERRUPT_ENABLED] ; Save old interrupt enabled
	push af
	reset INTERRUPT_REQUEST; Clear old requests
	reg INTERRUPT_ENABLED, VBLANK_INTERRUPT; Enable only VBLANK interrupt
.loop:
	halt   ; Wait for interrupt
	pop af ; Restore old interrupt enabled
	ld [INTERRUPT_ENABLED], a
	ret

; Wait for VBLANK. Only returns when a VBLANK occurs.
; Params:
;    a -> The number of frames to wait for.
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Not preserved
waitFrames::
	ld hl, FRAME_COUNTER
	ld [hl], a
	reg INTERRUPT_ENABLED, VBLANK_INTERRUPT
	xor a
.loop:
	or [hl]
	ret z
	halt
	jr nz, .loop


dispBorderLine::
	ld [hli], a
	inc a
	ld e, 18
.loop:
	ld [hli], a
	dec e
	jr nz, .loop
	inc a
	ld [hli], a
	inc a
	ret

; Displays the keyboard
; Params:
;    None
; Return:
;    None
; Registers
;    af -> Preserved
;    bc -> Preserved
;    de -> Not preserved
;    hl -> Preserved
displayKeyboard::
	push af
	push hl
	push bc
	ld a, 128
	ld hl, $9880
	call dispBorderLine
	ld e, 32
	call .inc
	ld c, 12
.loop:
	ld [hli], a
	inc a
	push af
	ld b, 8

.loop2:
	ld [hl], $00
	inc hl
	ld a, e
	ld [hli], a
	inc e
	dec b
	jr nz, .loop2

	xor a
	ld [hli], a
	ld [hli], a

	pop af
	ld [hli], a
	dec a

	call .inc
	dec c
	jr nz, .loop

	inc a
	inc a
	call dispBorderLine

	pop hl
	pop bc
	pop af
	ret
.inc:
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	ret

; Get all the pressed keys.
; Params:
;    None
; Return:
;    (Pressed when bit is 0)
;    a -> All the pressed keys
;       bit 0 -> Right
;       bit 1 -> Left
;       bit 2 -> Up
;       bit 3 -> Down
;       bit 4 -> A
;       bit 5 -> B
;       bit 6 -> Select
;       bit 7 -> Start
; Registers:
;    af -> Not preserved
;    b  -> Not preserved
;    c  -> Preserved
;    de -> Preserved
;    hl -> Not preserved
getKeys::
	ld hl, $FF00
	ld a, %00010000
	ld [hl], a
	ld a, [hl]
	ld a, [hl]
	ld a, [hl]
	ld a, [hl]
	ld a, [hl]
	and a, $F
	ld b, a
	swap b

	ld a, %00100000
	ld [hl], a
	ld a, [hl]
	ld a, [hl]
	ld a, [hl]
	ld a, [hl]
	ld a, [hl]
	and a, $F
	or b
	ret

; Get all the pressed keys but disabled ones.
; Params:
;    None
; Return:
;    (Pressed when bit is 0)
;    a -> All the pressed keys
;       bit 0 -> Right
;       bit 1 -> Left
;       bit 2 -> Up
;       bit 3 -> Down
;       bit 4 -> A
;       bit 5 -> B
;       bit 6 -> Select
;       bit 7 -> Start
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Preserved
;    hl -> Not preserved
getKeysFiltered::
	call getKeys
	ld b, a
	ld hl, KEYS_DISABLED
	ld a, [hl]
	or b
	ld c, a
	ld a, b
	cpl
	ld [hl], a
	ld a, c
	ret

getSelectedLetter::
	ld hl, OAM_SRC_START
	ld a, [hli]
	sub $38
	rra
	rra
	rra
	and $0F
	swap a
	rra
	ld b, a

	ld a, [hl]
	sub $10
	rra
	rra
	rra
	rra
	and $0F

	or b
	add $20
	ret

; Opens the window to type text in.
; Params:
;    a  -> Character which replace typed text (\0 for no covering)
; Return:
;    [$C004 - $C023] -> The typed text
; Registers:
;    af -> Preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
typeText::
	push af

	ld hl, TYPED_TEXT_BUFFER ; Buffer initial value
	push hl
	call displayKeyboard ; Display keyboard on screen

	xor a
	ld de, OAM_SRC_START
	ld bc, $A0
	call fillMemory

	ld de, TYPED_TEXT_BUFFER
	ld bc, $3F
	call fillMemory

	ld de, $9840
	ld bc, $1F
	call fillMemory

	ld de, OAM_SRC_START
	ld bc, $9F
	call fillMemory

	ld hl, OAM_SRC_START

	ld a, $38
	ld [hli], a
	ld a, $10
	ld [hli], a
	ld a, 127
	ld [hli], a
	ld a, %00100000
	ld [hli], a

	ld hl, STAT_CONTROL
	set 6, [hl]

	reg LYC, $08
	reg INTERRUPT_ENABLED, LCD_STAT_INTERRUPT | VBLANK_INTERRUPT
	reg LCD_CONTROL, LCD_BASE_CONTROL_BYTE_SPRITE
.loop:
	ld a, [LY]
	cp $91
	jr nz, .loop

	call getKeysFiltered

	ld b, a
	bit 4, a ; A
	jr z, .a
.aEnd:

	ld a, b
	bit 0, a ; right
	jr z, .right
.rightEnd:

	ld a, b
	bit 1, a ; left
	jr z, .left
.leftEnd:

	ld a, b
	bit 2, a ; up
	jr z, .up
.upEnd:

	ld a, b
	bit 3, a ; down
	jr z, .down
.downEnd:

	ld a, b
	bit 5, a ; B
	jr z, .b
.bEnd:

	ld a, b
	bit 6, a ; Select
	jr nz, .selectEnd
	jp .select
.selectEnd:

	ld a, b
	bit 7, a ; Start
	jr nz, .loop

	ld hl, STAT_CONTROL
	res 6, [hl]

	pop hl
	pop af
	ret
.right:
	ld a, [OAM_SRC_START + 1]
	cp a, $80
	jr nz, .rightSkip
	xor a
.rightSkip:
	add a, $10
	ld [OAM_SRC_START + 1], a
	jr .rightEnd

.left:
	ld a, [OAM_SRC_START + 1]
	cp a, $10
	jr nz, .leftSkip
	set 7, a
.leftSkip:
	sub a, $10
	ld [OAM_SRC_START + 1], a
	jr .leftEnd

.up:
	ld a, [OAM_SRC_START]
	cp a, $38
	jr nz, .upSkip
	ld a, $98
.upSkip:
	sub a, $8
	ld [OAM_SRC_START], a
	jr .upEnd

.down:
	ld a, [OAM_SRC_START]
	cp a, $90
	jr nz, .downSkip
	ld a, $30
.downSkip:
	add a, $8
	ld [OAM_SRC_START], a
	jr .downEnd

.a:
	pop hl
	ld a, (TYPED_TEXT_BUFFER & $FF) + MAX_TYPED_BUFFER_SIZE
	cp l
	push hl
	jr z, .aEnd

	push bc
	call getSelectedLetter
	ld b, a
	ld a, $7F
	cp b
	ld a, b
	pop bc
	jr z, .b

	pop hl
	ld [hli], a
	ld c, a
	ld de, $9840 - (TYPED_TEXT_BUFFER & $FF)
	ld a, e
	add l
	ld e, a
	pop af
	or a
	push af
	jr nz, .skip
	ld a, c

.skip:
	ld [de], a
	push hl
	jp .aEnd

.b:
	pop hl
	ld a, TYPED_TEXT_BUFFER & $FF
	cp l
	push hl
	jr nz, .continueB
	jp .bEnd

.continueB:
	pop hl
	ld de, $9840 - (TYPED_TEXT_BUFFER & $FF)
	ld a, e
	add l
	ld e, a
	xor a
	dec hl
	ld [hl], a
	ld [de], a
	push hl
	jp .bEnd

.select:
	jp .selectEnd
