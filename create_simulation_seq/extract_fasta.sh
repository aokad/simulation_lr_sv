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

set -eux

singularity exec $PWD/image/simulationsv-set_0.1.0.sif \
sh -c "samtools view -hb $PWD/bam/COLO829BL/COLO829BL.bam chr22 > $PWD/bam/COLO829BL/COLO829BL_chr22.bam && \
 samtools index $PWD/bam/COLO829BL/COLO829BL_chr22.bam && \
 samtools bam2fq $PWD/bam/COLO829BL/COLO829BL_chr22.bam > $PWD/bam/COLO829BL/COLO829BL_chr22.fastq && \
 python $PWD/simulation_sv_set/script/extract_chr22.py $PWD/reference/GRCh38.d1.vd1.fa > $PWD/reference/GRCh38.d1.vd1.chr22.fa && \
 python $PWD/simulation_sv_set/script/extract_chr1-22XY.py $PWD/reference/GRCh38.d1.vd1.fa > $PWD/reference/GRCh38.d1.vd1.chr1-22XY.fa"

