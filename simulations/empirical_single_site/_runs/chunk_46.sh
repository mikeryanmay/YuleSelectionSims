#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_46
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
Rscript src/analysis.R ./sims/tips_100_f_3/rep_201 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_202 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_203 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_204 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_205 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_206 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_207 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_208 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_209 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_210 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_211 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_212 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_213 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_214 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_215 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_216 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_217 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_218 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_219 &
Rscript src/analysis.R ./sims/tips_100_f_3/rep_220 ;

# wait for all tasks to complete
wait;

# DONE
