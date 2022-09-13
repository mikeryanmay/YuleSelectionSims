#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_60
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
Rscript src/analysis.R ./sims/tips_100_f_3/rep_481 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_482 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_483 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_484 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_485 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_486 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_487 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_488 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_489 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_490 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_491 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_492 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_493 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_494 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_495 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_496 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_497 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_498 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_499 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_500 ;

# wait for all tasks to complete
wait;

# DONE
