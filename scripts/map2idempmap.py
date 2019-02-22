#################################################
#################################################
# convert Lilians mapping file for barcodes
# into one that is compatible for Sabre
# demultiplexing
#################################################
#################################################

import sys

inf = open(sys.argv[1])

inf.readline()
for line in inf.readlines():
    data  = line[:-1].split("\t")
    barcode, sample = data[1], data[0]
    if barcode == "":
        continue
    sys.stdout.write("\t".join([barcode, sample]) + "\n")
