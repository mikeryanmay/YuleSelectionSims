#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_254
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
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_461 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_462 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_463 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_464 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_465 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_466 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_467 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_468 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_469 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_470 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_471 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_472 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_473 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_474 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_475 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_476 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_477 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_478 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_479 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_480 ;

# wait for all tasks to complete
wait;

# DONE
