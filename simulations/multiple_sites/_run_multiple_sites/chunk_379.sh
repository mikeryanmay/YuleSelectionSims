#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_379
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
Rscript ../../src/multisite_analysis.R ./sims/tips_250_size_2_f_2/rep_161 &
Rscript ../../src/multisite_analysis.R ./sims/tips_250_size_2_f_2/rep_162 &
Rscript ../../src/multisite_analysis.R ./sims/tips_250_size_2_f_2/rep_163 &
Rscript ../../src/multisite_analysis.R ./sims/tips_250_size_2_f_2/rep_164 &
Rscript ../../src/multisite_analysis.R ./sims/tips_250_size_2_f_2/rep_165 &
Rscript ../../src/multisite_analysis.R ./sims/tips_250_size_2_f_2/rep_166 &
Rscript ../../src/multisite_analysis.R ./sims/tips_250_size_2_f_2/rep_167 &
Rscript ../../src/multisite_analysis.R ./sims/tips_250_size_2_f_2/rep_168 &
Rscript ../../src/multisite_analysis.R ./sims/tips_250_size_2_f_2/rep_169 &
Rscript ../../src/multisite_analysis.R ./sims/tips_250_size_2_f_2/rep_170 &
Rscript ../../src/multisite_analysis.R ./sims/tips_250_size_2_f_2/rep_171 &
Rscript ../../src/multisite_analysis.R ./sims/tips_250_size_2_f_2/rep_172 &
Rscript ../../src/multisite_analysis.R ./sims/tips_250_size_2_f_2/rep_173 &
Rscript ../../src/multisite_analysis.R ./sims/tips_250_size_2_f_2/rep_174 &
Rscript ../../src/multisite_analysis.R ./sims/tips_250_size_2_f_2/rep_175 &
Rscript ../../src/multisite_analysis.R ./sims/tips_250_size_2_f_2/rep_176 &
Rscript ../../src/multisite_analysis.R ./sims/tips_250_size_2_f_2/rep_177 &
Rscript ../../src/multisite_analysis.R ./sims/tips_250_size_2_f_2/rep_178 &
Rscript ../../src/multisite_analysis.R ./sims/tips_250_size_2_f_2/rep_179 &
Rscript ../../src/multisite_analysis.R ./sims/tips_250_size_2_f_2/rep_180 ;

# wait for all tasks to complete
wait;

# DONE
