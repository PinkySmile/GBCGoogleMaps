import sys

fd = open(sys.argv[1], "rb")
fd.read(256)
print("byte rom[] = {")
print(",\n".join([hex(c) for c in fd.read(256)]))
print("};")
