#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_1455
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
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_100/rep_82 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_100/rep_83 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_100/rep_84 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_100/rep_85 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_100/rep_86 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_100/rep_87 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_100/rep_88 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_100/rep_89 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_100/rep_90 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_100/rep_91 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_100/rep_92 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_100/rep_93 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_100/rep_94 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_100/rep_95 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_100/rep_96 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_100/rep_97 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_100/rep_98 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_100/rep_99 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_100/rep_100 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_100/rep_101 ;

# wait for all tasks to complete
wait;

# DONE
