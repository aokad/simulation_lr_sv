import sys
INPUT = sys.argv[1]
OUTPUT = sys.argv[2]
TARGET = int(sys.argv[3])
#TARGET = 30000000000

def get_bams_bps(nanostat_txt):
    bams_bps = None
    with open(nanostat_txt) as f:
        for row in f:
            if row.startswith("Total bases aligned:"):
                bams_bps = float(row.rstrip().split(" ")[-1].replace(",", ""))
                break
    return bams_bps

inputs = INPUT.split(",")
if len(inputs) == 1:
    text = """params=(
  "DUMMY"
  "DP10 0 %.9f"
  "DP20 0 %.9f"
  "DP30 0 %.9f"
  "DP40 0 %.9f"
  "DP50 0 %.9f"
)
"""
    bams_bps = get_bams_bps(inputs[0])
    base_rate = TARGET/bams_bps
    with open(OUTPUT, "w") as fw:
        fw.write(text % (base_rate, base_rate*2, base_rate*3, base_rate*4, base_rate*5))

else:
    text = """params=(
  "DUMMY"
  "DP10_TP0_TDP0 %d %.9f"
  "DP10_TP20_TDP2 %.9f %.9f"
  "DP10_TP40_TDP4 %.9f %.9f"
  "DP10_TP60_TDP6 %.9f %.9f"
  "DP10_TP80_TDP8 %.9f %.9f"
  "DP10_TP100_TDP10 %.9f %d"
  "DP20_TP0_TDP0 %d %.9f"
  "DP20_TP20_TDP4 %.9f %.9f"
  "DP20_TP40_TDP8 %.9f %.9f"
  "DP20_TP60_TDP12 %.9f %.9f"
  "DP20_TP80_TDP16 %.9f %.9f"
  "DP20_TP100_TDP20 %.9f %d"
  "DP30_TP0_TDP0 %d %.9f"
  "DP30_TP20_TDP6 %.9f %.9f"
  "DP30_TP40_TDP12 %.9f %.9f"
  "DP30_TP60_TDP18 %.9f %.9f"
  "DP30_TP80_TDP24 %.9f %.9f"
  "DP30_TP100_TDP30 %.9f %d"
  "DP40_TP0_TDP0 %d %.9f"
  "DP40_TP20_TDP8 %.9f %.9f"
  "DP40_TP40_TDP16 %.9f %.9f"
  "DP40_TP60_TDP24 %.9f %.9f"
  "DP40_TP80_TDP32 %.9f %.9f"
  "DP40_TP100_TDP40 %.9f %d"
  "DP50_TP0_TDP0 %d %.9f"
  "DP50_TP20_TDP10 %.9f %.9f"
  "DP50_TP40_TDP20 %.9f %.9f"
  "DP50_TP60_TDP30 %.9f %.9f"
  "DP50_TP80_TDP40 %.9f %.9f"
  "DP50_TP100_TDP50 %.9f %d"
)
"""

    base_rate_somatic = TARGET/5/get_bams_bps(inputs[0])
    base_rate_germline = TARGET/5/get_bams_bps(inputs[1])
    with open(OUTPUT, "w") as fw:
        fw.write(text % (
           base_rate_somatic*1*0, base_rate_germline*1*5,
           base_rate_somatic*1*1, base_rate_germline*1*4,
           base_rate_somatic*1*2, base_rate_germline*1*3,
           base_rate_somatic*1*3, base_rate_germline*1*2,
           base_rate_somatic*1*4, base_rate_germline*1*1,
           base_rate_somatic*1*5, base_rate_germline*1*0,
           base_rate_somatic*2*0, base_rate_germline*2*5,
           base_rate_somatic*2*1, base_rate_germline*2*4,
           base_rate_somatic*2*2, base_rate_germline*2*3,
           base_rate_somatic*2*3, base_rate_germline*2*2,
           base_rate_somatic*2*4, base_rate_germline*2*1,
           base_rate_somatic*2*5, base_rate_germline*2*0,
           base_rate_somatic*3*0, base_rate_germline*3*5,
           base_rate_somatic*3*1, base_rate_germline*3*4,
           base_rate_somatic*3*2, base_rate_germline*3*3,
           base_rate_somatic*3*3, base_rate_germline*3*2,
           base_rate_somatic*3*4, base_rate_germline*3*1,
           base_rate_somatic*3*5, base_rate_germline*3*0,
           base_rate_somatic*4*0, base_rate_germline*4*5,
           base_rate_somatic*4*1, base_rate_germline*4*4,
           base_rate_somatic*4*2, base_rate_germline*4*3,
           base_rate_somatic*4*3, base_rate_germline*4*2,
           base_rate_somatic*4*4, base_rate_germline*4*1,
           base_rate_somatic*4*5, base_rate_germline*4*0,
           base_rate_somatic*5*0, base_rate_germline*5*5,
           base_rate_somatic*5*1, base_rate_germline*5*4,
           base_rate_somatic*5*2, base_rate_germline*5*3,
           base_rate_somatic*5*3, base_rate_germline*5*2,
           base_rate_somatic*5*4, base_rate_germline*5*1,
           base_rate_somatic*5*5, base_rate_germline*5*0,
        ))
