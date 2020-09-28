import sys

m = sys.argv[1] + ".sgbmap"
p = sys.argv[1] + ".sgbpal"
c = sys.argv[1] + ".sgbchr"

with open(m, "rb") as fd:
    attrMap = fd.read()
    print("\n".join(" ".join(hex(b) + ("" if b >= 16 else " ") for b in attrMap[y * 64:(y + 1)*64:2]) for y in range(28)))
    print("Attrs:")
    print("\n".join(" ".join(hex(b) + ("" if b >= 16 else " ") for b in attrMap[1+y * 64:1+(y + 1)*64:2]) for y in range(28)))

with open(p, "rb") as fd:
    palettes = fd.read()
    print("\n".join("Palette: {}\n".format(j + 4) + ", ".join(("{:X}r {:X}g {:X}b".format((pal[i] & 0b11111), (pal[i] >> 5 | pal[i + 1] & 0b11), (pal[i + 1] >> 2 & 0b11111)) for i in range(0, len(pal), 2))) for j, pal in enumerate([palettes[x:x+32] for x in range(0, len(palettes), 32)])))
