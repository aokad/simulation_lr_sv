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
#$ -l s_vmem=6G
#$ -pe def_slot 8

set -eux -o pipefail

mkdir -p $PWD/fastq/COLO829BL
singularity exec $PWD/image/sra-tools_3.0.0.sif fasterq-dump -e 8 -O $PWD/fastq/COLO829BL DRR258590
