#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=factor_2_size_100
#SBATCH --mail-user=mikeryanmay@gmail.edu
#SBATCH --mail-type=ALL
#SBATCH --output=log/job_%a.out
#SBATCH --error=log/job_%a.out
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --time=72:00:00

# change to user directory
cd /home/$USER/YuleSelectionSims/simulations/single_site/factor_2_size_100/

# load the module
module load R

# run the analyses
parallel -j $SLURM_CPUS_ON_NODE "Rscript ../../../src/analysis.R {%}" ::: {1..100}
