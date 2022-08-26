#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_401
#SBATCH --mail-user=mikeryanmay@gmail.com
#SBATCH --mail-type=FAIL
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --time=168:00:00

# change to user directory
cd /home/$USER/YuleSelectionSims/simulations/single_site/

# load the module
module load R

# run the analyses
Rscript ../../src/lik_analysis.R ./factor/tips_100_size_100_factor_3/rep_3 &
Rscript ../../src/lik_analysis.R ./factor/tips_100_size_100_factor_3/rep_4 &
Rscript ../../src/lik_analysis.R ./factor/tips_100_size_100_factor_3/rep_5 &
Rscript ../../src/lik_analysis.R ./factor/tips_100_size_100_factor_3/rep_6 &
Rscript ../../src/lik_analysis.R ./factor/tips_100_size_100_factor_3/rep_7 &
Rscript ../../src/lik_analysis.R ./factor/tips_100_size_100_factor_3/rep_8 &
Rscript ../../src/lik_analysis.R ./factor/tips_100_size_100_factor_3/rep_9 &
Rscript ../../src/lik_analysis.R ./factor/tips_100_size_100_factor_3/rep_10 &
Rscript ../../src/lik_analysis.R ./factor/tips_100_size_100_factor_3/rep_11 &
Rscript ../../src/lik_analysis.R ./factor/tips_100_size_100_factor_3/rep_12 &
Rscript ../../src/lik_analysis.R ./factor/tips_100_size_100_factor_3/rep_13 &
Rscript ../../src/lik_analysis.R ./factor/tips_100_size_100_factor_3/rep_14 &
Rscript ../../src/lik_analysis.R ./factor/tips_100_size_100_factor_3/rep_15 &
Rscript ../../src/lik_analysis.R ./factor/tips_100_size_100_factor_3/rep_16 &
Rscript ../../src/lik_analysis.R ./factor/tips_100_size_100_factor_3/rep_17 &
Rscript ../../src/lik_analysis.R ./factor/tips_100_size_100_factor_3/rep_18 &
Rscript ../../src/lik_analysis.R ./factor/tips_100_size_100_factor_3/rep_19 &
Rscript ../../src/lik_analysis.R ./factor/tips_100_size_100_factor_3/rep_20 &
Rscript ../../src/lik_analysis.R ./factor/tips_100_size_100_factor_3/rep_21 &
Rscript ../../src/lik_analysis.R ./factor/tips_100_size_100_factor_3/rep_22 ;

# wait for all tasks to complete
wait;

# DONE
