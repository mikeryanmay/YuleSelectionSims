#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_536
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
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_1_factor_4/rep_103 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_1_factor_4/rep_104 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_1_factor_4/rep_105 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_1_factor_4/rep_106 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_1_factor_4/rep_107 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_1_factor_4/rep_108 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_1_factor_4/rep_109 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_1_factor_4/rep_110 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_1_factor_4/rep_111 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_1_factor_4/rep_112 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_1_factor_4/rep_113 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_1_factor_4/rep_114 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_1_factor_4/rep_115 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_1_factor_4/rep_116 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_1_factor_4/rep_117 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_1_factor_4/rep_118 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_1_factor_4/rep_119 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_1_factor_4/rep_120 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_1_factor_4/rep_121 &
Rscript ../../src/lik_analysis.R ./factor/tips_250_size_1_factor_4/rep_122 ;

# wait for all tasks to complete
wait;

# DONE
