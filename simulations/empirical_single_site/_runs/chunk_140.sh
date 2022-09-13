#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_140
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
Rscript src/analysis.R ./sims/tips_400_f_2/rep_281 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_282 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_283 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_284 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_285 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_286 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_287 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_288 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_289 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_290 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_291 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_292 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_293 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_294 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_295 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_296 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_297 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_298 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_299 &
Rscript src/analysis.R ./sims/tips_400_f_2/rep_300 ;

# wait for all tasks to complete
wait;

# DONE
