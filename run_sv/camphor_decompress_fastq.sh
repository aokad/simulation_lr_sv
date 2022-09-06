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
#$ -l s_vmem=8G

set -eux

OUTPUT_DIR=$PWD/output/CAMPHORsomatic/fastq
mkdir -p ${OUTPUT_DIR}

zcat $PWD/output/nanosim/simulated_somatic_chr1-22XY_aligned_reads.fastq.gz > ${OUTPUT_DIR}/simulated_somatic_germline1_chr1-22XY_aligned_reads.fastq
zcat $PWD/output/nanosim/simulated_germline1_chr1-22XY_aligned_reads.fastq.gz >> ${OUTPUT_DIR}/simulated_somatic_germline1_chr1-22XY_aligned_reads.fastq
