#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_1345
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
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_100_factor_2/rep_83 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_100_factor_2/rep_84 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_100_factor_2/rep_85 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_100_factor_2/rep_86 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_100_factor_2/rep_87 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_100_factor_2/rep_88 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_100_factor_2/rep_89 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_100_factor_2/rep_90 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_100_factor_2/rep_91 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_100_factor_2/rep_92 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_100_factor_2/rep_93 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_100_factor_2/rep_94 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_100_factor_2/rep_95 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_100_factor_2/rep_96 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_100_factor_2/rep_97 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_100_factor_2/rep_98 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_100_factor_2/rep_99 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_100_factor_2/rep_100 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_100_factor_2/rep_101 &
Rscript ../../src/lik_analysis.R ./factor/tips_1000_size_100_factor_2/rep_102 ;

# wait for all tasks to complete
wait;

# DONE
