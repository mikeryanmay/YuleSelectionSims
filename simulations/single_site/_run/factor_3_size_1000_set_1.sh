#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=factor_3_size_1000_set_1
#SBATCH --mail-user=mikeryanmay@gmail.com
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --time=12:00:00

# change to user directory
cd /home/$USER/YuleSelectionSims/simulations/single_site/factor_3_size_1000/

# load the module
module load R

# run the analyses
Rscript ../../../src/analysis.R 1 &
Rscript ../../../src/analysis.R 2 &
Rscript ../../../src/analysis.R 3 &
Rscript ../../../src/analysis.R 4 &
Rscript ../../../src/analysis.R 5 &
Rscript ../../../src/analysis.R 6 &
Rscript ../../../src/analysis.R 7 &
Rscript ../../../src/analysis.R 8 &
Rscript ../../../src/analysis.R 9 &
Rscript ../../../src/analysis.R 10 &
Rscript ../../../src/analysis.R 11 &
Rscript ../../../src/analysis.R 12 &
Rscript ../../../src/analysis.R 13 &
Rscript ../../../src/analysis.R 14 &
Rscript ../../../src/analysis.R 15 &
Rscript ../../../src/analysis.R 16 &
Rscript ../../../src/analysis.R 17 &
Rscript ../../../src/analysis.R 18 &
Rscript ../../../src/analysis.R 19 &
Rscript ../../../src/analysis.R 20 ;

# wait for all tasks to complete
wait;

# move log file
mkdir -p log
mv "slurm-${SLURM_JOB_ID}.out" "log/slurm-${SLURM_JOB_ID}.out"
