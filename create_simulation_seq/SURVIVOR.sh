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

SCRIPT_DIR=$PWD/create_simulation_seq
OUTPUT_DIR=$PWD/output

# germline sv
mkdir -p ${OUTPUT_DIR}/survivor/simulated_germline_chr1-22XY_p
mkdir -p ${OUTPUT_DIR}/survivor/simulated_germline_chr1-22XY_m

singularity run $PWD/image/simulationsv-set_0.1.0.sif \
  /usr/local/SURVIVOR-1.0.6/Debug/SURVIVOR simSV \
  $PWD/reference/GRCh38.d1.vd1.chr1-22XY.fa \
  ${SCRIPT_DIR}/parameter_file_germline.txt 0 0 \
  ${OUTPUT_DIR}/survivor/simulated_germline_chr1-22XY_p/simulated

singularity run $PWD/image/simulationsv-set_0.1.0.sif \
  /usr/local/SURVIVOR-1.0.6/Debug/SURVIVOR simSV \
  $PWD/reference/GRCh38.d1.vd1.chr1-22XY.fa \
  ${SCRIPT_DIR}/parameter_file_germline.txt 0 0 \
  ${OUTPUT_DIR}/survivor/simulated_germline_chr1-22XY_m/simulated

# rename
python ./simulation_sv_set/script/chr_name_change.py \
  ${OUTPUT_DIR}/survivor/simulated_germline_chr1-22XY_p/simulated.fasta p > ${OUTPUT_DIR}/survivor/simulated_germline_chr1-22XY_p/simulated_newname.fasta

python ./simulation_sv_set/script/chr_name_change.py \
  ${OUTPUT_DIR}/survivor/simulated_germline_chr1-22XY_m/simulated.fasta m > ${OUTPUT_DIR}/survivor/simulated_germline_chr1-22XY_m/simulated_newname.fasta

## somatic sv
mkdir -p ${OUTPUT_DIR}/survivor/simulated_somatic_chr1-22XY_p
mkdir -p ${OUTPUT_DIR}/survivor/simulated_somatic_chr1-22XY_m

singularity run $PWD/image/simulationsv-set_0.1.0.sif \
  /usr/local/SURVIVOR-1.0.6/Debug/SURVIVOR simSV \
  ${OUTPUT_DIR}/survivor/simulated_germline_chr1-22XY_p/simulated_newname.fasta \
  ${SCRIPT_DIR}/parameter_file_somatic.txt 0 0 \
  ${OUTPUT_DIR}/survivor/simulated_somatic_chr1-22XY_p/simulated

singularity run $PWD/image/simulationsv-set_0.1.0.sif \
  /usr/local/SURVIVOR-1.0.6/Debug/SURVIVOR simSV \
  ${OUTPUT_DIR}/survivor/simulated_germline_chr1-22XY_m/simulated_newname.fasta \
  ${SCRIPT_DIR}/parameter_file_somatic.txt 0 0 \
  ${OUTPUT_DIR}/survivor/simulated_somatic_chr1-22XY_m/simulated

# merge
mkdir -p ${OUTPUT_DIR}/survivor/simulated_germline_chr1-22XY_pm
mkdir -p ${OUTPUT_DIR}/survivor/simulated_somatic_chr1-22XY_pm

cat ${OUTPUT_DIR}/survivor/simulated_germline_chr1-22XY_p/simulated_newname.fasta ${OUTPUT_DIR}/survivor/simulated_germline_chr1-22XY_m/simulated_newname.fasta > ${OUTPUT_DIR}/survivor/simulated_germline_chr1-22XY_pm/simulated.fasta

cat ${OUTPUT_DIR}/survivor/simulated_somatic_chr1-22XY_p/simulated.fasta ${OUTPUT_DIR}/survivor/simulated_somatic_chr1-22XY_m/simulated.fasta > ${OUTPUT_DIR}/survivor/simulated_somatic_chr1-22XY_pm/simulated.fasta

