NAME = google_maps

ASM = rgbasm

LD = rgblink

FIX = rgbfix

FIXFLAGS = -Cjsv -k 01 -l 0x33 -m 0x1f -p 0 -r 00 -t "$(NAME)"

ASMFLAGS =

LDFLAGS = -n $(NAME).sym -l $(NAME).link

FXFLAGS =

FX = rgbgfx

SRCS =	src/main.asm \
	src/mem_layout.asm

IMGS = 	assets/font.png

IMGSFX = $(IMGS:%.png=%.fx)

OBJS = $(SRCS:%.asm=%.o)

all:	$(NAME).gbc

run:	re
	wine "$(BGB_PATH)" ./$(NAME).gbc

%.fx : %.png
	$(FX) $(FXFLAGS) -o $@ $<

%.o : %.asm
	$(ASM) -o $@ $(ASMFLAGS) $<

$(NAME).gbc:	$(IMGSFX) $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS)
	$(FIX) $(FIXFLAGS) $@

clean:
	$(RM) $(OBJS) $(IMGSFX)

fclean:	clean
	$(RM) $(NAME).gbc

re:	fclean all
