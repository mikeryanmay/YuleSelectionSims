#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_274
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
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_1_factor_2.5/rep_61 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_1_factor_2.5/rep_62 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_1_factor_2.5/rep_63 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_1_factor_2.5/rep_64 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_1_factor_2.5/rep_65 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_1_factor_2.5/rep_66 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_1_factor_2.5/rep_67 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_1_factor_2.5/rep_68 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_1_factor_2.5/rep_69 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_1_factor_2.5/rep_70 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_1_factor_2.5/rep_71 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_1_factor_2.5/rep_72 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_1_factor_2.5/rep_73 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_1_factor_2.5/rep_74 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_1_factor_2.5/rep_75 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_1_factor_2.5/rep_76 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_1_factor_2.5/rep_77 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_1_factor_2.5/rep_78 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_1_factor_2.5/rep_79 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_1_factor_2.5/rep_80 ;

# wait for all tasks to complete
wait;

# DONE
