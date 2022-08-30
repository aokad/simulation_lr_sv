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

mkdir -p $PWD/bam/COLO829BL/
singularity exec $PWD/image/minimap2_2.17.sif sh -c \
  "minimap2 -ax map-ont -t 8 -p 0.1 $PWD/reference/GRCh38.d1.vd1.mmi $PWD/fastq/COLO829BL/DRR258590.fastq \
  | samtools view -Shb > $PWD/bam/COLO829BL/COLO829BL.unsorted.bam && \
  samtools sort -@ 8 -m 2G $PWD/bam/COLO829BL/COLO829BL.unsorted.bam -o $PWD/bam/COLO829BL/COLO829BL.bam && \
  samtools index $PWD/bam/COLO829BL/COLO829BL.bam"

rm $PWD/bam/COLO829BL/COLO829BL.unsorted.bam
