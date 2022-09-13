#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_26
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
Rscript src/analysis.R ./sims/tips_100_f_2/rep_401 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_402 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_403 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_404 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_405 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_406 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_407 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_408 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_409 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_410 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_411 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_412 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_413 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_414 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_415 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_416 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_417 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_418 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_419 &
Rscript src/analysis.R ./sims/tips_100_f_2/rep_420 ;

# wait for all tasks to complete
wait;

# DONE
