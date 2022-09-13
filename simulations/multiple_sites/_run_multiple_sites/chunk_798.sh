#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_798
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
Rscript ../../src/multisite_analysis.R ./sims/tips_750_size_4_f_3/rep_141 &
Rscript ../../src/multisite_analysis.R ./sims/tips_750_size_4_f_3/rep_142 &
Rscript ../../src/multisite_analysis.R ./sims/tips_750_size_4_f_3/rep_143 &
Rscript ../../src/multisite_analysis.R ./sims/tips_750_size_4_f_3/rep_144 &
Rscript ../../src/multisite_analysis.R ./sims/tips_750_size_4_f_3/rep_145 &
Rscript ../../src/multisite_analysis.R ./sims/tips_750_size_4_f_3/rep_146 &
Rscript ../../src/multisite_analysis.R ./sims/tips_750_size_4_f_3/rep_147 &
Rscript ../../src/multisite_analysis.R ./sims/tips_750_size_4_f_3/rep_148 &
Rscript ../../src/multisite_analysis.R ./sims/tips_750_size_4_f_3/rep_149 &
Rscript ../../src/multisite_analysis.R ./sims/tips_750_size_4_f_3/rep_150 &
Rscript ../../src/multisite_analysis.R ./sims/tips_750_size_4_f_3/rep_151 &
Rscript ../../src/multisite_analysis.R ./sims/tips_750_size_4_f_3/rep_152 &
Rscript ../../src/multisite_analysis.R ./sims/tips_750_size_4_f_3/rep_153 &
Rscript ../../src/multisite_analysis.R ./sims/tips_750_size_4_f_3/rep_154 &
Rscript ../../src/multisite_analysis.R ./sims/tips_750_size_4_f_3/rep_155 &
Rscript ../../src/multisite_analysis.R ./sims/tips_750_size_4_f_3/rep_156 &
Rscript ../../src/multisite_analysis.R ./sims/tips_750_size_4_f_3/rep_157 &
Rscript ../../src/multisite_analysis.R ./sims/tips_750_size_4_f_3/rep_158 &
Rscript ../../src/multisite_analysis.R ./sims/tips_750_size_4_f_3/rep_159 &
Rscript ../../src/multisite_analysis.R ./sims/tips_750_size_4_f_3/rep_160 ;

# wait for all tasks to complete
wait;

# DONE
