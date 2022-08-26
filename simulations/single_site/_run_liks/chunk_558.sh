#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_558
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
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_10_factor_1.5/rep_143 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_10_factor_1.5/rep_144 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_10_factor_1.5/rep_145 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_10_factor_1.5/rep_146 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_10_factor_1.5/rep_147 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_10_factor_1.5/rep_148 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_10_factor_1.5/rep_149 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_10_factor_1.5/rep_150 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_10_factor_1.5/rep_151 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_10_factor_1.5/rep_152 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_10_factor_1.5/rep_153 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_10_factor_1.5/rep_154 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_10_factor_1.5/rep_155 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_10_factor_1.5/rep_156 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_10_factor_1.5/rep_157 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_10_factor_1.5/rep_158 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_10_factor_1.5/rep_159 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_10_factor_1.5/rep_160 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_10_factor_1.5/rep_161 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_10_factor_1.5/rep_162 ;

# wait for all tasks to complete
wait;

# DONE
