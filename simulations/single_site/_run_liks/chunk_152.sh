#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_152
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
Rscript ../../src/lik_analysis.R ./factor/tips_50_size_100_factor_2.5/rep_21 &
Rscript ../../src/lik_analysis.R ./factor/tips_50_size_100_factor_2.5/rep_22 &
Rscript ../../src/lik_analysis.R ./factor/tips_50_size_100_factor_2.5/rep_23 &
Rscript ../../src/lik_analysis.R ./factor/tips_50_size_100_factor_2.5/rep_24 &
Rscript ../../src/lik_analysis.R ./factor/tips_50_size_100_factor_2.5/rep_25 &
Rscript ../../src/lik_analysis.R ./factor/tips_50_size_100_factor_2.5/rep_26 &
Rscript ../../src/lik_analysis.R ./factor/tips_50_size_100_factor_2.5/rep_27 &
Rscript ../../src/lik_analysis.R ./factor/tips_50_size_100_factor_2.5/rep_28 &
Rscript ../../src/lik_analysis.R ./factor/tips_50_size_100_factor_2.5/rep_29 &
Rscript ../../src/lik_analysis.R ./factor/tips_50_size_100_factor_2.5/rep_30 &
Rscript ../../src/lik_analysis.R ./factor/tips_50_size_100_factor_2.5/rep_31 &
Rscript ../../src/lik_analysis.R ./factor/tips_50_size_100_factor_2.5/rep_32 &
Rscript ../../src/lik_analysis.R ./factor/tips_50_size_100_factor_2.5/rep_33 &
Rscript ../../src/lik_analysis.R ./factor/tips_50_size_100_factor_2.5/rep_34 &
Rscript ../../src/lik_analysis.R ./factor/tips_50_size_100_factor_2.5/rep_35 &
Rscript ../../src/lik_analysis.R ./factor/tips_50_size_100_factor_2.5/rep_36 &
Rscript ../../src/lik_analysis.R ./factor/tips_50_size_100_factor_2.5/rep_37 &
Rscript ../../src/lik_analysis.R ./factor/tips_50_size_100_factor_2.5/rep_38 &
Rscript ../../src/lik_analysis.R ./factor/tips_50_size_100_factor_2.5/rep_39 &
Rscript ../../src/lik_analysis.R ./factor/tips_50_size_100_factor_2.5/rep_40 ;

# wait for all tasks to complete
wait;

# DONE
