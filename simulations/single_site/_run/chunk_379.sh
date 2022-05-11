#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_379
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
Rscript ../../src/analysis.R ./scenario/scenario_1_size_100/rep_63 &
Rscript ../../src/analysis.R ./scenario/scenario_1_size_100/rep_64 &
Rscript ../../src/analysis.R ./scenario/scenario_1_size_100/rep_65 &
Rscript ../../src/analysis.R ./scenario/scenario_1_size_100/rep_66 &
Rscript ../../src/analysis.R ./scenario/scenario_1_size_100/rep_67 &
Rscript ../../src/analysis.R ./scenario/scenario_1_size_100/rep_68 &
Rscript ../../src/analysis.R ./scenario/scenario_1_size_100/rep_69 &
Rscript ../../src/analysis.R ./scenario/scenario_1_size_100/rep_7 &
Rscript ../../src/analysis.R ./scenario/scenario_1_size_100/rep_70 &
Rscript ../../src/analysis.R ./scenario/scenario_1_size_100/rep_630 &
Rscript ../../src/analysis.R ./scenario/scenario_1_size_100/rep_631 &
Rscript ../../src/analysis.R ./scenario/scenario_1_size_100/rep_632 &
Rscript ../../src/analysis.R ./scenario/scenario_1_size_100/rep_633 &
Rscript ../../src/analysis.R ./scenario/scenario_1_size_100/rep_634 &
Rscript ../../src/analysis.R ./scenario/scenario_1_size_100/rep_635 &
Rscript ../../src/analysis.R ./scenario/scenario_1_size_100/rep_636 &
Rscript ../../src/analysis.R ./scenario/scenario_1_size_100/rep_637 &
Rscript ../../src/analysis.R ./scenario/scenario_1_size_100/rep_638 &
Rscript ../../src/analysis.R ./scenario/scenario_1_size_100/rep_639 &
Rscript ../../src/analysis.R ./scenario/scenario_1_size_100/rep_640 ;

# wait for all tasks to complete
wait;

# DONE
