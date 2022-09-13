#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_28
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
Rscript src/analysis.R ./sims/tips_100_f_2/rep_441 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_442 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_443 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_444 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_445 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_446 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_447 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_448 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_449 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_450 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_451 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_452 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_453 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_454 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_455 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_456 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_457 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_458 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_459 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_460 ;

# wait for all tasks to complete
wait;

# DONE
