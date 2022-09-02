#!/bin/bash
set -eux -o pipefail

mkdir -p $PWD/output/chain/simulated_germline_p/lifted_psl/
mkdir -p $PWD/output/chain/simulated_germline_m/lifted_psl/
mkdir -p $PWD/output/chain/simulated_germline_p/chain_raw/
mkdir -p $PWD/output/chain/simulated_germline_m/chain_raw/
mkdir -p $PWD/output/chain/simulated_germline_p/net/
mkdir -p $PWD/output/chain/simulated_germline_m/net/
mkdir -p $PWD/output/chain/simulated_germline_p/chain/
mkdir -p $PWD/output/chain/simulated_germline_m/chain/
mkdir -p $PWD/output/golden/simulated_somatic_p
mkdir -p $PWD/output/golden/simulated_somatic_m
mkdir -p $PWD/output/golden/simulated_somatic_pm

chrom_array=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y)
for i in ${chrom_array[@]}; do
    liftUp -pslQ $PWD/output/chain/simulated_germline_p/lifted_psl/align_GRCh38_to_chr${i}_p.lifted.psl \
        $PWD/output/chain/reference/lift/GRCh38.chr${i}.lft \
        warn \
        $PWD/output/chain/simulated_germline_p/psl/align_GRCh38_to_chr${i}_p.psl
    axtChain \
        -linearGap=medium \
        -psl \
        $PWD/output/chain/simulated_germline_p/lifted_psl/align_GRCh38_to_chr${i}_p.lifted.psl \
        $PWD/output/chain/simulated_germline_p/split/simulated_newname_chr${i}.2bit \
        $PWD/output/chain/reference/region/GRCh38.d1.vd1.chr${i}.2bit \
        $PWD/output/chain/simulated_germline_p/chain_raw/germline_p_to_GRCh38_chr${i}.chain

    liftUp -pslQ $PWD/output/chain/simulated_germline_m/lifted_psl/align_GRCh38_to_chr${i}_m.lifted.psl \
        $PWD/output/chain/reference/lift/GRCh38.chr${i}.lft \
        warn \
        $PWD/output/chain/simulated_germline_m/psl/align_GRCh38_to_chr${i}_m.psl
    axtChain \
        -linearGap=medium \
        -psl \
        $PWD/output/chain/simulated_germline_m/lifted_psl/align_GRCh38_to_chr${i}_m.lifted.psl \
        $PWD/output/chain/simulated_germline_m/split/simulated_newname_chr${i}.2bit \
        $PWD/output/chain/reference/region/GRCh38.d1.vd1.chr${i}.2bit \
        $PWD/output/chain/simulated_germline_m/chain_raw/germline_m_to_GRCh38_chr${i}.chain
done

chainMergeSort $PWD/output/chain/simulated_germline_p/chain_raw/germline_p_to_GRCh38_chr*.chain > $PWD/output/chain/simulated_germline_p/chain_raw/germline_p_to_GRCh38_merged_sorted.chain
chainMergeSort $PWD/output/chain/simulated_germline_m/chain_raw/germline_m_to_GRCh38_chr*.chain > $PWD/output/chain/simulated_germline_m/chain_raw/germline_m_to_GRCh38_merged_sorted.chain

chainSplit $PWD/output/chain/simulated_germline_p/chain_raw/germline_p_to_GRCh38_splited $PWD/output/chain/simulated_germline_p/chain_raw/germline_p_to_GRCh38_merged_sorted.chain
chainSplit $PWD/output/chain/simulated_germline_m/chain_raw/germline_m_to_GRCh38_splited $PWD/output/chain/simulated_germline_m/chain_raw/germline_m_to_GRCh38_merged_sorted.chain

chrom_array=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y)
for i in ${chrom_array[@]}; do
    chainNet \
    $PWD/output/chain/simulated_germline_p/chain_raw/germline_p_to_GRCh38_splited/chr${i}_p.chain \
    $PWD/output/chain/simulated_germline_p/split/simulated_newname_chr${i}.sizes \
    $PWD/output/chain/reference/region/GRCh38.d1.vd1.chr${i}.sizes \
    $PWD/output/chain/simulated_germline_p/net/germline_p_to_GRCh38_chr${i}.net \
    /dev/null

    chainNet \
    $PWD/output/chain/simulated_germline_m/chain_raw/germline_m_to_GRCh38_splited/chr${i}_m.chain \
    $PWD/output/chain/simulated_germline_m/split/simulated_newname_chr${i}.sizes \
    $PWD/output/chain/reference/region/GRCh38.d1.vd1.chr${i}.sizes \
    $PWD/output/chain/simulated_germline_m/net/germline_m_to_GRCh38_chr${i}.net \
    /dev/null
done

for i in ${chrom_array[@]}; do
    netChainSubset \
    $PWD/output/chain/simulated_germline_p/net/germline_p_to_GRCh38_chr${i}.net \
    $PWD/output/chain/simulated_germline_p/chain_raw/germline_p_to_GRCh38_splited/chr${i}_p.chain \
    $PWD/output/chain/simulated_germline_p/chain/germline_p_to_GRCh38_chr${i}.chain

    netChainSubset \
    $PWD/output/chain/simulated_germline_m/net/germline_m_to_GRCh38_chr${i}.net \
    $PWD/output/chain/simulated_germline_m/chain_raw/germline_m_to_GRCh38_splited/chr${i}_m.chain \
    $PWD/output/chain/simulated_germline_m/chaingermline_m_to_GRCh38_chr${i}.chain
done

chrom_array=(2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y)
cat $PWD/output/chain/simulated_germline_p/chain/germline_p_to_GRCh38_chr1.chain > $PWD/output/chain/simulated_germline_p/chain/germline_p_to_GRCh38.chain
cat $PWD/output/chain/simulated_germline_m/chain/germline_m_to_GRCh38_chr1.chain > $PWD/output/chain/simulated_germline_m/chain/germline_m_to_GRCh38.chain
for i in ${chrom_array[@]}; do
    cat $PWD/output/chain/simulated_germline_p/chain_raw/germline_p_to_GRCh38_chr${i}.chain >> $PWD/output/chain/simulated_germline_p/chain/germline_p_to_GRCh38.chain
    cat $PWD/output/chain/simulated_germline_m/chain_raw/germline_m_to_GRCh38_chr${i}.chain >> $PWD/output/chain/simulated_germline_m/chain/germline_m_to_GRCh38.chain
done

awk '{print $1"\t"$2-1"\t"$2"\t"$5"\t"NR}' $PWD/output/survivor/simulated_somatic_chr1-22XY_p/simulated.bed > $PWD/output/answer/simulated_somatic_p/simulated_somatic_p_newname_3col_1.bed
awk '{print $3"\t"$4-1"\t"$4"\t"$5"\t"NR}' $PWD/output/survivor/simulated_somatic_chr1-22XY_p/simulated.bed > $PWD/output/answer/simulated_somatic_p/simulated_somatic_p_newname_3col_2.bed

awk '{print $1"\t"$2-1"\t"$2"\t"$5"\t"NR}' $PWD/output/survivor/simulated_somatic_chr1-22XY_m/simulated.bed > $PWD/output/answer/simulated_somatic_m/simulated_somatic_m_newname_3col_1.bed
awk '{print $3"\t"$4-1"\t"$4"\t"$5"\t"NR}' $PWD/output/survivor/simulated_somatic_chr1-22XY_m/simulated.bed > $PWD/output/answer/simulated_somatic_m/simulated_somatic_m_newname_3col_2.bed

liftOver \
$PWD/output/answer/simulated_somatic_p/simulated_somatic_p_newname_3col_1.bed \
$PWD/output/chain/simulated_germline_p/chain/germline_p_to_GRCh38.chain \
$PWD/output/answer/simulated_somatic_p/simulated_somatic_p_newname_liftover_1.bed \
$PWD/output/answer/simulated_somatic_p/simulated_somatic_p_newname_liftover_unmapped_1.bed

liftOver \
$PWD/output/answer/simulated_somatic_p/simulated_somatic_p_newname_3col_2.bed \
$PWD/output/chain/simulated_germline_p/chain/germline_p_to_GRCh38.chain \
$PWD/output/answer/simulated_somatic_p/simulated_somatic_p_newname_liftover_2.bed \
$PWD/output/answer/simulated_somatic_p/simulated_somatic_p_newname_liftover_unmapped_2.bed

liftOver \
$PWD/output/answer/simulated_somatic_m/simulated_somatic_m_newname_3col_1.bed \
$PWD/output/chain/simulated_germline_m/chain/germline_m_to_GRCh38.chain   \
$PWD/output/answer/simulated_somatic_m/simulated_somatic_m_newname_liftover_1.bed \
$PWD/output/answer/simulated_somatic_m/simulated_somatic_m_newname_liftover_unmapped_1.bed

liftOver \
$PWD/output/answer/simulated_somatic_m/simulated_somatic_m_newname_3col_2.bed \
$PWD/output/chain/simulated_germline_m/chain/germline_m_to_GRCh38.chain \
$PWD/output/answer/simulated_somatic_m/simulated_somatic_m_newname_liftover_2.bed \
$PWD/output/answer/simulated_somatic_m/simulated_somatic_m_newname_liftover_unmapped_2.bed

python3 $PWD/script/simulation_sv_set/script/paste_liftover_bed.py \
  $PWD/output/answer/simulated_somatic_p/simulated_somatic_p_newname_liftover_1.bed \
  $PWD/output/answer/simulated_somatic_p/simulated_somatic_p_newname_liftover_2.bed > $PWD/output/answer/simulated_somatic_p/simulated_somatic_p_newname_liftover.bedpe

python3 $PWD/script/simulation_sv_set/script/paste_liftover_bed.py \
  $PWD/output/answer/simulated_somatic_m/simulated_somatic_m_newname_liftover_1.bed \
  $PWD/output/answer/simulated_somatic_m/simulated_somatic_m_newname_liftover_2.bed > $PWD/output/answer/simulated_somatic_m/simulated_somatic_m_newname_liftover.bedpe

cd $PWD/output/golden/
cat simulated_somatic_p/simulated_somatic_p_newname_liftover.bedpe simulated_somatic_m/simulated_somatic_m_newname_liftover.bedpe | sort -k1,1 -k2,2n -k3,3n -k4,4 -k5,5n -k6,6n > simulated_somatic_pm/simulated_somatic_p_m_newname_liftover.bedpe

bgzip -f simulated_somatic_pm/simulated_somatic_p_m_newname_liftover.bedpe
tabix -p bed simulated_somatic_pm/simulated_somatic_p_m_newname_liftover.bedpe.gz

