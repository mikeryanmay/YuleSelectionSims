#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_147
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
Rscript ../../src/analysis.R ./factor/tips_1000_size_10_factor_3/rep_27 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_10_factor_3/rep_28 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_10_factor_3/rep_29 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_10_factor_3/rep_3 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_10_factor_3/rep_30 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_10_factor_3/rep_31 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_10_factor_3/rep_32 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_10_factor_3/rep_33 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_10_factor_3/rep_34 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_10_factor_3/rep_270 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_10_factor_3/rep_271 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_10_factor_3/rep_272 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_10_factor_3/rep_273 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_10_factor_3/rep_274 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_10_factor_3/rep_275 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_10_factor_3/rep_276 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_10_factor_3/rep_277 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_10_factor_3/rep_278 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_10_factor_3/rep_279 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_10_factor_3/rep_280 ;

# wait for all tasks to complete
wait;

# DONE
