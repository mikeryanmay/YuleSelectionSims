#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=factor_1_size_1000_set_3
#SBATCH --mail-user=mikeryanmay@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --output=log/job_%a.out
#SBATCH --error=log/job_%a.out
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --time=12:00:00

# change to user directory
cd /home/$USER/YuleSelectionSims/simulations/single_site/factor_1_size_1000/

# load the module
module load R

# run the analyses
Rscript ../../../src/analysis.R 41 &
Rscript ../../../src/analysis.R 42 &
Rscript ../../../src/analysis.R 43 &
Rscript ../../../src/analysis.R 44 &
Rscript ../../../src/analysis.R 45 &
Rscript ../../../src/analysis.R 46 &
Rscript ../../../src/analysis.R 47 &
Rscript ../../../src/analysis.R 48 &
Rscript ../../../src/analysis.R 49 &
Rscript ../../../src/analysis.R 50 &
Rscript ../../../src/analysis.R 51 &
Rscript ../../../src/analysis.R 52 &
Rscript ../../../src/analysis.R 53 &
Rscript ../../../src/analysis.R 54 &
Rscript ../../../src/analysis.R 55 &
Rscript ../../../src/analysis.R 56 &
Rscript ../../../src/analysis.R 57 &
Rscript ../../../src/analysis.R 58 &
Rscript ../../../src/analysis.R 59 &
Rscript ../../../src/analysis.R 60 ;

# wait for all tasks to complete
wait;
