#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_492
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
Rscript ../../src/mcmc_analysis.R ./factor/tips_250_size_1_factor_1.5/rep_22 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_250_size_1_factor_1.5/rep_23 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_250_size_1_factor_1.5/rep_24 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_250_size_1_factor_1.5/rep_25 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_250_size_1_factor_1.5/rep_26 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_250_size_1_factor_1.5/rep_27 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_250_size_1_factor_1.5/rep_28 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_250_size_1_factor_1.5/rep_29 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_250_size_1_factor_1.5/rep_30 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_250_size_1_factor_1.5/rep_31 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_250_size_1_factor_1.5/rep_32 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_250_size_1_factor_1.5/rep_33 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_250_size_1_factor_1.5/rep_34 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_250_size_1_factor_1.5/rep_35 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_250_size_1_factor_1.5/rep_36 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_250_size_1_factor_1.5/rep_37 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_250_size_1_factor_1.5/rep_38 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_250_size_1_factor_1.5/rep_39 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_250_size_1_factor_1.5/rep_40 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_250_size_1_factor_1.5/rep_41 ;

# wait for all tasks to complete
wait;

# DONE
