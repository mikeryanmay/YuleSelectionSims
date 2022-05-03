#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=factor_2_size_100_set_2
#SBATCH --mail-user=mikeryanmay@gmail.com
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --time=12:00:00

# change to user directory
cd /home/$USER/YuleSelectionSims/simulations/single_site/factor_2_size_100/

# load the module
module load R

# run the analyses
Rscript ../../../src/analysis.R 21 &
Rscript ../../../src/analysis.R 22 &
Rscript ../../../src/analysis.R 23 &
Rscript ../../../src/analysis.R 24 &
Rscript ../../../src/analysis.R 25 &
Rscript ../../../src/analysis.R 26 &
Rscript ../../../src/analysis.R 27 &
Rscript ../../../src/analysis.R 28 &
Rscript ../../../src/analysis.R 29 &
Rscript ../../../src/analysis.R 30 &
Rscript ../../../src/analysis.R 31 &
Rscript ../../../src/analysis.R 32 &
Rscript ../../../src/analysis.R 33 &
Rscript ../../../src/analysis.R 34 &
Rscript ../../../src/analysis.R 35 &
Rscript ../../../src/analysis.R 36 &
Rscript ../../../src/analysis.R 37 &
Rscript ../../../src/analysis.R 38 &
Rscript ../../../src/analysis.R 39 &
Rscript ../../../src/analysis.R 40 ;

# wait for all tasks to complete
wait;

# move log file
mkdir -p log
mv "slurm-${SLURM_JOB_ID}.out" "log/slurm-${SLURM_JOB_ID}.out"
