#! /usr/bin/env python

import sys

input_file = sys.argv[1]

print("Depth\tTumor_Purity\tTP\tFP\tFN\tSupport_Read")
with open(input_file, 'r') as hin:
    for line in hin:
        if not line.startswith("DP"): continue
        F = line.rstrip('\n').split('\t')
        DP, TP = F[0].split('_')
        DP = DP.replace("DP", '')
        TP = TP.replace("TP", '')

        print("%s\t%s\t%s\t%s\t%s\t%s" % (DP, TP, F[1], F[2], F[3], F[4]))

