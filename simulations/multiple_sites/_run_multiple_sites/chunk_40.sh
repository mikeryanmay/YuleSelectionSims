#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_40
#SBATCH --mail-user=mikeryanmay@gmail.com
#SBATCH --mail-type=FAIL
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --time=168:00:00

# change to user directory
cd /home/$USER/YuleSelectionSims/simulations/multiple_sites/

# load the module
module load R

# run the analyses
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_3/rep_181 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_3/rep_182 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_3/rep_183 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_3/rep_184 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_3/rep_185 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_3/rep_186 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_3/rep_187 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_3/rep_188 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_3/rep_189 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_3/rep_190 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_3/rep_191 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_3/rep_192 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_3/rep_193 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_3/rep_194 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_3/rep_195 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_3/rep_196 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_3/rep_197 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_3/rep_198 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_3/rep_199 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_3/rep_200 ;

# wait for all tasks to complete
wait;

# DONE
