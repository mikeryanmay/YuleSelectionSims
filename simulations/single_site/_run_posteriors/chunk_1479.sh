#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_1479
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
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_10/rep_162 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_10/rep_163 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_10/rep_164 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_10/rep_165 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_10/rep_166 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_10/rep_167 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_10/rep_168 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_10/rep_169 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_10/rep_170 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_10/rep_171 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_10/rep_172 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_10/rep_173 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_10/rep_174 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_10/rep_175 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_10/rep_176 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_10/rep_177 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_10/rep_178 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_10/rep_179 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_10/rep_180 &
Rscript ../../src/mcmc_analysis.R ./scenario/scenario_2_size_10/rep_181 ;

# wait for all tasks to complete
wait;

# DONE
