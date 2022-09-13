#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_162
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
Rscript src/analysis.R ./sims/tips_400_f_2.5/rep_421 &
Rscript src/analysis.R ./sims/tips_400_f_2.5/rep_422 &
Rscript src/analysis.R ./sims/tips_400_f_2.5/rep_423 &
Rscript src/analysis.R ./sims/tips_400_f_2.5/rep_424 &
Rscript src/analysis.R ./sims/tips_400_f_2.5/rep_425 &
Rscript src/analysis.R ./sims/tips_400_f_2.5/rep_426 &
Rscript src/analysis.R ./sims/tips_400_f_2.5/rep_427 &
Rscript src/analysis.R ./sims/tips_400_f_2.5/rep_428 &
Rscript src/analysis.R ./sims/tips_400_f_2.5/rep_429 &
Rscript src/analysis.R ./sims/tips_400_f_2.5/rep_430 &
Rscript src/analysis.R ./sims/tips_400_f_2.5/rep_431 &
Rscript src/analysis.R ./sims/tips_400_f_2.5/rep_432 &
Rscript src/analysis.R ./sims/tips_400_f_2.5/rep_433 &
Rscript src/analysis.R ./sims/tips_400_f_2.5/rep_434 &
Rscript src/analysis.R ./sims/tips_400_f_2.5/rep_435 &
Rscript src/analysis.R ./sims/tips_400_f_2.5/rep_436 &
Rscript src/analysis.R ./sims/tips_400_f_2.5/rep_437 &
Rscript src/analysis.R ./sims/tips_400_f_2.5/rep_438 &
Rscript src/analysis.R ./sims/tips_400_f_2.5/rep_439 &
Rscript src/analysis.R ./sims/tips_400_f_2.5/rep_440 ;

# wait for all tasks to complete
wait;

# DONE
