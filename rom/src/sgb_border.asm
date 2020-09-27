SECTION "SGBBorder", ROMX[$4000], BANK[2]
SGBBorderTileMap:
	incbin "assets/result.sgbmap"

SECTION "SGBBorderPals", ROMX[$4800], BANK[2]
SGBBorderPalettes:
	incbin "assets/result.sgbpal"

SGBBorderTileCharacters:
	incbin "assets/result.sgbchr"
