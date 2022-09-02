#!/bin/bash
#
# Set SGE
#
#$ -S /bin/bash         # set shell in UGE
#$ -cwd                 # execute at the submitted dir
#$ -l d_rt=2880:00:00   # 4 month
#$ -l s_rt=2880:00:00
#$ -e ./log/
#$ -o ./log/
#$ -j y
#$ -l s_vmem=4G
#$ -pe def_slot 8

set -eux

params=(
  "DUMMY"
  "DP10_TP0_TDP0 DP10"
  "DP10_TP20_TDP2 DP10"
  "DP10_TP40_TDP4 DP10"
  "DP10_TP60_TDP6 DP10"
  "DP10_TP80_TDP8 DP10"
  "DP10_TP100_TDP10 DP10"
  "DP20_TP0_TDP0 DP20"
  "DP20_TP20_TDP4 DP20"
  "DP20_TP40_TDP8 DP20"
  "DP20_TP60_TDP12 DP20"
  "DP20_TP80_TDP16 DP20"
  "DP20_TP100_TDP20 DP20"
  "DP30_TP0_TDP0 DP30"
  "DP30_TP20_TDP6 DP30"
  "DP30_TP40_TDP12 DP30"
  "DP30_TP60_TDP18 DP30"
  "DP30_TP80_TDP24 DP30"
  "DP30_TP100_TDP30 DP30"
  "DP40_TP0_TDP0 DP40"
  "DP40_TP20_TDP8 DP40"
  "DP40_TP40_TDP16 DP40"
  "DP40_TP60_TDP24 DP40"
  "DP40_TP80_TDP32 DP40"
  "DP40_TP100_TDP40 DP40"
  "DP50_TP0_TDP0 DP50"
  "DP50_TP20_TDP10 DP50"
  "DP50_TP40_TDP20 DP50"
  "DP50_TP60_TDP30 DP50"
  "DP50_TP80_TDP40 DP50"
  "DP50_TP100_TDP50 DP50"
)

tmp=(${params[$SGE_TASK_ID]})
NAME=${tmp[0]}
CONTROL=${tmp[1]}

WDIR=/home/aiokada/sandbox/simulation_sv

mkdir -p $WDIR/output/delly/${NAME}

singularity exec $WDIR/image/delly_v1.0.3.sif \
  delly lr \
    -y ont -o $WDIR/output/delly/${NAME}/${NAME}.bcf \
    -g /home/aiokada/resources/database/GRCh38.d1.vd1/GRCh38.d1.vd1.fa \
    $WDIR/output/subsample/minimap2/simulated_chr1-22XY.${NAME}.merge.subsample.bam
