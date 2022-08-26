#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_1407
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
Rscript ../../src/mcmc_analysis.R ./factor/tips_1000_size_1000_factor_2/rep_122 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_1000_size_1000_factor_2/rep_123 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_1000_size_1000_factor_2/rep_124 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_1000_size_1000_factor_2/rep_125 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_1000_size_1000_factor_2/rep_126 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_1000_size_1000_factor_2/rep_127 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_1000_size_1000_factor_2/rep_128 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_1000_size_1000_factor_2/rep_129 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_1000_size_1000_factor_2/rep_130 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_1000_size_1000_factor_2/rep_131 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_1000_size_1000_factor_2/rep_132 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_1000_size_1000_factor_2/rep_133 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_1000_size_1000_factor_2/rep_134 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_1000_size_1000_factor_2/rep_135 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_1000_size_1000_factor_2/rep_136 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_1000_size_1000_factor_2/rep_137 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_1000_size_1000_factor_2/rep_138 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_1000_size_1000_factor_2/rep_139 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_1000_size_1000_factor_2/rep_140 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_1000_size_1000_factor_2/rep_141 ;

# wait for all tasks to complete
wait;

# DONE
