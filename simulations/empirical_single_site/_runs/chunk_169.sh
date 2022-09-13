#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_169
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
Rscript src/analysis.R ./sims/tips_400_f_3/rep_261 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_262 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_263 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_264 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_265 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_266 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_267 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_268 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_269 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_270 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_271 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_272 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_273 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_274 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_275 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_276 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_277 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_278 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_279 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_280 ;

# wait for all tasks to complete
wait;

# DONE
