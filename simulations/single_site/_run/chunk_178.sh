#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_178
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
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_45 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_46 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_47 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_48 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_49 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_5 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_50 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_51 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_52 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_450 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_451 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_452 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_453 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_454 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_455 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_456 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_457 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_458 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_459 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_460 ;

# wait for all tasks to complete
wait;

# DONE
