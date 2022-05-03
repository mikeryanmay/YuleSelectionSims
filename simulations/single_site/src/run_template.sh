#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=NAME_PLACEHOLDER
#SBATCH --mail-user=mikeryanmay@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --output=log/job_%a.out
#SBATCH --error=log/job_%a.out
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --time=12:00:00

# change to user directory
cd /home/$USER/YuleSelectionSims/simulations/single_site/DIR_PLACEHOLDER/

# load the module
module load R

# run the analyses
Rscript ../../../src/analysis.R RUN1 &
Rscript ../../../src/analysis.R RUN2 &
Rscript ../../../src/analysis.R RUN3 &
Rscript ../../../src/analysis.R RUN4 &
Rscript ../../../src/analysis.R RUN5 &
Rscript ../../../src/analysis.R RUN6 &
Rscript ../../../src/analysis.R RUN7 &
Rscript ../../../src/analysis.R RUN8 &
Rscript ../../../src/analysis.R RUN9 &
Rscript ../../../src/analysis.R RUN10 &
Rscript ../../../src/analysis.R RUN11 &
Rscript ../../../src/analysis.R RUN12 &
Rscript ../../../src/analysis.R RUN13 &
Rscript ../../../src/analysis.R RUN14 &
Rscript ../../../src/analysis.R RUN15 &
Rscript ../../../src/analysis.R RUN16 &
Rscript ../../../src/analysis.R RUN17 &
Rscript ../../../src/analysis.R RUN18 &
Rscript ../../../src/analysis.R RUN19 &
Rscript ../../../src/analysis.R RUN20 ;

# wait for all tasks to complete
wait;
