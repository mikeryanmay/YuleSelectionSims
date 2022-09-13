#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_448
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
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_2/rep_141 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_2/rep_142 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_2/rep_143 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_2/rep_144 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_2/rep_145 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_2/rep_146 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_2/rep_147 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_2/rep_148 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_2/rep_149 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_2/rep_150 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_2/rep_151 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_2/rep_152 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_2/rep_153 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_2/rep_154 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_2/rep_155 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_2/rep_156 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_2/rep_157 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_2/rep_158 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_2/rep_159 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_2/rep_160 ;

# wait for all tasks to complete
wait;

# DONE
