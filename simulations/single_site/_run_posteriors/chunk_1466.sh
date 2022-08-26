#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_1466
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
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_1000/rep_102 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_1000/rep_103 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_1000/rep_104 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_1000/rep_105 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_1000/rep_106 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_1000/rep_107 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_1000/rep_108 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_1000/rep_109 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_1000/rep_110 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_1000/rep_111 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_1000/rep_112 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_1000/rep_113 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_1000/rep_114 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_1000/rep_115 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_1000/rep_116 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_1000/rep_117 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_1000/rep_118 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_1000/rep_119 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_1000/rep_120 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_1_size_1000/rep_121 ;

# wait for all tasks to complete
wait;

# DONE
