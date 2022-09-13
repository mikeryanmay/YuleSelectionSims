#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_786
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
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_500_size_10_factor_1/rep_101 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_500_size_10_factor_1/rep_102 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_500_size_10_factor_1/rep_103 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_500_size_10_factor_1/rep_104 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_500_size_10_factor_1/rep_105 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_500_size_10_factor_1/rep_106 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_500_size_10_factor_1/rep_107 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_500_size_10_factor_1/rep_108 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_500_size_10_factor_1/rep_109 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_500_size_10_factor_1/rep_110 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_500_size_10_factor_1/rep_111 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_500_size_10_factor_1/rep_112 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_500_size_10_factor_1/rep_113 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_500_size_10_factor_1/rep_114 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_500_size_10_factor_1/rep_115 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_500_size_10_factor_1/rep_116 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_500_size_10_factor_1/rep_117 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_500_size_10_factor_1/rep_118 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_500_size_10_factor_1/rep_119 &
Rscript ../../src/numerical_posterior_analysis.R ./factor/tips_500_size_10_factor_1/rep_120 ;

# wait for all tasks to complete
wait;

# DONE
