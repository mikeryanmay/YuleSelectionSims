#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_1426
#SBATCH --mail-user=mikeryanmay@gmail.com
#SBATCH --mail-type=FAIL
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --time=168:00:00

# change to user directory
cd /home/$USER/YuleSelectionSims/simulations/single_site/

# load the module
module load R

# run the analyses
Rscript ../../src/ml_analysis.R ./factor/tips_1000_size_1000_factor_3/rep_101 &
Rscript ../../src/ml_analysis.R ./factor/tips_1000_size_1000_factor_3/rep_102 &
Rscript ../../src/ml_analysis.R ./factor/tips_1000_size_1000_factor_3/rep_103 &
Rscript ../../src/ml_analysis.R ./factor/tips_1000_size_1000_factor_3/rep_104 &
Rscript ../../src/ml_analysis.R ./factor/tips_1000_size_1000_factor_3/rep_105 &
Rscript ../../src/ml_analysis.R ./factor/tips_1000_size_1000_factor_3/rep_106 &
Rscript ../../src/ml_analysis.R ./factor/tips_1000_size_1000_factor_3/rep_107 &
Rscript ../../src/ml_analysis.R ./factor/tips_1000_size_1000_factor_3/rep_108 &
Rscript ../../src/ml_analysis.R ./factor/tips_1000_size_1000_factor_3/rep_109 &
Rscript ../../src/ml_analysis.R ./factor/tips_1000_size_1000_factor_3/rep_110 &
Rscript ../../src/ml_analysis.R ./factor/tips_1000_size_1000_factor_3/rep_111 &
Rscript ../../src/ml_analysis.R ./factor/tips_1000_size_1000_factor_3/rep_112 &
Rscript ../../src/ml_analysis.R ./factor/tips_1000_size_1000_factor_3/rep_113 &
Rscript ../../src/ml_analysis.R ./factor/tips_1000_size_1000_factor_3/rep_114 &
Rscript ../../src/ml_analysis.R ./factor/tips_1000_size_1000_factor_3/rep_115 &
Rscript ../../src/ml_analysis.R ./factor/tips_1000_size_1000_factor_3/rep_116 &
Rscript ../../src/ml_analysis.R ./factor/tips_1000_size_1000_factor_3/rep_117 &
Rscript ../../src/ml_analysis.R ./factor/tips_1000_size_1000_factor_3/rep_118 &
Rscript ../../src/ml_analysis.R ./factor/tips_1000_size_1000_factor_3/rep_119 &
Rscript ../../src/ml_analysis.R ./factor/tips_1000_size_1000_factor_3/rep_120 ;

# wait for all tasks to complete
wait;

# DONE
