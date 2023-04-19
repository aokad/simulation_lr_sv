# simulation_lr_sv

## Set Up
```
git clone https://github.com/aokad/simulation_lr_sv.git --recursive -b v0.2.1
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

# donwload controlpanel (nanomonsv)
mkdir -p $PWD/control_panel
wget https://zenodo.org/api/files/5c116b75-6ef0-4445-9fa8-c5989639da5f/hprc_year1_data_freeze_nanopore_minimap2_2_24_merge_control.tar.gz -O $PWD/control_panel/hprc_year1_data_freeze_nanopore_minimap2_2_24_merge_control.tar.gz
tar -xvf $PWD/control_panel/hprc_year1_data_freeze_nanopore_minimap2_2_24_merge_control.tar.gz
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
singularity pull ./image/ob_utils_0.0.12c.sif docker://aokad/ob_utils:0.0.12c

bash ./create_golden/run.sh
```

### 3. Run SV detection tool

nanomonsv, sniffles2, delly
```
cd ${this_repository}
#singularity pull ./image/simulationsv-set_0.1.0.sif docker://aokad/simulationsv-set:0.1.0
wget https://github.com/ncc-gap/simulation_sv_set/archive/refs/tags/v0.2.1.zip
unzip v0.2.1.zip
mv simulation_sv_set-0.2.1 simulation_sv_set

#singularity pull ./image/ob_utils_0.0.12b.sif docker://aokad/ob_utils:0.0.12b
singularity pull ./image/ob_utils_0.0.12c.sif docker://aokad/ob_utils:0.0.12c

wget https://github.com/dellytools/delly/releases/download/v1.0.3/delly_v1.0.3.sif -O ./image/delly_v1.0.3.sif
singularity pull $PWD/image/sniffles2_2.0.7.sif docker://aokad/sniffles2:2.0.7
singularity pull $PWD/image/nanomonsv_v0.5.0.sif docker://friend1ws/nanomonsv:v0.5.0
singularity pull $PWD/image/camphor_somatic_20221005.sif docker://aokad/camphor_somatic:20221005
singularity pull $PWD/image/cutesv_2.0.0.sif docker://aokad/cutesv:2.0.0
singularity pull $PWD/svim_2.0.0.sif docker://aokad/svim:2.0.0
singularity pull $PWD/image/savana_0.2.3.sif docker://aokad/savana:0.2.3

bash ./run_sv/run.sh
```

### 4. Plot

```
conda create -n r_env r-essentials r-base
conda activate r_env
conda install r-cowplot r-wesanderson

cd ${this_repository}/plot
bash ./run.sh
```
