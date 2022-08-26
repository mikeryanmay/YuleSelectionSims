#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_1090
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
Rscript ../../src/lik_analysis.R ./factor/tips_750_size_100_factor_1/rep_183 &
Rscript ../../src/lik_analysis.R ./factor/tips_750_size_100_factor_1/rep_184 &
Rscript ../../src/lik_analysis.R ./factor/tips_750_size_100_factor_1/rep_185 &
Rscript ../../src/lik_analysis.R ./factor/tips_750_size_100_factor_1/rep_186 &
Rscript ../../src/lik_analysis.R ./factor/tips_750_size_100_factor_1/rep_187 &
Rscript ../../src/lik_analysis.R ./factor/tips_750_size_100_factor_1/rep_188 &
Rscript ../../src/lik_analysis.R ./factor/tips_750_size_100_factor_1/rep_189 &
Rscript ../../src/lik_analysis.R ./factor/tips_750_size_100_factor_1/rep_190 &
Rscript ../../src/lik_analysis.R ./factor/tips_750_size_100_factor_1/rep_191 &
Rscript ../../src/lik_analysis.R ./factor/tips_750_size_100_factor_1/rep_192 &
Rscript ../../src/lik_analysis.R ./factor/tips_750_size_100_factor_1/rep_193 &
Rscript ../../src/lik_analysis.R ./factor/tips_750_size_100_factor_1/rep_194 &
Rscript ../../src/lik_analysis.R ./factor/tips_750_size_100_factor_1/rep_195 &
Rscript ../../src/lik_analysis.R ./factor/tips_750_size_100_factor_1/rep_196 &
Rscript ../../src/lik_analysis.R ./factor/tips_750_size_100_factor_1/rep_197 &
Rscript ../../src/lik_analysis.R ./factor/tips_750_size_100_factor_1/rep_198 &
Rscript ../../src/lik_analysis.R ./factor/tips_750_size_100_factor_1/rep_199 &
Rscript ../../src/lik_analysis.R ./factor/tips_750_size_100_factor_1/rep_200 &
Rscript ../../src/lik_analysis.R ./factor/tips_750_size_100_factor_1.5/rep_1 &
Rscript ../../src/lik_analysis.R ./factor/tips_750_size_100_factor_1.5/rep_2 ;

# wait for all tasks to complete
wait;

# DONE
