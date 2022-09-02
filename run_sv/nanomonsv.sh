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
#$ -l intel

set -eux

params=(
  "DUMMY"
  "DP10_TP0_TDP0 DP10"
  "DP10_TP20_TDP2 DP10"
  "DP10_TP40_TDP4 DP10"
  "DP10_TP60_TDP6 DP10"
  "DP10_TP80_TDP8 DP10"
  "DP10_TP100_TDP10 DP10"
  "DP20_TP0_TDP0 DP20"
  "DP20_TP20_TDP4 DP20"
  "DP20_TP40_TDP8 DP20"
  "DP20_TP60_TDP12 DP20"
  "DP20_TP80_TDP16 DP20"
  "DP20_TP100_TDP20 DP20"
  "DP30_TP0_TDP0 DP30"
  "DP30_TP20_TDP6 DP30"
  "DP30_TP40_TDP12 DP30"
  "DP30_TP60_TDP18 DP30"
  "DP30_TP80_TDP24 DP30"
  "DP30_TP100_TDP30 DP30"
  "DP40_TP0_TDP0 DP40"
  "DP40_TP20_TDP8 DP40"
  "DP40_TP40_TDP16 DP40"
  "DP40_TP60_TDP24 DP40"
  "DP40_TP80_TDP32 DP40"
  "DP40_TP100_TDP40 DP40"
  "DP50_TP0_TDP0 DP50"
  "DP50_TP20_TDP10 DP50"
  "DP50_TP40_TDP20 DP50"
  "DP50_TP60_TDP30 DP50"
  "DP50_TP80_TDP40 DP50"
  "DP50_TP100_TDP50 DP50"
)

tmp=(${params[$SGE_TASK_ID]})
NAME=${tmp[0]}
CONTROL=${tmp[1]}

singularity exec $PWD/image/nanomonsv_v0.5.0.sif \
  nanomonsv parse \
    $PWD/output/subsample/minimap2/simulated_chr1-22XY.${NAME}.merge.subsample.bam \
    $PWD/output/nanomonsv/${NAME}/${NAME}

CONTROL_PANEL_PREFIX=$PWD/control_panel/hprc_year1_data_freeze_nanopore_minimap2_2_24_merge_control/hprc_year1_data_freeze_nanopore_minimap2_2_24_merge_control

singularity exec $PWD/image/nanomonsv_v0.5.0.sif \
  nanomonsv get \
    $PWD/output/nanomonsv/${NAME}/${NAME} \
    $PWD/output/subsample/minimap2/simulated_chr1-22XY.${NAME}.merge.subsample.bam \
    $PWD/reference/GRCh38.d1.vd1.fa \
    --control_prefix $PWD/output/nanomonsv/${CONTROL}/${CONTROL} \
    --control_bam $PWD/output/subsample/minimap2_germline2/simulated_chr1-22XY.${CONTROL}.merge.subsample.bam \
    --processes 8 \
    --single_bnd \
    --use_racon \
    --control_panel_prefix ${CONTROL_PANEL_PREFIX}
