#!/bin/bash
set -eux -o pipefail

mkdir -p $PWD/output/chain/reference/region/
mkdir -p $PWD/output/chain/simulated_germline_p/split/
mkdir -p $PWD/output/chain/simulated_germline_m/split/
mkdir -p $PWD/output/chain/simulated_germline_p/psl/
mkdir -p $PWD/output/chain/simulated_germline_m/psl/
mkdir -p $PWD/output/chain/reference/lift/
mkdir -p $PWD/output/chain/reference/split/
mkdir -p $PWD/output/chain/reference/ooc/

chrom_array=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y)
for i in ${chrom_array[@]}; do
    python $PWD/simulation_sv_set/script/split_refgenome.py $PWD/reference/GRCh38.d1.vd1.fa chr${i} "" > $PWD/output/chain/reference/region/GRCh38.d1.vd1.chr${i}.fa

    python $PWD/simulation_sv_set/script/split_refgenome.py $PWD/output/survivor/simulated_germline_chr1-22XY_p/simulated_newname.fasta chr${i} _p > $PWD/output/chain/simulated_germline_p/split/simulated_newname_chr${i}.fasta

    python $PWD/simulation_sv_set/script/split_refgenome.py $PWD/output/survivor/simulated_germline_chr1-22XY_m/simulated_newname.fasta chr${i} _m > $PWD/output/chain/simulated_germline_m/split/simulated_newname_chr${i}.fasta

    faToTwoBit $PWD/output/chain/reference/region/GRCh38.d1.vd1.chr${i}.fa $PWD/output/chain/reference/region/GRCh38.d1.vd1.chr${i}.2bit
    twoBitInfo $PWD/output/chain/reference/region/GRCh38.d1.vd1.chr${i}.2bit $PWD/output/chain/reference/region/GRCh38.d1.vd1.chr${i}.sizes

    faToTwoBit $PWD/output/chain/simulated_germline_p/split/simulated_newname_chr${i}.fasta $PWD/output/chain/simulated_germline_p/split/simulated_newname_chr${i}.2bit
    twoBitInfo $PWD/output/chain/simulated_germline_p/split/simulated_newname_chr${i}.2bit $PWD/output/chain/simulated_germline_p/split/simulated_newname_chr${i}.sizes

    faToTwoBit $PWD/output/chain/simulated_germline_m/split/simulated_newname_chr${i}.fasta $PWD/output/chain/simulated_germline_m/split/simulated_newname_chr${i}.2bit
    twoBitInfo $PWD/output/chain/simulated_germline_m/split/simulated_newname_chr${i}.2bit $PWD/output/chain/simulated_germline_m/split/simulated_newname_chr${i}.sizes

    faSplit -lift=$PWD/output/chain/reference/lift/GRCh38.chr${i}.lft size $PWD/output/chain/reference/region/GRCh38.d1.vd1.chr${i}.fa -oneFile 3000 $PWD/output/chain/reference/split/GRCh38.d1.vd1.chr${i}
done

faToTwoBit $PWD/reference/GRCh38.d1.vd1.fa $PWD/output/chain/reference/ooc/GRCh38.d1.vd1.2bit
blat $PWD/output/chain/reference/ooc/GRCh38.d1.vd1.2bit /dev/null /dev/null -makeOoc=$PWD/output/chain/reference/ooc/12.ooc -tileSize=12
