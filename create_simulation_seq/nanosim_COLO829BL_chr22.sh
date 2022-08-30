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
#$ -l s_vmem=5G
#$ -pe def_slot 8

set -eux

mkdir -p $PWD/nanosim_training/training_COLO829BL_chr22

# トレーニングデータの作成
singularity run $PWD/image/simulationsv-set_0.1.0.sif \
  python /usr/local/NanoSim-2.6.0/src/read_analysis.py genome \
    -i  $PWD/bam/COLO829BL/COLO829BL_chr22.fastq \
    -rg $PWD/reference/GRCh38.d1.vd1.chr22.fa \
    -o $PWD/nanosim_training/training_COLO829BL_chr22 \
    -t 8
