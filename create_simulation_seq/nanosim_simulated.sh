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
#$ -l s_vmem=12G
#$ -pe def_slot 32

set -eux

MODE=$1
declare -A fastas=(
  [somatic]=$PWD/output/survivor/simulated_somatic_chr1-22XY_pm/simulated.fasta
  [germline1]=$PWD/output/survivor/simulated_germline_chr1-22XY_pm/simulated.fasta
  [germline2]=$PWD/output/survivor/simulated_germline_chr1-22XY_pm/simulated.fasta
)
FASTA=${fastas[${MODE}]}

# create fastq
mkdir -p $PWD/output/nanosim/

singularity run $PWD/image/simulationsv-set_0.1.0.sif \
  python /usr/local/NanoSim-2.6.0/src/simulator.py genome \
    -rg $FASTA \
    -c $PWD/nanosim_training/training_COLO829BL_chr22 \
    -o $PWD/output/nanosim/simulated_${MODE}_chr1-22XY \
    --fastq --basecaller guppy --strandness 0.5 --number 20000000 --num_threads 32

singularity run $PWD/image/simulationsv-set_0.1.0.sif \
  pigz -c $PWD/output/nanosim/simulated_${MODE}_chr1-22XY_aligned_error_profile > $PWD/output/nanosim/simulated_${MODE}_chr1-22XY_aligned_error_profile.gz
rm $PWD/output/nanosim/simulated_${MODE}_chr1-22XY_aligned_error_profile

singularity run $PWD/image/simulationsv-set_0.1.0.sif \
  pigz -c $PWD/output/nanosim/simulated_${MODE}_chr1-22XY_aligned_reads.fastq > $PWD/output/nanosim/simulated_${MODE}_chr1-22XY_aligned_reads.fastq.gz
rm $PWD/output/nanosim/simulated_${MODE}_chr1-22XY_aligned_reads.fastq
