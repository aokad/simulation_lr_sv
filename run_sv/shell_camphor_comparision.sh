#!/bin/bash
set -eux

NAME=$1
CONTROL=$2

mkdir -p $PWD/output/CAMPHORsomatic/minimap2/simulated_chr1-22XY.${NAME}_comparison

cd /tools/CAMPHORsomatic
sh ./CAMPHOR_comparison.sh \
    $PWD/output/CAMPHORsomatic/minimap2/simulated_chr1-22XY.${NAME} \
    $PWD/output/CAMPHORsomatic/minimap2_germline2/simulated_chr1-22XY.${CONTROL} \
    $PWD/output/subsample/minimap2/simulated_chr1-22XY.${NAME}.merge.subsample.bam \
    $PWD/output/subsample/minimap2_germline2/simulated_chr1-22XY.${CONTROL}.merge.subsample.bam \
    $PWD/output/CAMPHORsomatic/fastq/simulated_somatic_germline1_chr1-22XY_aligned_reads.fastq \
    $PWD/output/CAMPHORsomatic/minimap2/simulated_chr1-22XY.${NAME}_comparison
