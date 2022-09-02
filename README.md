# simulation_lr_sv

## Set Up
```
git clone https://github.com/aokad/simulation_lr_sv.git --recursive
```

download reference files
```
cd simulation_lr_sv
mkdir reference/
cd reference
wget https://api.gdc.cancer.gov/data/254f697d-310d-4d7d-a27b-27fbf767a834 -O GRCh38.d1.vd1.fa.tar.gz
tar -zxvf GRCh38.d1.vd1.fa.tar.gz
wget https://api.gdc.cancer.gov/data/2c5730fb-0909-4e2a-8a7a-c9a7f8b2dad5 -O GRCh38.d1.vd1_GATK_indices.tar.gz
tar -zxvf GRCh38.d1.vd1_GATK_indices.tar.gz

# download reference file for minimap2
aws s3 cp s3://genomon-bucket/GDC.GRCh38.d1.vd1/minimap2/GRCh38.d1.vd1.mmi ./
```

## How To Use

### 1. Create simulation sequence data

```
cd ${this_repository}
singularity pull ./image/simulationsv-set_0.1.0.sif docker://aokad/simulationsv-set:0.1.0
singularity pull ./image/nanostat_1.4.0-s.sif docker://ken01nn/nanostat:1.4.0-s
singularity pull ./image/sra-tools_3.0.0.sif docker://ncbi/sra-tools:3.0.0
singularity pull ./image/minimap2_2.17.sif docker://ken01nn/minimap2:2.17

bash ./create_simulation_seq/run.sh
```

### 2. Create the correct set of structural variations

```
cd ${this_repository}
singularity pull ./image/chain-file_0.1.0.sif docker://aokad/chain-file:0.1.0

bash ./create_golden/run.sh
```

### 3. Run SV detection tool

nanomonsv, sniffles2, delly
```
cd ${this_repository}
singularity pull ./image/sniffles2_2.0.7.sif docker://aokad/sniffles2:2.0.7
singularity pull ./image/nanomonsv_v0.5.0.sif docker://friend1ws/nanomonsv:v0.5.0
singularity pull ./image/ob_utils_0.0.12.sif docker://aokad/ob_utils:0.0.12

bash ./run_sv/run.sh
```

### 4. Plot

```
conda create -n r_env r-essentials r-base
conda activate r_env
conda install r-cowplot r-wesanderson

cd ${this_repository}
bash ./plot/run.sh
```
