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

set -eux -o pipefail

mkdir -p $PWD/output/minimap2/

singularity run $PWD/image/minimap2_2.17.sif \
  sh -c "minimap2 -ax map-ont -t 8 -p 0.1 \
    $PWD/reference/GRCh38.d1.vd1.mmi \
    $PWD/output/nanosim/simulated_germline1_chr1-22XY_aligned_reads.fastq.gz \
  | samtools view -Shb > $PWD/output/minimap2/simulated_germline1_chr1-22XY_aligned.unsorted"

singularity run $PWD/image/simulationsv-set_0.1.0.sif \
  samtools sort -@ 8 -m 2G $PWD/output/minimap2/simulated_germline1_chr1-22XY_aligned.unsorted -o $PWD/output/minimap2/simulated_germline1_chr1-22XY_aligned.bam

singularity run $PWD/image/simulationsv-set_0.1.0.sif \
  samtools index $PWD/output/minimap2/simulated_germline1_chr1-22XY_aligned.bam

rm -rf $PWD/output/minimap2/simulated_germline1_chr1-22XY_aligned.unsorted
