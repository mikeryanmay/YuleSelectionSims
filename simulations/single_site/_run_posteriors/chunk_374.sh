#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_374
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
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_62 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_63 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_64 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_65 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_66 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_67 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_68 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_69 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_70 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_71 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_72 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_73 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_74 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_75 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_76 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_77 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_78 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_79 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_80 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_81 ;

# wait for all tasks to complete
wait;

# DONE
