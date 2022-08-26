#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_1202
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
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_1_factor_1/rep_23 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_1_factor_1/rep_24 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_1_factor_1/rep_25 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_1_factor_1/rep_26 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_1_factor_1/rep_27 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_1_factor_1/rep_28 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_1_factor_1/rep_29 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_1_factor_1/rep_30 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_1_factor_1/rep_31 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_1_factor_1/rep_32 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_1_factor_1/rep_33 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_1_factor_1/rep_34 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_1_factor_1/rep_35 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_1_factor_1/rep_36 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_1_factor_1/rep_37 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_1_factor_1/rep_38 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_1_factor_1/rep_39 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_1_factor_1/rep_40 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_1_factor_1/rep_41 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_1_factor_1/rep_42 ;

# wait for all tasks to complete
wait;

# DONE
