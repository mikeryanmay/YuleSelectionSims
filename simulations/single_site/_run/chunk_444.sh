#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_444
#SBATCH --mail-user=mikeryanmay@gmail.com
#SBATCH --mail-type=FAIL
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --time=72:00:00

# change to user directory
cd /home/$USER/YuleSelectionSims/simulations/single_site/

# load the module
module load R

# run the analyses
Rscript ../../src/analysis.R ./scenario/scenario_3_size_1000/rep_153 &
Rscript ../../src/analysis.R ./scenario/scenario_3_size_1000/rep_154 &
Rscript ../../src/analysis.R ./scenario/scenario_3_size_1000/rep_155 &
Rscript ../../src/analysis.R ./scenario/scenario_3_size_1000/rep_156 &
Rscript ../../src/analysis.R ./scenario/scenario_3_size_1000/rep_157 &
Rscript ../../src/analysis.R ./scenario/scenario_3_size_1000/rep_158 &
Rscript ../../src/analysis.R ./scenario/scenario_3_size_1000/rep_159 &
Rscript ../../src/analysis.R ./scenario/scenario_3_size_1000/rep_16 &
Rscript ../../src/analysis.R ./scenario/scenario_3_size_1000/rep_160 &
Rscript ../../src/analysis.R ./scenario/scenario_3_size_1000/rep_1530 &
Rscript ../../src/analysis.R ./scenario/scenario_3_size_1000/rep_1531 &
Rscript ../../src/analysis.R ./scenario/scenario_3_size_1000/rep_1532 &
Rscript ../../src/analysis.R ./scenario/scenario_3_size_1000/rep_1533 &
Rscript ../../src/analysis.R ./scenario/scenario_3_size_1000/rep_1534 &
Rscript ../../src/analysis.R ./scenario/scenario_3_size_1000/rep_1535 &
Rscript ../../src/analysis.R ./scenario/scenario_3_size_1000/rep_1536 &
Rscript ../../src/analysis.R ./scenario/scenario_3_size_1000/rep_1537 &
Rscript ../../src/analysis.R ./scenario/scenario_3_size_1000/rep_1538 &
Rscript ../../src/analysis.R ./scenario/scenario_3_size_1000/rep_1539 &
Rscript ../../src/analysis.R ./scenario/scenario_3_size_1000/rep_1540 ;

# wait for all tasks to complete
wait;

# DONE
