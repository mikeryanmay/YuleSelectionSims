#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_1519
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
Rscript ../../src/lik_analysis.R ./scenario/scenario_3_size_100/rep_163 &
Rscript ../../src/lik_analysis.R ./scenario/scenario_3_size_100/rep_164 &
Rscript ../../src/lik_analysis.R ./scenario/scenario_3_size_100/rep_165 &
Rscript ../../src/lik_analysis.R ./scenario/scenario_3_size_100/rep_166 &
Rscript ../../src/lik_analysis.R ./scenario/scenario_3_size_100/rep_167 &
Rscript ../../src/lik_analysis.R ./scenario/scenario_3_size_100/rep_168 &
Rscript ../../src/lik_analysis.R ./scenario/scenario_3_size_100/rep_169 &
Rscript ../../src/lik_analysis.R ./scenario/scenario_3_size_100/rep_170 &
Rscript ../../src/lik_analysis.R ./scenario/scenario_3_size_100/rep_171 &
Rscript ../../src/lik_analysis.R ./scenario/scenario_3_size_100/rep_172 &
Rscript ../../src/lik_analysis.R ./scenario/scenario_3_size_100/rep_173 &
Rscript ../../src/lik_analysis.R ./scenario/scenario_3_size_100/rep_174 &
Rscript ../../src/lik_analysis.R ./scenario/scenario_3_size_100/rep_175 &
Rscript ../../src/lik_analysis.R ./scenario/scenario_3_size_100/rep_176 &
Rscript ../../src/lik_analysis.R ./scenario/scenario_3_size_100/rep_177 &
Rscript ../../src/lik_analysis.R ./scenario/scenario_3_size_100/rep_178 &
Rscript ../../src/lik_analysis.R ./scenario/scenario_3_size_100/rep_179 &
Rscript ../../src/lik_analysis.R ./scenario/scenario_3_size_100/rep_180 &
Rscript ../../src/lik_analysis.R ./scenario/scenario_3_size_100/rep_181 &
Rscript ../../src/lik_analysis.R ./scenario/scenario_3_size_100/rep_182 ;

# wait for all tasks to complete
wait;

# DONE
