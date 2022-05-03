#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=scenario_3_size_1000_set_4
#SBATCH --mail-user=mikeryanmay@gmail.com
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --time=12:00:00

# change to user directory
cd /home/$USER/YuleSelectionSims/simulations/single_site/scenario_3_size_1000/

# load the module
module load R

# run the analyses
Rscript ../../../src/analysis.R 61 &
Rscript ../../../src/analysis.R 62 &
Rscript ../../../src/analysis.R 63 &
Rscript ../../../src/analysis.R 64 &
Rscript ../../../src/analysis.R 65 &
Rscript ../../../src/analysis.R 66 &
Rscript ../../../src/analysis.R 67 &
Rscript ../../../src/analysis.R 68 &
Rscript ../../../src/analysis.R 69 &
Rscript ../../../src/analysis.R 70 &
Rscript ../../../src/analysis.R 71 &
Rscript ../../../src/analysis.R 72 &
Rscript ../../../src/analysis.R 73 &
Rscript ../../../src/analysis.R 74 &
Rscript ../../../src/analysis.R 75 &
Rscript ../../../src/analysis.R 76 &
Rscript ../../../src/analysis.R 77 &
Rscript ../../../src/analysis.R 78 &
Rscript ../../../src/analysis.R 79 &
Rscript ../../../src/analysis.R 80 ;

# wait for all tasks to complete
wait;

# move log file
mkdir -p log
mv "slurm-${SLURM_JOB_ID}.out" "log/slurm-${SLURM_JOB_ID}.out"
