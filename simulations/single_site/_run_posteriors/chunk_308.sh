#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_308
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
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_10_factor_1/rep_141 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_10_factor_1/rep_142 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_10_factor_1/rep_143 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_10_factor_1/rep_144 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_10_factor_1/rep_145 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_10_factor_1/rep_146 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_10_factor_1/rep_147 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_10_factor_1/rep_148 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_10_factor_1/rep_149 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_10_factor_1/rep_150 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_10_factor_1/rep_151 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_10_factor_1/rep_152 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_10_factor_1/rep_153 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_10_factor_1/rep_154 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_10_factor_1/rep_155 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_10_factor_1/rep_156 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_10_factor_1/rep_157 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_10_factor_1/rep_158 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_10_factor_1/rep_159 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_10_factor_1/rep_160 ;

# wait for all tasks to complete
wait;

# DONE
