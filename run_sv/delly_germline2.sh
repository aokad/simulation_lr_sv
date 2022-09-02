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
  "DP10"
  "DP20"
  "DP30"
  "DP40"
  "DP50"
)

NAME=${params[$SGE_TASK_ID]}

WDIR=/home/aiokada/sandbox/simulation_sv

mkdir -p $WDIR/output/delly/${NAME}

singularity exec $WDIR/image/delly_v1.0.3.sif \
  delly lr \
    -y ont -o $WDIR/output/delly/${NAME}/${NAME}.bcf \
    -g /home/aiokada/resources/database/GRCh38.d1.vd1/GRCh38.d1.vd1.fa \
    $WDIR/output/subsample/minimap2_germline2/simulated_chr1-22XY.${NAME}.merge.subsample.bam
