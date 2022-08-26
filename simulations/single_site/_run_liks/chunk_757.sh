#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_757
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
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_2.5/rep_123 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_2.5/rep_124 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_2.5/rep_125 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_2.5/rep_126 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_2.5/rep_127 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_2.5/rep_128 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_2.5/rep_129 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_2.5/rep_130 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_2.5/rep_131 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_2.5/rep_132 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_2.5/rep_133 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_2.5/rep_134 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_2.5/rep_135 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_2.5/rep_136 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_2.5/rep_137 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_2.5/rep_138 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_2.5/rep_139 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_2.5/rep_140 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_2.5/rep_141 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_2.5/rep_142 ;

# wait for all tasks to complete
wait;

# DONE
