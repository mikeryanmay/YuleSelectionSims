#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_91
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
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_3_f_2/rep_1 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_3_f_2/rep_2 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_3_f_2/rep_3 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_3_f_2/rep_4 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_3_f_2/rep_5 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_3_f_2/rep_6 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_3_f_2/rep_7 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_3_f_2/rep_8 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_3_f_2/rep_9 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_3_f_2/rep_10 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_3_f_2/rep_11 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_3_f_2/rep_12 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_3_f_2/rep_13 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_3_f_2/rep_14 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_3_f_2/rep_15 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_3_f_2/rep_16 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_3_f_2/rep_17 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_3_f_2/rep_18 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_3_f_2/rep_19 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_3_f_2/rep_20 ;

# wait for all tasks to complete
wait;

# DONE
