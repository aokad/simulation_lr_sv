# simulation_lr_sv

## install

```
git clone https://github.com/aokad/simulation_lr_sv.git
cd image
singularity pull docker://ob_utils:0.1.0
```

## run

## 1. Create simulation sequence data

```
cd create_simulation_seq/
bash run.sh
```

## 2. Create the correct set of structural variations

```
cd create_sv_answer/
bash run.sh
```

## 3. Run SV detection tool

sniffles2
```
cd run_sv_tool/
bash run_sniffles2.sh
```

nanomonsv
```
cd run_sv_tool/
bash run_nanomonsv.sh
```

## 4. Plot

```
cd plot
bash run.sh
```


