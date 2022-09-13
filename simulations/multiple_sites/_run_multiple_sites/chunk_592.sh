#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_592
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
Rscript ../../src/multisite_analysis.R ./sims/tips_500_size_3_f_3/rep_21 &
Rscript ../../src/multisite_analysis.R ./sims/tips_500_size_3_f_3/rep_22 &
Rscript ../../src/multisite_analysis.R ./sims/tips_500_size_3_f_3/rep_23 &
Rscript ../../src/multisite_analysis.R ./sims/tips_500_size_3_f_3/rep_24 &
Rscript ../../src/multisite_analysis.R ./sims/tips_500_size_3_f_3/rep_25 &
Rscript ../../src/multisite_analysis.R ./sims/tips_500_size_3_f_3/rep_26 &
Rscript ../../src/multisite_analysis.R ./sims/tips_500_size_3_f_3/rep_27 &
Rscript ../../src/multisite_analysis.R ./sims/tips_500_size_3_f_3/rep_28 &
Rscript ../../src/multisite_analysis.R ./sims/tips_500_size_3_f_3/rep_29 &
Rscript ../../src/multisite_analysis.R ./sims/tips_500_size_3_f_3/rep_30 &
Rscript ../../src/multisite_analysis.R ./sims/tips_500_size_3_f_3/rep_31 &
Rscript ../../src/multisite_analysis.R ./sims/tips_500_size_3_f_3/rep_32 &
Rscript ../../src/multisite_analysis.R ./sims/tips_500_size_3_f_3/rep_33 &
Rscript ../../src/multisite_analysis.R ./sims/tips_500_size_3_f_3/rep_34 &
Rscript ../../src/multisite_analysis.R ./sims/tips_500_size_3_f_3/rep_35 &
Rscript ../../src/multisite_analysis.R ./sims/tips_500_size_3_f_3/rep_36 &
Rscript ../../src/multisite_analysis.R ./sims/tips_500_size_3_f_3/rep_37 &
Rscript ../../src/multisite_analysis.R ./sims/tips_500_size_3_f_3/rep_38 &
Rscript ../../src/multisite_analysis.R ./sims/tips_500_size_3_f_3/rep_39 &
Rscript ../../src/multisite_analysis.R ./sims/tips_500_size_3_f_3/rep_40 ;

# wait for all tasks to complete
wait;

# DONE
