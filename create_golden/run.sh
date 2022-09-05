#!/bin/bash
set -eux

SCRIPT_DIR=$(dirname $0)

qsub -N twobit_info ${SCRIPT_DIR}/twobit_info.sh

chrom_array=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y)
for i in ${chrom_array[@]}; do
  qsub -N blat -hold_jid twobit_info ${SCRIPT_DIR}/blat.sh ${i} p
  qsub -N blat -hold_jid twobit_info ${SCRIPT_DIR}/blat.sh ${i} m
done

qsub -N chain -hold_jid blat ${SCRIPT_DIR}/chain.sh
