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

set -eux

singularity exec $PWD/image/chain-file_0.1.0.sif \
    bash $PWD/create_sv_answer/shell_chain.sh

singularity exec $PWD/image/ob_utils_0.0.12.sif \
    bgzip -f $PWD/output/golden/simulated_somatic_pm/simulated_somatic_p_m_newname_liftover.bedpe

singularity exec $PWD/image/ob_utils_0.0.12.sif \
    tabix -p bed $PWD/output/golden/simulated_somatic_pm/simulated_somatic_p_m_newname_liftover.bedpe.gz
