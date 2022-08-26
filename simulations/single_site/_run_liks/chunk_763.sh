#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_763
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
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_3/rep_43 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_3/rep_44 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_3/rep_45 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_3/rep_46 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_3/rep_47 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_3/rep_48 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_3/rep_49 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_3/rep_50 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_3/rep_51 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_3/rep_52 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_3/rep_53 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_3/rep_54 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_3/rep_55 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_3/rep_56 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_3/rep_57 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_3/rep_58 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_3/rep_59 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_3/rep_60 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_3/rep_61 &
Rscript ../../src/lik_analysis.R ./factor/tips_500_size_1_factor_3/rep_62 ;

# wait for all tasks to complete
wait;

# DONE
