#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_830
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
Rscript ../../src/mcmc_analysis.R ./factor/tips_500_size_10_factor_3/rep_182 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_500_size_10_factor_3/rep_183 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_500_size_10_factor_3/rep_184 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_500_size_10_factor_3/rep_185 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_500_size_10_factor_3/rep_186 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_500_size_10_factor_3/rep_187 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_500_size_10_factor_3/rep_188 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_500_size_10_factor_3/rep_189 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_500_size_10_factor_3/rep_190 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_500_size_10_factor_3/rep_191 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_500_size_10_factor_3/rep_192 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_500_size_10_factor_3/rep_193 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_500_size_10_factor_3/rep_194 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_500_size_10_factor_3/rep_195 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_500_size_10_factor_3/rep_196 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_500_size_10_factor_3/rep_197 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_500_size_10_factor_3/rep_198 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_500_size_10_factor_3/rep_199 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_500_size_10_factor_3/rep_200 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_500_size_10_factor_4/rep_1 ;

# wait for all tasks to complete
wait;

# DONE
