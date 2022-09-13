#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_62
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
Rscript src/analysis.R ./sims/tips_200_f_1.5/rep_221 &
Rscript src/analysis.R ./sims/tips_200_f_1.5/rep_222 &
Rscript src/analysis.R ./sims/tips_200_f_1.5/rep_223 &
Rscript src/analysis.R ./sims/tips_200_f_1.5/rep_224 &
Rscript src/analysis.R ./sims/tips_200_f_1.5/rep_225 &
Rscript src/analysis.R ./sims/tips_200_f_1.5/rep_226 &
Rscript src/analysis.R ./sims/tips_200_f_1.5/rep_227 &
Rscript src/analysis.R ./sims/tips_200_f_1.5/rep_228 &
Rscript src/analysis.R ./sims/tips_200_f_1.5/rep_229 &
Rscript src/analysis.R ./sims/tips_200_f_1.5/rep_230 &
Rscript src/analysis.R ./sims/tips_200_f_1.5/rep_231 &
Rscript src/analysis.R ./sims/tips_200_f_1.5/rep_232 &
Rscript src/analysis.R ./sims/tips_200_f_1.5/rep_233 &
Rscript src/analysis.R ./sims/tips_200_f_1.5/rep_234 &
Rscript src/analysis.R ./sims/tips_200_f_1.5/rep_235 &
Rscript src/analysis.R ./sims/tips_200_f_1.5/rep_236 &
Rscript src/analysis.R ./sims/tips_200_f_1.5/rep_237 &
Rscript src/analysis.R ./sims/tips_200_f_1.5/rep_238 &
Rscript src/analysis.R ./sims/tips_200_f_1.5/rep_239 &
Rscript src/analysis.R ./sims/tips_200_f_1.5/rep_240 ;

# wait for all tasks to complete
wait;

# DONE
