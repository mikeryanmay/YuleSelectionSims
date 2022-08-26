#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_225
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
Rscript ../../src/mcmc_analysis.R ./factor/tips_50_size_1000_factor_3/rep_81 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_50_size_1000_factor_3/rep_82 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_50_size_1000_factor_3/rep_83 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_50_size_1000_factor_3/rep_84 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_50_size_1000_factor_3/rep_85 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_50_size_1000_factor_3/rep_86 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_50_size_1000_factor_3/rep_87 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_50_size_1000_factor_3/rep_88 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_50_size_1000_factor_3/rep_89 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_50_size_1000_factor_3/rep_90 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_50_size_1000_factor_3/rep_91 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_50_size_1000_factor_3/rep_92 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_50_size_1000_factor_3/rep_93 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_50_size_1000_factor_3/rep_94 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_50_size_1000_factor_3/rep_95 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_50_size_1000_factor_3/rep_96 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_50_size_1000_factor_3/rep_97 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_50_size_1000_factor_3/rep_98 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_50_size_1000_factor_3/rep_99 &
Rscript ../../src/mcmc_analysis.R ./factor/tips_50_size_1000_factor_3/rep_100 ;

# wait for all tasks to complete
wait;

# DONE
