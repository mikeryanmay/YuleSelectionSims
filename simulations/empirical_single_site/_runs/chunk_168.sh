#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_168
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
Rscript src/analysis.R ./sims/tips_400_f_3/rep_241 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_242 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_243 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_244 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_245 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_246 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_247 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_248 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_249 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_250 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_251 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_252 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_253 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_254 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_255 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_256 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_257 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_258 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_259 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_260 ;

# wait for all tasks to complete
wait;

# DONE
