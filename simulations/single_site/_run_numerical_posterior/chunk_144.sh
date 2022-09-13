#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_144
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
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_50_size_100_factor_2/rep_61 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_50_size_100_factor_2/rep_62 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_50_size_100_factor_2/rep_63 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_50_size_100_factor_2/rep_64 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_50_size_100_factor_2/rep_65 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_50_size_100_factor_2/rep_66 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_50_size_100_factor_2/rep_67 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_50_size_100_factor_2/rep_68 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_50_size_100_factor_2/rep_69 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_50_size_100_factor_2/rep_70 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_50_size_100_factor_2/rep_71 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_50_size_100_factor_2/rep_72 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_50_size_100_factor_2/rep_73 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_50_size_100_factor_2/rep_74 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_50_size_100_factor_2/rep_75 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_50_size_100_factor_2/rep_76 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_50_size_100_factor_2/rep_77 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_50_size_100_factor_2/rep_78 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_50_size_100_factor_2/rep_79 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_50_size_100_factor_2/rep_80 ;

# wait for all tasks to complete
wait;

# DONE
