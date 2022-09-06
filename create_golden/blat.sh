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

i=$1
pm=$2

singularity exec $PWD/image/chain-file_0.1.0.sif \
    blat \
    $PWD/output/chain/simulated_germline_${pm}/split/simulated_newname_chr$i.2bit \
    $PWD/output/chain/reference/split/GRCh38.d1.vd1.chr$i.fa \
    -ooc=$PWD/output/chain/reference/ooc/12.ooc \
    $PWD/output/chain/simulated_germline_${pm}/psl/align_GRCh38_to_chr${i}_${pm}.psl \
    -tileSize=12 -minScore=100 -minIdentity=98 -fastMap
