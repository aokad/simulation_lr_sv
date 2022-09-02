#!/bin/bash
set -eux

SCRIPT_DIR=$(dirname $0)

qsub -N download_COLO829BL ${SCRIPT_DIR}/download_COLO829BL.sh
qsub -N minimap2_COLO829BL -hold_jid download_COLO829BL ${SCRIPT_DIR}/minimap2_COLO829BL.sh

qsub -N extract_fasta -hold_jid minimap2_COLO829BL ${SCRIPT_DIR}/extract_fasta.sh
qsub -N nanosim_COLO829BL_chr22 -hold_jid extract_fasta ${SCRIPT_DIR}/nanosim_COLO829BL_chr22.sh

qsub -N SURVIVOR -hold_jid nanosim_COLO829BL_chr22 ${SCRIPT_DIR}/SURVIVOR.sh

qsub -N nanosim_simulated_somatic   -hold_jid SURVIVOR ${SCRIPT_DIR}/nanosim_simulated.sh somatic
qsub -N nanosim_simulated_germline1 -hold_jid SURVIVOR ${SCRIPT_DIR}/nanosim_simulated.sh germline1
qsub -N nanosim_simulated_germline2 -hold_jid SURVIVOR ${SCRIPT_DIR}/nanosim_simulated.sh germline2

qsub -N minimap2_simulated_somatic   -hold_jid nanosim_simulated_somatic ${SCRIPT_DIR}/minimap2_simulated_somatic.sh
qsub -N minimap2_simulated_germline1 -hold_jid nanosim_simulated_germline1 ${SCRIPT_DIR}/minimap2_simulated_germline1.sh
qsub -N minimap2_simulated_germline2 -hold_jid nanosim_simulated_germline2 ${SCRIPT_DIR}/minimap2_simulated_germline2.sh

# nanostat
OUTPUT_DIR=$PWD/output
BAM_SOMATIC=${OUTPUT_DIR}/minimap2/simulated_somatic_chr1-22XY_aligned.bam
BAM_GERMLINE1=${OUTPUT_DIR}/minimap2/simulated_germline1_chr1-22XY_aligned.bam
BAM_GERMLINE2=${OUTPUT_DIR}/minimap2/simulated_germline2_chr1-22XY_aligned.bam 
NANOSTAT_SOMATIC=${OUTPUT_DIR}/nanostat/simulated_somatic_chr1-22XY_aligned.txt
NANOSTAT_GERMLINE1=${OUTPUT_DIR}/nanostat/simulated_germline1_chr1-22XY_aligned.txt
NANOSTAT_GERMLINE2=${OUTPUT_DIR}/nanostat/simulated_germline2_chr1-22XY_aligned.txt

qsub -N nanostat_somatic -hold_jid minimap2_simulated_somatic ${SCRIPT_DIR}/nanostat.sh ${BAM_SOMATIC} ${NANOSTAT_SOMATIC}
qsub -N nanostat_germline1 -hold_jid minimap2_simulated_germline1 ${SCRIPT_DIR}/nanostat.sh ${BAM_GERMLINE1} ${NANOSTAT_GERMLINE1}
qsub -N nanostat_germline2 -hold_jid minimap2_simulated_germline2 ${SCRIPT_DIR}/nanostat.sh ${BAM_GERMLINE2} ${NANOSTAT_GERMLINE2}

# subsample
qsub -N subsample -hold_jid nanostat_somatic,nanostat_germline1 -t 1-30 ${SCRIPT_DIR}/subsample.sh
qsub -N subsample_germline2 -hold_jid nanostat_germline2 -t 1-5 ${SCRIPT_DIR}/subsample_germline2.sh
