#! /usr/bin/env bash

python3 org.py 

Rscript plot.R

python3 org2.py $PWD/output/vs_golden_data/nanomonsv/simulation_count_support.txt > $PWD/output/plot/simulation_count_support.txt 

Rscript plot2.R

