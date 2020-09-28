INC =

LDFLAGS =

CFLAGS= $(INC)	\
		-W		\
		-Wall	\
		-Wextra	\

CC =	gcc

LIBS =

all:	$(LIBS) compressor sgb_border

sgb_border:sgb_border.o
	$(CC) -o sgb_border sgb_border.o $(LDFLAGS) -lpng

compressor:compressor.o
	$(CC) -o compressor compressor.o $(LDFLAGS)

clean:
	$(RM) sgb_border.o compressor.o

fclean:	clean
	$(RM) compressor compressor.exe sgb_border sgb_border.exe

ffclean:fclean

re:	fclean all

dbg:	CFLAGS += -g -O0
dbg:	ffclean all
