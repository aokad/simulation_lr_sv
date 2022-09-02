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

mkdir -p $PWD/output/delly/${NAME}

singularity exec $PWD/image/delly_v1.0.3.sif \
  delly lr \
    -y ont -o $PWD/output/delly/${NAME}/${NAME}.bcf \
    -g $PWD/reference/GRCh38.d1.vd1.fa \
    $PWD/output/subsample/minimap2_germline2/simulated_chr1-22XY.${NAME}.merge.subsample.bam
