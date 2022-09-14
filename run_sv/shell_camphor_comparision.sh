#!/bin/bash
set -eux

NAME=$1
CONTROL=$2

mkdir -p $PWD/output/CAMPHORsomatic/minimap2/simulated_chr1-22XY.${NAME}_comparison
ORGPWD=$PWD

cd /tools/CAMPHORsomatic
sh ./CAMPHOR_comparison.sh \
    $ORGPWD/output/CAMPHORsomatic/minimap2/simulated_chr1-22XY.${NAME} \
    $ORGPWD/output/CAMPHORsomatic/minimap2_germline2/simulated_chr1-22XY.${CONTROL} \
    $ORGPWD/output/subsample/minimap2/simulated_chr1-22XY.${NAME}.merge.subsample.bam \
    $ORGPWD/output/subsample/minimap2_germline2/simulated_chr1-22XY.${CONTROL}.merge.subsample.bam \
    $ORGPWD/output/CAMPHORsomatic/fastq/simulated_somatic_germline1_chr1-22XY_aligned_reads.fastq \
    $ORGPWD/output/CAMPHORsomatic/minimap2/simulated_chr1-22XY.${NAME}_comparison
