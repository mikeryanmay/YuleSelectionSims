#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_246
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
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_301 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_302 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_303 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_304 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_305 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_306 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_307 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_308 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_309 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_310 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_311 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_312 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_313 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_314 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_315 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_316 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_317 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_318 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_319 &
Rscript src/analysis.R ./sims/tips_1600_f_1.5/rep_320 ;

# wait for all tasks to complete
wait;

# DONE
