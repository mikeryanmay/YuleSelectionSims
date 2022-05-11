#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_180
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
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_81 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_82 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_83 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_84 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_85 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_86 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_87 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_88 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_89 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_810 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_811 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_812 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_813 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_814 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_815 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_816 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_817 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_818 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_819 &
Rscript ../../src/analysis.R ./factor/tips_1000_size_100_factor_2/rep_820 ;

# wait for all tasks to complete
wait;

# DONE
