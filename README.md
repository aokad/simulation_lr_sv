# simulation_lr_sv

## Set Up
```
git clone https://github.com/aokad/simulation_lr_sv.git
```

## How To Use

### 1. Create simulation sequence data

```
cd ${this_repository}
singularity pull ./image/simulationsv-set_0.1.0.sif docker://aokad/simulationsv-set:0.1.0
singularity pull ./image/nanostat_1.4.0-s.sif docker://ken01nn/nanostat:1.4.0-s
singularity pull ./image/sra-tools_3.0.0.sif docker://ncbi/sra-tools:3.0.0

bash ./create_simulation_seq/run.sh
```

### 2. Create the correct set of structural variations

```
cd ${this_repository}
singularity pull ./image/chain-file_0.1.0.sif docker://ken01nn/chain-file_0.1.0.sif

bash ./create_sv_answer/run.sh
```

### 3. Run alignment tool (minimap2)

```
cd ${this_repository}
singularity pull ./image/minimap2_2.17.sif docker://ken01nn/minimap2:2.17

bash ./run_alignment/run.sh
```

### 4. Run SV detection tool

sniffles2
```
cd ${this_repository}
singularity pull ./image/sniffles2_2.0.7.sif docker://aokad/snilles2:2.0.7
singularity pull ./image/ob_utils_0.1.0.sif docker://aokad/ob_utils:0.1.0

bash ./run_sv/run_sniffles2.sh
```

nanomonsv
```
cd ${this_repository}
singularity pull ./image/nanomonsv_v0.5.0.sif docker://friend1ws/nanomonsv:v0.5.0
singularity pull ./image/ob_utils_0.1.0.sif docker://aokad/ob_utils:0.1.0

bash ./run_sv/run_nanomonsv.sh
```

### 4. Plot

```
conda create -n r_env r-essentials r-base
conda activate r_env
conda install r-cowplot r-wesanderson

cd ${this_repository}
bash ./plot/run.sh
```
