#! /usr/bin/env python3

import sys, glob

def write_rec(infile, hout, method):

    with open(infile, 'r') as hin:
        for line in hin:
            if not line.startswith("DP"): continue
            F = line.rstrip('\n').split('\t')
            DP, TP = F[0].split('_')
            DP = DP.replace("DP", '')
            TP = TP.replace("TP", '')

            print('\t'.join([method, DP, TP, F[1], F[2], F[3]]), file = hout)


with open("../output/plot/simulation_count.txt", 'w') as hout:
    print('\t'.join(["Method", "Depth", "Tumor_Purity", "TP", "FP", "FN"]), file = hout)
    write_rec("../output/vs_golden_data/nanomonsv/simulation_count.txt", hout, "nanomonsv")
    write_rec("../output/vs_golden_data/sniffles2/simulation_count.txt", hout, "sniffles2")
    write_rec("../output/vs_golden_data/delly/simulation_count.txt", hout, "delly")
hout.close()

