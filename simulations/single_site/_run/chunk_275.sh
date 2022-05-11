#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_275
#SBATCH --mail-user=mikeryanmay@gmail.com
#SBATCH --mail-type=FAIL
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --time=72:00:00

# change to user directory
cd /home/$USER/YuleSelectionSims/simulations/single_site/

# load the module
module load R

# run the analyses
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_4/rep_171 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_4/rep_172 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_4/rep_173 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_4/rep_174 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_4/rep_175 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_4/rep_176 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_4/rep_177 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_4/rep_178 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_4/rep_179 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_4/rep_1710 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_4/rep_1711 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_4/rep_1712 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_4/rep_1713 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_4/rep_1714 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_4/rep_1715 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_4/rep_1716 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_4/rep_1717 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_4/rep_1718 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_4/rep_1719 &
Rscript ../../src/analysis.R ./factor/tips_500_size_10_factor_4/rep_1720 ;

# wait for all tasks to complete
wait;

# DONE
