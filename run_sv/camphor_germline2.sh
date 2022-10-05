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
#$ -l s_vmem=3G
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

OUTPUT_DIR=$PWD/output/CAMPHORsomatic/minimap2_germline2/simulated_chr1-22XY.${NAME}
mkdir -p ${OUTPUT_DIR}

singularity exec $PWD/image/camphor_somatic_20221005.sif \
    samtools sort -n -@ 8 \
    $PWD/output/subsample/minimap2_germline2/simulated_chr1-22XY.${NAME}.merge.subsample.bam \
    -O bam -o ${OUTPUT_DIR}/simulated_chr1-22XY.${NAME}.markdup.sort_by_name.bam

singularity exec $PWD/image/camphor_somatic_20221005.sif \
    bash $PWD/run_sv/shell_camphor_svcall.sh \
    ${OUTPUT_DIR}/simulated_chr1-22XY.${NAME}.markdup.sort_by_name.bam \
    $PWD/output/subsample/minimap2_germline2/simulated_chr1-22XY.${NAME}.merge.subsample.bam \
    ${OUTPUT_DIR}

rm ${OUTPUT_DIR}/simulated_chr1-22XY.${NAME}.markdup.sort_by_name.bam
