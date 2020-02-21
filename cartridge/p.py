import sys

fd = open(sys.argv[1], "rb")
print("byte rom[] = {")
print(",\n".join([hex(c) for c in fd.read(1024)]))
print("};")
