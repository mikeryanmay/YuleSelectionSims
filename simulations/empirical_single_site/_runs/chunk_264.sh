#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_264
#SBATCH --mail-user=mikeryanmay@gmail.com
#SBATCH --mail-type=FAIL
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --time=168:00:00

# change to user directory
cd /home/$USER/YuleSelectionSims/simulations/empirical_single_site/

# load the module
module load R

# run the analyses
Rscript src/analysis.R ./sims/tips_1600_f_2/rep_361 &
Rscript src/analysis.R ./sims/tips_1600_f_2/rep_362 &
Rscript src/analysis.R ./sims/tips_1600_f_2/rep_363 &
Rscript src/analysis.R ./sims/tips_1600_f_2/rep_364 &
Rscript src/analysis.R ./sims/tips_1600_f_2/rep_365 &
Rscript src/analysis.R ./sims/tips_1600_f_2/rep_366 &
Rscript src/analysis.R ./sims/tips_1600_f_2/rep_367 &
Rscript src/analysis.R ./sims/tips_1600_f_2/rep_368 &
Rscript src/analysis.R ./sims/tips_1600_f_2/rep_369 &
Rscript src/analysis.R ./sims/tips_1600_f_2/rep_370 &
Rscript src/analysis.R ./sims/tips_1600_f_2/rep_371 &
Rscript src/analysis.R ./sims/tips_1600_f_2/rep_372 &
Rscript src/analysis.R ./sims/tips_1600_f_2/rep_373 &
Rscript src/analysis.R ./sims/tips_1600_f_2/rep_374 &
Rscript src/analysis.R ./sims/tips_1600_f_2/rep_375 &
Rscript src/analysis.R ./sims/tips_1600_f_2/rep_376 &
Rscript src/analysis.R ./sims/tips_1600_f_2/rep_377 &
Rscript src/analysis.R ./sims/tips_1600_f_2/rep_378 &
Rscript src/analysis.R ./sims/tips_1600_f_2/rep_379 &
Rscript src/analysis.R ./sims/tips_1600_f_2/rep_380 ;

# wait for all tasks to complete
wait;

# DONE
