#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_53
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
Rscript ../../src/analysis.R ./factor/tips_100_size_100_factor_2/rep_135 &
Rscript ../../src/analysis.R ./factor/tips_100_size_100_factor_2/rep_136 &
Rscript ../../src/analysis.R ./factor/tips_100_size_100_factor_2/rep_137 &
Rscript ../../src/analysis.R ./factor/tips_100_size_100_factor_2/rep_138 &
Rscript ../../src/analysis.R ./factor/tips_100_size_100_factor_2/rep_139 &
Rscript ../../src/analysis.R ./factor/tips_100_size_100_factor_2/rep_14 &
Rscript ../../src/analysis.R ./factor/tips_100_size_100_factor_2/rep_140 &
Rscript ../../src/analysis.R ./factor/tips_100_size_100_factor_2/rep_141 &
Rscript ../../src/analysis.R ./factor/tips_100_size_100_factor_2/rep_142 &
Rscript ../../src/analysis.R ./factor/tips_100_size_100_factor_2/rep_1350 &
Rscript ../../src/analysis.R ./factor/tips_100_size_100_factor_2/rep_1351 &
Rscript ../../src/analysis.R ./factor/tips_100_size_100_factor_2/rep_1352 &
Rscript ../../src/analysis.R ./factor/tips_100_size_100_factor_2/rep_1353 &
Rscript ../../src/analysis.R ./factor/tips_100_size_100_factor_2/rep_1354 &
Rscript ../../src/analysis.R ./factor/tips_100_size_100_factor_2/rep_1355 &
Rscript ../../src/analysis.R ./factor/tips_100_size_100_factor_2/rep_1356 &
Rscript ../../src/analysis.R ./factor/tips_100_size_100_factor_2/rep_1357 &
Rscript ../../src/analysis.R ./factor/tips_100_size_100_factor_2/rep_1358 &
Rscript ../../src/analysis.R ./factor/tips_100_size_100_factor_2/rep_1359 &
Rscript ../../src/analysis.R ./factor/tips_100_size_100_factor_2/rep_1360 ;

# wait for all tasks to complete
wait;

# DONE
