#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_375
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
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_81 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_82 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_83 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_84 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_85 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_86 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_87 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_88 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_89 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_90 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_91 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_92 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_93 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_94 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_95 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_96 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_97 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_98 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_99 &
Rscript ../../src/ml_analysis.R ./factor/tips_100_size_100_factor_1.5/rep_100 ;

# wait for all tasks to complete
wait;

# DONE
