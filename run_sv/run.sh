#!/bin/bash
set -eux

SCRIPT_DIR=$(dirname $0)

qsub -N nanomonsv -t 1-30 ${SCRIPT_DIR}/nanomonsv.sh
qsub -N nanomonsv -t 1-5  ${SCRIPT_DIR}/nanomonsv_germline2.sh
qsub -N sniffles2 -t 1-30 ${SCRIPT_DIR}/sniffles2.sh
qsub -N sniffles2 -t 1-5  ${SCRIPT_DIR}/sniffles2_germline2.sh
qsub -N delly -t 1-30 ${SCRIPT_DIR}/delly.sh
qsub -N delly -t 1-5  ${SCRIPT_DIR}/delly_germline2.sh

qsub -N nanomonsv_vsgolden -hold_jid nanomonsv ${SCRIPT_DIR}/vsgolden.sh ${SCRIPT_DIR}/nanomonsv_vsgolden.sh
qsub -N sniffles2_vsgolden -hold_jid sniffles2 ${SCRIPT_DIR}/vsgolden.sh ${SCRIPT_DIR}/sniffles2_vsgolden.sh
qsub -N delly_vsgolden -hold_jid delly ${SCRIPT_DIR}/vsgolden.sh ${SCRIPT_DIR}/delly_vsgolden.sh
