NAME = google_maps

ASM = rgbasm

LD = rgblink

FIX = rgbfix

FIXFLAGS = -jsvC -k 01 -l 0x33 -m 0xa0 -p 0 -t "`echo "$(NAME)" | tr a-z A-Z | tr "_" " "`"

ASMFLAGS =

LDFLAGS = -n $(NAME).sym -l $(NAME).link

FXFLAGS =

FX = rgbgfx

SRCS =	src/main.asm \
	src/mem_layout.asm \
	src/assets.asm \
	src/text.asm \
	src/wram.asm

IMGS = 	assets/font.png

IMGSFX = $(IMGS:%.png=%.fx)

COLORED_IMGS = 	assets/google_logo_left.png \
	assets/google_logo_right.png

SGB_BORDER = assets/border.png

SGB_BORDER_FX = $(SGB_BORDER:%.png=%.sgbchr)

COLORED_IMGSFX = $(COLORED_IMGS:%.png=%.cfx)

OBJS = $(SRCS:%.asm=%.o)

all:	tools/compressor tools/sgb_border $(NAME).gbc

tools/compressor:
	$(MAKE) -C tools compressor

tools/sgb_border:
	$(MAKE) -C tools sgb_border

run:	re
	wine "$(BGB_PATH)" ./$(NAME).gbc

runw:	re
	"$(BGB_PATH)" ./$(NAME).gbc

%.cfx : %.png
	$(FX) $(FXFLAGS) -P -o $@ $<

%.fx : %.png
	$(FX) $(FXFLAGS) -o $@ $<
	tools/compressor $@

%.sgbchr : %.png
	tools/sgb_border $< $@ `echo $@ | rev | sed 's/rhcbgs/lapbgs/' | rev` `echo $@ | rev | sed 's/rhcbgs/pambgs/' | rev`

%.o : %.asm
	$(ASM) -o $@ $(ASMFLAGS) $<

$(NAME).gbc:	$(SGB_BORDER_FX) $(COLORED_IMGSFX) $(IMGSFX) $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS)
	$(FIX) $(FIXFLAGS) $@

clean:
	$(MAKE) -C tools clean
	$(RM) $(OBJS) $(IMGSFX)

fclean:	clean
	$(MAKE) -C tools fclean
	$(RM) $(NAME).gbc

re:	fclean all
