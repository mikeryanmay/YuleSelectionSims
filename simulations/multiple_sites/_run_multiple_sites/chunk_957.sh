#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_957
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
Rscript ../../src/multisite_analysis.R ./sims/tips_1000_size_4_f_3/rep_121 &
Rscript ../../src/multisite_analysis.R ./sims/tips_1000_size_4_f_3/rep_122 &
Rscript ../../src/multisite_analysis.R ./sims/tips_1000_size_4_f_3/rep_123 &
Rscript ../../src/multisite_analysis.R ./sims/tips_1000_size_4_f_3/rep_124 &
Rscript ../../src/multisite_analysis.R ./sims/tips_1000_size_4_f_3/rep_125 &
Rscript ../../src/multisite_analysis.R ./sims/tips_1000_size_4_f_3/rep_126 &
Rscript ../../src/multisite_analysis.R ./sims/tips_1000_size_4_f_3/rep_127 &
Rscript ../../src/multisite_analysis.R ./sims/tips_1000_size_4_f_3/rep_128 &
Rscript ../../src/multisite_analysis.R ./sims/tips_1000_size_4_f_3/rep_129 &
Rscript ../../src/multisite_analysis.R ./sims/tips_1000_size_4_f_3/rep_130 &
Rscript ../../src/multisite_analysis.R ./sims/tips_1000_size_4_f_3/rep_131 &
Rscript ../../src/multisite_analysis.R ./sims/tips_1000_size_4_f_3/rep_132 &
Rscript ../../src/multisite_analysis.R ./sims/tips_1000_size_4_f_3/rep_133 &
Rscript ../../src/multisite_analysis.R ./sims/tips_1000_size_4_f_3/rep_134 &
Rscript ../../src/multisite_analysis.R ./sims/tips_1000_size_4_f_3/rep_135 &
Rscript ../../src/multisite_analysis.R ./sims/tips_1000_size_4_f_3/rep_136 &
Rscript ../../src/multisite_analysis.R ./sims/tips_1000_size_4_f_3/rep_137 &
Rscript ../../src/multisite_analysis.R ./sims/tips_1000_size_4_f_3/rep_138 &
Rscript ../../src/multisite_analysis.R ./sims/tips_1000_size_4_f_3/rep_139 &
Rscript ../../src/multisite_analysis.R ./sims/tips_1000_size_4_f_3/rep_140 ;

# wait for all tasks to complete
wait;

# DONE
