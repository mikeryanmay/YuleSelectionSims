#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_6
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
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_1.5/rep_101 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_1.5/rep_102 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_1.5/rep_103 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_1.5/rep_104 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_1.5/rep_105 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_1.5/rep_106 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_1.5/rep_107 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_1.5/rep_108 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_1.5/rep_109 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_1.5/rep_110 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_1.5/rep_111 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_1.5/rep_112 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_1.5/rep_113 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_1.5/rep_114 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_1.5/rep_115 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_1.5/rep_116 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_1.5/rep_117 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_1.5/rep_118 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_1.5/rep_119 &
Rscript ../../src/multisite_analysis.R ./sims/tips_50_size_1_f_1.5/rep_120 ;

# wait for all tasks to complete
wait;

# DONE
