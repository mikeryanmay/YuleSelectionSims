#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_191
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
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_4/rep_1 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_4/rep_10 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_4/rep_100 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_4/rep_101 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_4/rep_102 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_4/rep_103 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_4/rep_104 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_4/rep_105 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_4/rep_106 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_4/rep_10 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_4/rep_11 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_4/rep_12 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_4/rep_13 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_4/rep_14 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_4/rep_15 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_4/rep_16 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_4/rep_17 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_4/rep_18 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_4/rep_19 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_4/rep_100 ;

# wait for all tasks to complete
wait;

# DONE
