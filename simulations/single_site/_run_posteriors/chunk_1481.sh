#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_1481
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
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_2 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_3 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_4 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_5 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_6 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_7 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_8 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_9 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_10 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_11 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_12 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_13 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_14 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_15 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_16 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_17 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_18 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_19 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_20 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_21 ;

# wait for all tasks to complete
wait;

# DONE
