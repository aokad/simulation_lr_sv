#!/bin/bash
set -eux

mkdir -p output/vs_golden_data/nanomonsv

for a in "DP10_TP0_TDP0"    \
         "DP10_TP20_TDP2"   \
         "DP10_TP40_TDP4"   \
         "DP10_TP60_TDP6"   \
         "DP10_TP80_TDP8"   \
         "DP10_TP100_TDP10" \
         "DP20_TP0_TDP0"    \
         "DP20_TP20_TDP4"   \
         "DP20_TP40_TDP8"   \
         "DP20_TP60_TDP12"  \
         "DP20_TP80_TDP16"  \
         "DP20_TP100_TDP20" \
         "DP30_TP0_TDP0"    \
         "DP30_TP20_TDP6"   \
         "DP30_TP40_TDP12"  \
         "DP30_TP60_TDP18"  \
         "DP30_TP80_TDP24"  \
         "DP30_TP100_TDP30" \
         "DP40_TP0_TDP0"    \
         "DP40_TP20_TDP8"   \
         "DP40_TP40_TDP16"  \
         "DP40_TP60_TDP24"  \
         "DP40_TP80_TDP32"  \
         "DP40_TP100_TDP40" \
         "DP50_TP0_TDP0"    \
         "DP50_TP20_TDP10"  \
         "DP50_TP40_TDP20"  \
         "DP50_TP60_TDP30"  \
         "DP50_TP80_TDP40"  \
         "DP50_TP100_TDP50"
do
    # filtering
    python3 $PWD/script/simulation_sv_set/script/nanomonsv_filter.py \
    $PWD/output/nanomonsv/${a}/${a}.nanomonsv.result.txt \
    $PWD/output/nanomonsv/${a}/${a}.nanomonsv.result.vcf > \
    $PWD/output/nanomonsv/${a}/${a}.nanomonsv.result_filt.txt
    
    python3 $PWD/script/simulation_sv_set/script/rmdup.py \
    $PWD/output/nanomonsv/${a}/${a}.nanomonsv.result_filt.txt > \
    $PWD/output/nanomonsv/${a}/${a}.nanomonsv.result_filt2.txt
    
    # sort by chromosome + filtering scaffold
    python3 $PWD/script/simulation_sv_set/script/sort_bedpe.py \
    $PWD/output/nanomonsv/${a}/${a}.nanomonsv.result_filt2.txt > \
    $PWD/output/nanomonsv/${a}/${a}.nanomonsv.result_rmdup.txt
    
    # vs golden data
    python3 $PWD/script/simulation_sv_set/script/golden_data_check.py \
    $PWD/output/nanomonsv/${a}/${a}.nanomonsv.result_rmdup.txt \
    $PWD/output/golden/simulated_somatic_pm/simulated_somatic_p_m_newname_liftover.bedpe.gz \
    $PWD/output/vs_golden_data/nanomonsv/simulated_somatic_minimap2_${a}_vs_goldendata.txt

    for support_read in `seq 3 10`
    do
        mkdir -p $PWD/output/vs_golden_data/nanomonsv_support_${support_read}
        python3 $PWD/script/simulation_sv_set/script/golden_data_check_support.py \
        $PWD/output/nanomonsv/${a}/${a}.nanomonsv.result_rmdup.txt \
        $PWD/output/golden/simulated_somatic_pm/simulated_somatic_p_m_newname_liftover.bedpe.gz \
        $PWD/output/vs_golden_data/nanomonsv_support_${support_read}/simulated_somatic_minimap2_${a}_vs_goldendata.txt \
        ${support_read}
    done
done

# count TP,FP,FN
python3 $PWD/script/simulation_sv_set/script/count_TP_FP_FN.py $PWD/output/vs_golden_data/nanomonsv/ $PWD/output/vs_golden_data/nanomonsv/simulation_count.txt

# count support reads
python3 $PWD/script/simulation_sv_set/script/count_TP_FP_FN_support.py $PWD/output/vs_golden_data/nanomonsv $PWD/output/vs_golden_data/nanomonsv/simulation_count_support.txt
