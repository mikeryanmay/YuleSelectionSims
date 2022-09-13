#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_142
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
Rscript src/analysis.R ./sims/tips_400_f_2/rep_321 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_322 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_323 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_324 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_325 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_326 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_327 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_328 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_329 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_330 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_331 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_332 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_333 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_334 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_335 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_336 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_337 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_338 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_339 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_340 ;

# wait for all tasks to complete
wait;

# DONE
