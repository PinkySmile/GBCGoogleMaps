NAME = google_maps

ASM = rgbasm

LD = rgblink

FIX = rgbfix

FIXFLAGS = -Cjv -k 01 -l 0x33 -m 0x1f -p 0 -r 00 -t "$(NAME)"

ASMFLAGS =

LDFLAGS = -n $(NAME).sym -l $(NAME).link

SRCS =	main.asm \
	mem_layout.asm

OBJS = $(SRCS:%.asm=src/%.o)

all:	$(NAME).gbc

run:	all
	wine "$(BGB_PATH)" ./$(NAME).gbc

%.o : %.asm
	$(ASM) $(ASMFLAGS) -o $@ $<

$(NAME).gbc:	$(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS)
	$(FIX) $(FIXFLAGS) $@

clean:
	$(RM) $(OBJS)

fclean:	clean
	$(RM) $(NAME).gbc

re:	fclean all
