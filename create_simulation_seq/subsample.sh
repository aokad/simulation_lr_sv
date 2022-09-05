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
#$ -pe def_slot 4

# submit this
# qsub -t 1-30 subsample.sh

set -eux -o pipefail

SOMATIC_BAM=$PWD/output/minimap2/simulated_somatic_chr1-22XY_aligned.bam
GERMLINE_BAM=$PWD/output/minimap2/simulated_germline1_chr1-22XY_aligned.bam
OUTPUT_PREFIX=$PWD/output/subsample/minimap2/simulated_chr1-22XY
SCRIPT_DIR=$PWD/create_simulation_seq

OUTPUT_NAME=$(basename ${OUTPUT_PREFIX})
OUTPUT_DIR=$(dirname ${OUTPUT_PREFIX})
mkdir -p ${OUTPUT_DIR}

SOMATIC_NANOSTAT=$PWD/output/nanostat/simulated_somatic_chr1-22XY_aligned.txt
GERMLINE_NANOSTAT=$PWD/output/nanostat/simulated_germline1_chr1-22XY_aligned.txt
OUTPUT_PARAM=${OUTPUT_PREFIX}.params_minimap2.${SGE_TASK_ID}

python ${SCRIPT_DIR}/create_params.py ${SOMATIC_NANOSTAT},${GERMLINE_NANOSTAT} ${OUTPUT_PARAM} 30000000000
source ${OUTPUT_PARAM}

tmp=(${params[$SGE_TASK_ID]})
NAME=${tmp[0]}
SAMPLING_SOMATIC=${tmp[1]}
SAMPLING_GERMLINE=${tmp[2]}

# somatic
if [ "${SAMPLING_SOMATIC}" != "0" ]
then
    singularity exec $PWD/image/simulationsv-set_0.1.0.sif \
      samtools view -bs ${SAMPLING_SOMATIC} -@ 4 ${SOMATIC_BAM} > ${OUTPUT_PREFIX}.${NAME}.somatic.subsample.bam

    singularity exec $PWD/image/simulationsv-set_0.1.0.sif \
      samtools index ${OUTPUT_PREFIX}.${NAME}.somatic.subsample.bam

    singularity exec $PWD/image/simulationsv-set_0.1.0.sif \
      samtools view -@ 4 -F 2304 -hb ${OUTPUT_PREFIX}.${NAME}.somatic.subsample.bam > ${OUTPUT_PREFIX}.${NAME}.somatic.subsample.filtered.bam

    singularity exec $PWD/image/simulationsv-set_0.1.0.sif \
      samtools index ${OUTPUT_PREFIX}.${NAME}.somatic.subsample.filtered.bam

    singularity exec $PWD/image/nanostat_1.4.0-s.sif \
      NanoStat \
        --bam ${OUTPUT_PREFIX}.${NAME}.somatic.subsample.filtered.bam \
        --outdir ${OUTPUT_DIR} \
        --name ${OUTPUT_NAME}.${NAME}.somatic.subsample.filtered_F2304.txt

    rm -f ${OUTPUT_PREFIX}.${NAME}.somatic.subsample.filtered.bam
    rm -f ${OUTPUT_PREFIX}.${NAME}.somatic.subsample.filtered.bam.bai
fi

# germline
if [ "${SAMPLING_GERMLINE}" != "0" ]
then
    singularity exec $PWD/image/simulationsv-set_0.1.0.sif \
      samtools view -bs ${SAMPLING_GERMLINE} -@ 4 ${GERMLINE_BAM} > ${OUTPUT_PREFIX}.${NAME}.germline.subsample.bam

    singularity exec $PWD/image/simulationsv-set_0.1.0.sif \
      samtools index ${OUTPUT_PREFIX}.${NAME}.germline.subsample.bam

    singularity exec $PWD/image/simulationsv-set_0.1.0.sif \
      samtools view -@ 4 -F 2304 -hb ${OUTPUT_PREFIX}.${NAME}.germline.subsample.bam > ${OUTPUT_PREFIX}.${NAME}.germline.subsample.filtered.bam

    singularity exec $PWD/image/simulationsv-set_0.1.0.sif \
      samtools index ${OUTPUT_PREFIX}.${NAME}.germline.subsample.filtered.bam

    singularity exec $PWD/image/nanostat_1.4.0-s.sif \
      NanoStat \
        --bam ${OUTPUT_PREFIX}.${NAME}.germline.subsample.filtered.bam \
        --outdir ${OUTPUT_DIR} \
        --name ${OUTPUT_NAME}.${NAME}.germline.subsample.filtered_F2304.txt

    rm -f ${OUTPUT_PREFIX}.${NAME}.germline.subsample.filtered.bam
    rm -f ${OUTPUT_PREFIX}.${NAME}.germline.subsample.filtered.bam.bai
fi

# merge
if [ -e ${OUTPUT_PREFIX}.${NAME}.somatic.subsample.bam ] && [ -e ${OUTPUT_PREFIX}.${NAME}.germline.subsample.bam ]
then
    singularity exec $PWD/image/simulationsv-set_0.1.0.sif \
      samtools merge -@ 4 -f \
        ${OUTPUT_PREFIX}.${NAME}.merge.subsample.bam \
        ${OUTPUT_PREFIX}.${NAME}.somatic.subsample.bam \
        ${OUTPUT_PREFIX}.${NAME}.germline.subsample.bam

    singularity exec $PWD/image/simulationsv-set_0.1.0.sif \
      samtools index ${OUTPUT_PREFIX}.${NAME}.merge.subsample.bam

    rm ${OUTPUT_PREFIX}.${NAME}.somatic.subsample.bam
    rm ${OUTPUT_PREFIX}.${NAME}.somatic.subsample.bam.bai
    rm ${OUTPUT_PREFIX}.${NAME}.germline.subsample.bam
    rm ${OUTPUT_PREFIX}.${NAME}.germline.subsample.bam.bai

elif [ -e ${OUTPUT_PREFIX}.${NAME}.somatic.subsample.bam ]
then
    mv ${OUTPUT_PREFIX}.${NAME}.somatic.subsample.bam ${OUTPUT_PREFIX}.${NAME}.merge.subsample.bam
    mv ${OUTPUT_PREFIX}.${NAME}.somatic.subsample.bam.bai ${OUTPUT_PREFIX}.${NAME}.merge.subsample.bam.bai

elif [ -e ${OUTPUT_PREFIX}.${NAME}.germline.subsample.bam ]
then
    mv ${OUTPUT_PREFIX}.${NAME}.germline.subsample.bam ${OUTPUT_PREFIX}.${NAME}.merge.subsample.bam
    mv ${OUTPUT_PREFIX}.${NAME}.germline.subsample.bam.bai ${OUTPUT_PREFIX}.${NAME}.merge.subsample.bam.bai
fi
