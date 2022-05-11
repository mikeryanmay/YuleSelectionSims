#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_32
#SBATCH --mail-user=mikeryanmay@gmail.com
#SBATCH --mail-type=FAIL
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --time=72:00:00

# change to user directory
cd /home/$USER/YuleSelectionSims/simulations/single_site/

# load the module
module load R

# run the analyses
Rscript ../../src/analysis.R ./factor/tips_100_size_10_factor_4/rep_117 &
Rscript ../../src/analysis.R ./factor/tips_100_size_10_factor_4/rep_118 &
Rscript ../../src/analysis.R ./factor/tips_100_size_10_factor_4/rep_119 &
Rscript ../../src/analysis.R ./factor/tips_100_size_10_factor_4/rep_12 &
Rscript ../../src/analysis.R ./factor/tips_100_size_10_factor_4/rep_120 &
Rscript ../../src/analysis.R ./factor/tips_100_size_10_factor_4/rep_121 &
Rscript ../../src/analysis.R ./factor/tips_100_size_10_factor_4/rep_122 &
Rscript ../../src/analysis.R ./factor/tips_100_size_10_factor_4/rep_123 &
Rscript ../../src/analysis.R ./factor/tips_100_size_10_factor_4/rep_124 &
Rscript ../../src/analysis.R ./factor/tips_100_size_10_factor_4/rep_1170 &
Rscript ../../src/analysis.R ./factor/tips_100_size_10_factor_4/rep_1171 &
Rscript ../../src/analysis.R ./factor/tips_100_size_10_factor_4/rep_1172 &
Rscript ../../src/analysis.R ./factor/tips_100_size_10_factor_4/rep_1173 &
Rscript ../../src/analysis.R ./factor/tips_100_size_10_factor_4/rep_1174 &
Rscript ../../src/analysis.R ./factor/tips_100_size_10_factor_4/rep_1175 &
Rscript ../../src/analysis.R ./factor/tips_100_size_10_factor_4/rep_1176 &
Rscript ../../src/analysis.R ./factor/tips_100_size_10_factor_4/rep_1177 &
Rscript ../../src/analysis.R ./factor/tips_100_size_10_factor_4/rep_1178 &
Rscript ../../src/analysis.R ./factor/tips_100_size_10_factor_4/rep_1179 &
Rscript ../../src/analysis.R ./factor/tips_100_size_10_factor_4/rep_1180 ;

# wait for all tasks to complete
wait;

# DONE
