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

singularity exec $PWD/image/chain-file_0.1.0.sif \
    bash $PWD/create_sv_answer/shell_twobit_info.sh
