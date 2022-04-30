#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=factor_1_size_10
#SBATCH --mail-user=mikeryanmay@gmail.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --time=72:00:00

# change to user directory
cd /home/$USER/YuleSelectionSims/simulations/single_site/factor_1_size_10/

# load the module
module load R

# run your code
parallel -j $SLURM_CPUS_ON_NODE "Rscript ../../../src/analysis.R {%}" ::: {1..100}
