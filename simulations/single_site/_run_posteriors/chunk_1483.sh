#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_1483
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
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_42 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_43 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_44 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_45 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_46 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_47 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_48 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_49 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_50 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_51 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_52 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_53 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_54 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_55 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_56 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_57 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_58 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_59 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_60 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_100/rep_61 ;

# wait for all tasks to complete
wait;

# DONE
