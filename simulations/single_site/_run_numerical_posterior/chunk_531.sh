#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_531
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
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_250_size_1_factor_4/rep_1 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_250_size_1_factor_4/rep_2 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_250_size_1_factor_4/rep_3 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_250_size_1_factor_4/rep_4 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_250_size_1_factor_4/rep_5 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_250_size_1_factor_4/rep_6 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_250_size_1_factor_4/rep_7 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_250_size_1_factor_4/rep_8 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_250_size_1_factor_4/rep_9 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_250_size_1_factor_4/rep_10 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_250_size_1_factor_4/rep_11 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_250_size_1_factor_4/rep_12 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_250_size_1_factor_4/rep_13 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_250_size_1_factor_4/rep_14 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_250_size_1_factor_4/rep_15 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_250_size_1_factor_4/rep_16 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_250_size_1_factor_4/rep_17 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_250_size_1_factor_4/rep_18 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_250_size_1_factor_4/rep_19 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_250_size_1_factor_4/rep_20 ;

# wait for all tasks to complete
wait;

# DONE
