#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=NAME_PLACEHOLDER
#SBATCH --mail-user=mikeryanmay@gmail.com
#SBATCH --mail-type=FAIL
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --time=168:00:00

# change to user directory
cd /home/$USER/YuleSelectionSims/simulations/single_site/

# load the module
module load R

# run the analyses
Rscript ../../src/numerical_posterior_analysis.R RUN1 &
Rscript ../../src/numerical_posterior_analysis.R RUN2 &
Rscript ../../src/numerical_posterior_analysis.R RUN3 &
Rscript ../../src/numerical_posterior_analysis.R RUN4 &
Rscript ../../src/numerical_posterior_analysis.R RUN5 &
Rscript ../../src/numerical_posterior_analysis.R RUN6 &
Rscript ../../src/numerical_posterior_analysis.R RUN7 &
Rscript ../../src/numerical_posterior_analysis.R RUN8 &
Rscript ../../src/numerical_posterior_analysis.R RUN9 &
Rscript ../../src/numerical_posterior_analysis.R RUN10 &
Rscript ../../src/numerical_posterior_analysis.R RUN11 &
Rscript ../../src/numerical_posterior_analysis.R RUN12 &
Rscript ../../src/numerical_posterior_analysis.R RUN13 &
Rscript ../../src/numerical_posterior_analysis.R RUN14 &
Rscript ../../src/numerical_posterior_analysis.R RUN15 &
Rscript ../../src/numerical_posterior_analysis.R RUN16 &
Rscript ../../src/numerical_posterior_analysis.R RUN17 &
Rscript ../../src/numerical_posterior_analysis.R RUN18 &
Rscript ../../src/numerical_posterior_analysis.R RUN19 &
Rscript ../../src/numerical_posterior_analysis.R RUN20 ;

# wait for all tasks to complete
wait;

# DONE
