; MBC
ROMBankSelect  = $2000

;VRAM
VRAMStart      = $8000
VRAMBgStart    = $9800
VRAMWinStart   = $9C00

joypad         = $FF00
;Serial transfer
serialTrnData  = $FF01
serialTrnCtrl  = $FF02

;Timer
divReg         = $FF04
timerCounter   = $FF05
timerModulo    = $FF06
timerCtrl      = $FF07

;Interrupt flag
interruptFlag  = $FF0F

;ALU
NR10           = $FF10
NR11           = $FF11
NR12           = $FF12
NR13           = $FF13
NR14           = $FF14
NR21           = $FF16
NR22           = $FF17
NR23           = $FF18
NR24           = $FF19
NR30           = $FF1A
NR31           = $FF1B
NR32           = $FF1C
NR33           = $FF1D
NR34           = $FF1E
NR41           = $FF20
NR42           = $FF21
NR43           = $FF22
NR44           = $FF23
NR50           = $FF24
NR51           = $FF25
NR52           = $FF26
WPRAMStart     = $FF30
WPRAMSize      = $10

chan1Sweep     = NR10
chan1Len       = NR11
chan1Volume    = NR12
chan1FrequL    = NR13
chan1FrequH    = NR14
chan2Len       = NR21
chan2Volume    = NR22
chan2FrequL    = NR23
chan2FrequH    = NR24
chan3Enable    = NR30
chan3Len       = NR31
chan3Volume    = NR32
chan3FrequL    = NR33
chan3FrequH    = NR34
chan4Len       = NR41
chan4Volume    = NR42
chan4PolyCnt   = NR43
chan4Ctrl      = NR44
channelCtrl    = NR50
terminalSelect = NR51
soundEnable    = NR52


;LCD/GPU
lcdCtrl        = $FF40
lcdStats       = $FF41
bgScrollY      = $FF42
bgScrollX      = $FF43
lcdLine        = $FF44
lcdLineCmp     = $FF45
dmaTrnCtrl     = $FF46
dmgBgPalData   = $FF47
dmgObj0PalData = $FF48
dmgObj1PalData = $FF49
winPosY        = $FF4A
winPosXMinus7  = $FF4B

;Speed switch (CGB only)
speedSwitch    = $FF4D

;VRAM Bank select (CGB only)
VRAMBankSelect = $FF4F

;New DMA (CGB only)
newDmaSrcH     = $FF51
newDmaSrcL     = $FF52
newDmaDestH    = $FF53
newDmaDestL    = $FF54
newDmaCtrl     = $FF55

;Infrared com (CGB only)
infraredComPort= $FF56

;Palettes (CGB only)
cgbBgPalIndex  = $FF68
cgbBgPalData   = $FF69
cgbObjPalIndex = $FF6A
cgbObjPalData  = $FF6B

;RAM bank (CGB only)
WRAMBankSelect = $FF70

;Interrupt enable
interruptEnable= $FFFF