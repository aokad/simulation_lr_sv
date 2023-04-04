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
#$ -l s_vmem=16G

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

singularity exec $PWD/image/svim_2.0.0.sif \
  svim alignment \
    --skip_genotyping \
    $PWD/output/svim/${NAME}/ \
    $PWD/output/subsample/minimap2_germline2/simulated_chr1-22XY.${NAME}.merge.subsample.bam \
    $PWD/reference/GRCh38.d1.vd1.fa

