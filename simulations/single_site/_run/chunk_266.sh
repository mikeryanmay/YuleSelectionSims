#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_266
#SBATCH --mail-user=mikeryanmay@gmail.com
#SBATCH --mail-type=FAIL
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --time=72:00:00

# change to user directory
cd /home/$USER/YuleSelectionSims/simulations/single_site/

# load the module
module load R

# run the analyses
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_3/rep_19 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_3/rep_190 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_3/rep_191 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_3/rep_192 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_3/rep_193 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_3/rep_194 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_3/rep_195 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_3/rep_196 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_3/rep_197 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_3/rep_190 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_3/rep_191 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_3/rep_192 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_3/rep_193 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_3/rep_194 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_3/rep_195 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_3/rep_196 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_3/rep_197 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_3/rep_198 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_3/rep_199 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_3/rep_1900 ;

# wait for all tasks to complete
wait;

# DONE
