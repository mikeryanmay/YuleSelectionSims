#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=factor_1_size_100_set_5
#SBATCH --mail-user=mikeryanmay@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --output=log/job_%a.out
#SBATCH --error=log/job_%a.out
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --time=12:00:00

# change to user directory
cd /home/$USER/YuleSelectionSims/simulations/single_site/factor_1_size_100/

# load the module
module load R

# run the analyses
Rscript ../../../src/analysis.R 81 &
Rscript ../../../src/analysis.R 82 &
Rscript ../../../src/analysis.R 83 &
Rscript ../../../src/analysis.R 84 &
Rscript ../../../src/analysis.R 85 &
Rscript ../../../src/analysis.R 86 &
Rscript ../../../src/analysis.R 87 &
Rscript ../../../src/analysis.R 88 &
Rscript ../../../src/analysis.R 89 &
Rscript ../../../src/analysis.R 90 &
Rscript ../../../src/analysis.R 91 &
Rscript ../../../src/analysis.R 92 &
Rscript ../../../src/analysis.R 93 &
Rscript ../../../src/analysis.R 94 &
Rscript ../../../src/analysis.R 95 &
Rscript ../../../src/analysis.R 96 &
Rscript ../../../src/analysis.R 97 &
Rscript ../../../src/analysis.R 98 &
Rscript ../../../src/analysis.R 99 &
Rscript ../../../src/analysis.R 100 ;

# wait for all tasks to complete
wait;
