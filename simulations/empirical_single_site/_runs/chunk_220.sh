#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_220
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
Rscript src/analysis.R ./sims/tips_800_f_2.5/rep_381 &
Rscript src/analysis.R ./sims/tips_800_f_2.5/rep_382 &
Rscript src/analysis.R ./sims/tips_800_f_2.5/rep_383 &
Rscript src/analysis.R ./sims/tips_800_f_2.5/rep_384 &
Rscript src/analysis.R ./sims/tips_800_f_2.5/rep_385 &
Rscript src/analysis.R ./sims/tips_800_f_2.5/rep_386 &
Rscript src/analysis.R ./sims/tips_800_f_2.5/rep_387 &
Rscript src/analysis.R ./sims/tips_800_f_2.5/rep_388 &
Rscript src/analysis.R ./sims/tips_800_f_2.5/rep_389 &
Rscript src/analysis.R ./sims/tips_800_f_2.5/rep_390 &
Rscript src/analysis.R ./sims/tips_800_f_2.5/rep_391 &
Rscript src/analysis.R ./sims/tips_800_f_2.5/rep_392 &
Rscript src/analysis.R ./sims/tips_800_f_2.5/rep_393 &
Rscript src/analysis.R ./sims/tips_800_f_2.5/rep_394 &
Rscript src/analysis.R ./sims/tips_800_f_2.5/rep_395 &
Rscript src/analysis.R ./sims/tips_800_f_2.5/rep_396 &
Rscript src/analysis.R ./sims/tips_800_f_2.5/rep_397 &
Rscript src/analysis.R ./sims/tips_800_f_2.5/rep_398 &
Rscript src/analysis.R ./sims/tips_800_f_2.5/rep_399 &
Rscript src/analysis.R ./sims/tips_800_f_2.5/rep_400 ;

# wait for all tasks to complete
wait;

# DONE
