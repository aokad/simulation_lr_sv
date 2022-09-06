#!/bin/bash
set -eux

SCRIPT_DIR=$(dirname $0)

# nanomonsv
qsub -N nanomonsv_germline2 -t 1-5  ${SCRIPT_DIR}/nanomonsv_germline2.sh
qsub -N nanomonsv -hold_jid nanomonsv_germline2 -t 1-30 ${SCRIPT_DIR}/nanomonsv.sh
qsub -N nanomonsv_vsgolden -hold_jid nanomonsv ${SCRIPT_DIR}/vsgolden.sh ${SCRIPT_DIR}/nanomonsv_vsgolden.sh

# sniffles2
qsub -N sniffles2 -t 1-30 ${SCRIPT_DIR}/sniffles2.sh
qsub -N sniffles2 -t 1-5  ${SCRIPT_DIR}/sniffles2_germline2.sh
qsub -N sniffles2_vsgolden -hold_jid sniffles2 ${SCRIPT_DIR}/vsgolden.sh ${SCRIPT_DIR}/sniffles2_vsgolden.sh

# delly
qsub -N delly -t 1-30 ${SCRIPT_DIR}/delly.sh
qsub -N delly -t 1-5  ${SCRIPT_DIR}/delly_germline2.sh
qsub -N delly_vsgolden -hold_jid delly ${SCRIPT_DIR}/vsgolden.sh ${SCRIPT_DIR}/delly_vsgolden.sh

# camphor
qsub -N camphor_decompress_fastq -t 1-5  ${SCRIPT_DIR}/camphor_decompress_fastq.sh
qsub -N camphor_germline2 -t 1-5  ${SCRIPT_DIR}/camphor_germline2.sh
qsub -N camphor -hold_jid camphor_germline2,camphor_decompress_fastq -t 1-30 ${SCRIPT_DIR}/camphor.sh
qsub -N camphor_vsgolden -hold_jid camphor ${SCRIPT_DIR}/vsgolden.sh ${SCRIPT_DIR}/camphor_vsgolden.sh

# cutesv
qsub -N cutesv -t 1-30 ${SCRIPT_DIR}/cutesv.sh
qsub -N cutesv -t 1-5  ${SCRIPT_DIR}/cutesv_germline2.sh
qsub -N cutesv_vsgolden -hold_jid cutesv ${SCRIPT_DIR}/vsgolden.sh ${SCRIPT_DIR}/cutesv_vsgolden.sh
