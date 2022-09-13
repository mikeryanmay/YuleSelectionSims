#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_1373
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
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_1000_size_100_factor_4/rep_41 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_1000_size_100_factor_4/rep_42 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_1000_size_100_factor_4/rep_43 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_1000_size_100_factor_4/rep_44 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_1000_size_100_factor_4/rep_45 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_1000_size_100_factor_4/rep_46 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_1000_size_100_factor_4/rep_47 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_1000_size_100_factor_4/rep_48 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_1000_size_100_factor_4/rep_49 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_1000_size_100_factor_4/rep_50 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_1000_size_100_factor_4/rep_51 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_1000_size_100_factor_4/rep_52 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_1000_size_100_factor_4/rep_53 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_1000_size_100_factor_4/rep_54 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_1000_size_100_factor_4/rep_55 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_1000_size_100_factor_4/rep_56 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_1000_size_100_factor_4/rep_57 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_1000_size_100_factor_4/rep_58 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_1000_size_100_factor_4/rep_59 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_1000_size_100_factor_4/rep_60 ;

# wait for all tasks to complete
wait;

# DONE
