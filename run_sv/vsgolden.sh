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
#$ -l s_vmem=8G

set -eux

SCRIPT_FILE=$1

singularity exec $PWD/image/ob_utils_0.0.12a.sif \
    bash ${SCRIPT_FILE}
