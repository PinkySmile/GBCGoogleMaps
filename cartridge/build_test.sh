#!/bin/sh
rgbasm -o main.o main.asm && rgbasm -o mem_layout.o mem_layout.asm && rgblink -n test_network.sym -l test_network.link -o test.gb main.o mem_layout.o && rgbfix -jsv -k 01 -l 0x33 -m 0x01 -p 0 -r 00 -t "test" test.gb && python3 p.py test.gb > DumpGbCommands/rom.ino
