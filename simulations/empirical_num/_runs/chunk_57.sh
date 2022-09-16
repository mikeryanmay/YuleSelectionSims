#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_57
#SBATCH --mail-user=mikeryanmay@gmail.com
#SBATCH --mail-type=FAIL
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --time=168:00:00

# change to user directory
cd /home/$USER/YuleSelectionSims/simulations/empirical_num/

# load the module
module load R

# run the analyses
Rscript src/analysis.R ./sims/tips_400_f_3/rep_21 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_22 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_23 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_24 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_25 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_26 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_27 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_28 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_29 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_30 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_31 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_32 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_33 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_34 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_35 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_36 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_37 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_38 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_39 &
Rscript src/analysis.R ./sims/tips_400_f_3/rep_40 ;

# wait for all tasks to complete
wait;

# DONE
