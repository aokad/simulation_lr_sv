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
#$ -l s_vmem=20G
#$ -l intel

set -eux

params=(
  "DUMMY"
  "DP10"
  "DP20"
  "DP30"
  "DP40"
  "DP50"
)

NAME=${params[$SGE_TASK_ID]}

WDIR=/home/aiokada/sandbox/simulation_sv
singularity exec $WDIR/image/nanomonsv_v0.5.0.sif \
  nanomonsv parse \
    $WDIR/output/subsample/minimap2_germline2/simulated_chr1-22XY.${NAME}.merge.subsample.bam \
    $WDIR/output/nanomonsv/${NAME}/${NAME}
