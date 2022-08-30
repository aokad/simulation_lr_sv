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
#$ -l s_vmem=24G

set -eux -o pipefail

BAM_FILE=$1
OUTPUT_FILE=$2

OUTPUT_NAME=$(basename ${OUTPUT_FILE})
OUTPUT_DIR=$(dirname ${OUTPUT_FILE})
mkdir -p ${OUTPUT_DIR}

singularity exec $PWD/image/nanostat_1.4.0-s.sif \
  NanoStat \
    --bam ${BAM_FILE} \
    --outdir ${OUTPUT_DIR} \
    --name ${OUTPUT_NAME}
