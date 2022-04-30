#!/bin/bash
#SBATCH --partition=low2
#SBATCH --account=brannalagrp
#SBATCH --job-name=factor_1_size_10
#SBATCH --mail-user=mikeryanmay@gmail.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH -t 24:00:00

# change to user directory
cd /home/$USER/YuleSelectionSims/simulations/single_site/factor_1_size_10/

# load the module
module load R

# make the output directory
mkdir -p logs

# run your code
parallel -j $SLURM_CPUS_ON_NODE "Rscript ../../../src/analysis.R {%} > 'logs/rep_{}.txt'" ::: {1..100}

# move log file
mkdir -p log
mv "slurm-${SLURM_JOB_ID}.out" "log/slurm-${SLURM_JOB_ID}.out"
