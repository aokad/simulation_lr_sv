#! /usr/bin/env bash

mkdir -p ../output/plot/

python3 org.py
Rscript plot.R

python3 org2.py ../output/vs_golden_data/nanomonsv/simulation_count_support.txt > ../output/plot/simulation_count_support.txt 
Rscript plot2.R
mv ../output/plot/simulation_count_support.txt ../output/plot/simulation_count_support_nanomonsv.txt
mv ../output/plot/simulation_support.pdf ../output/plot/simulation_support_nanomonsv.pdf

python3 org2.py ../output/vs_golden_data/sniffles2/simulation_count_support.txt > ../output/plot/simulation_count_support.txt 
Rscript plot2.R
mv ../output/plot/simulation_count_support.txt ../output/plot/simulation_count_support_sniffles2.txt
mv ../output/plot/simulation_support.pdf ../output/plot/simulation_support_sniffles2.pdf

python3 org2.py ../output/vs_golden_data/delly/simulation_count_support.txt > ../output/plot/simulation_count_support.txt 
Rscript plot2.R
mv ../output/plot/simulation_count_support.txt ../output/plot/simulation_count_support_delly.txt
mv ../output/plot/simulation_support.pdf ../output/plot/simulation_support_delly.pdf

python3 org2.py ../output/vs_golden_data/cutesv/simulation_count_support.txt > ../output/plot/simulation_count_support.txt 
Rscript plot2.R
mv ../output/plot/simulation_count_support.txt ../output/plot/simulation_count_support_cutesv.txt
mv ../output/plot/simulation_support.pdf ../output/plot/simulation_support_cutesv.pdf

python3 org2.py ../output/vs_golden_data/CAMPHORsomatic/simulation_count_support.txt > ../output/plot/simulation_count_support.txt 
Rscript plot2.R
mv ../output/plot/simulation_count_support.txt ../output/plot/simulation_count_support_CAMPHORsomatic.txt
mv ../output/plot/simulation_support.pdf ../output/plot/simulation_support_CAMPHORsomatic.pdf

python3 org2.py ../output/vs_golden_data/svim/simulation_count_support.txt > ../output/plot/simulation_count_support.txt 
Rscript plot2.R
mv ../output/plot/simulation_count_support.txt ../output/plot/simulation_count_support_svim.txt
mv ../output/plot/simulation_support.pdf ../output/plot/simulation_support_svim.pdf

python3 org2.py ../output/vs_golden_data/savana/simulation_count_support.txt > ../output/plot/simulation_count_support.txt 
Rscript plot2.R
mv ../output/plot/simulation_count_support.txt ../output/plot/simulation_count_support_savana.txt
mv ../output/plot/simulation_support.pdf ../output/plot/simulation_support_savana.pdf

python3 org3.py
Rscript plot3.R
