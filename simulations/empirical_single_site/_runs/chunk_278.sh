#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_278
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
Rscript src/analysis.R ./sims/tips_1600_f_2.5/rep_341 &
Rscript src/analysis.R ./sims/tips_1600_f_2.5/rep_342 &
Rscript src/analysis.R ./sims/tips_1600_f_2.5/rep_343 &
Rscript src/analysis.R ./sims/tips_1600_f_2.5/rep_344 &
Rscript src/analysis.R ./sims/tips_1600_f_2.5/rep_345 &
Rscript src/analysis.R ./sims/tips_1600_f_2.5/rep_346 &
Rscript src/analysis.R ./sims/tips_1600_f_2.5/rep_347 &
Rscript src/analysis.R ./sims/tips_1600_f_2.5/rep_348 &
Rscript src/analysis.R ./sims/tips_1600_f_2.5/rep_349 &
Rscript src/analysis.R ./sims/tips_1600_f_2.5/rep_350 &
Rscript src/analysis.R ./sims/tips_1600_f_2.5/rep_351 &
Rscript src/analysis.R ./sims/tips_1600_f_2.5/rep_352 &
Rscript src/analysis.R ./sims/tips_1600_f_2.5/rep_353 &
Rscript src/analysis.R ./sims/tips_1600_f_2.5/rep_354 &
Rscript src/analysis.R ./sims/tips_1600_f_2.5/rep_355 &
Rscript src/analysis.R ./sims/tips_1600_f_2.5/rep_356 &
Rscript src/analysis.R ./sims/tips_1600_f_2.5/rep_357 &
Rscript src/analysis.R ./sims/tips_1600_f_2.5/rep_358 &
Rscript src/analysis.R ./sims/tips_1600_f_2.5/rep_359 &
Rscript src/analysis.R ./sims/tips_1600_f_2.5/rep_360 ;

# wait for all tasks to complete
wait;

# DONE
