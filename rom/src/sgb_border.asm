DATA_PART_1::
	db $5D, $08, $00, $0B, $8C, $D0, $F4, $60, $00, $00, $00, $00, $00, $00, $00
DATA_PART_2::
	db $52, $08, $00, $0B, $A9, $E7, $9F, $01, $C0, $7E, $E8, $E8, $E8, $E8, $E0
DATA_PART_3::
	db $47, $08, $00, $0B, $C4, $D0, $16, $A5, $CB, $C9, $05, $D0, $10, $A2, $28
DATA_PART_4::
	db $3C, $08, $00, $0B, $F0, $12, $A5, $C9, $C9, $C8, $D0, $1C, $A5, $CA, $C9
DATA_PART_5::
	db $31, $08, $00, $0B, $0C, $A5, $CA, $C9, $7E, $D0, $06, $A5, $CB, $C9, $7E
DATA_PART_6::
	db $26, $08, $00, $0B, $39, $CD, $48, $0C, $D0, $34, $A5, $C9, $C9, $80, $D0
DATA_PART_7::
	db $1B, $08, $00, $0B, $EA, $EA, $EA, $EA, $EA, $A9, $01, $CD, $4F, $0C, $D0
DATA_PART_8::
	db $10, $08, $00, $0B, $4C, $20, $08, $EA, $EA, $EA, $EA, $EA, $60, $EA, $EA

SECTION "SGBBorder", ROMX[$4000], BANK[2]
SGBBorderTileMap::
	incbin "assets/border.sgbmap"

SECTION "SGBBorderPals", ROMX[$4800], BANK[2]
SGBBorderPalettes::
	incbin "assets/border.sgbpal"

SGBBorderTileCharacters::
	incbin "assets/border.sgbchr"
