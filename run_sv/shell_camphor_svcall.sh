#!/bin/bash
set -eux

SORT_BY_NAME_BAM=$1
SORT_BY_COORDINATE_BAM=$2
OUTPUT_DIR=$3

cd /tools/CAMPHORsomatic
sh ./CAMPHOR_SVcall.sh \
    ${SORT_BY_NAME_BAM} \
    ${SORT_BY_COORDINATE_BAM} \
    ${OUTPUT_DIR}
