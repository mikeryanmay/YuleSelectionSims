#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_439
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
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_1.5/rep_161 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_1.5/rep_162 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_1.5/rep_163 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_1.5/rep_164 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_1.5/rep_165 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_1.5/rep_166 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_1.5/rep_167 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_1.5/rep_168 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_1.5/rep_169 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_1.5/rep_170 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_1.5/rep_171 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_1.5/rep_172 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_1.5/rep_173 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_1.5/rep_174 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_1.5/rep_175 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_1.5/rep_176 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_1.5/rep_177 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_1.5/rep_178 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_1.5/rep_179 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_100_size_1000_factor_1.5/rep_180 ;

# wait for all tasks to complete
wait;

# DONE
