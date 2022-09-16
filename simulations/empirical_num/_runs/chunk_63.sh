#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chunk_63
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
Rscript src/analysis.R ./sims/tips_800_f_1.5/rep_41 &
Rscript src/analysis.R ./sims/tips_800_f_1.5/rep_42 &
Rscript src/analysis.R ./sims/tips_800_f_1.5/rep_43 &
Rscript src/analysis.R ./sims/tips_800_f_1.5/rep_44 &
Rscript src/analysis.R ./sims/tips_800_f_1.5/rep_45 &
Rscript src/analysis.R ./sims/tips_800_f_1.5/rep_46 &
Rscript src/analysis.R ./sims/tips_800_f_1.5/rep_47 &
Rscript src/analysis.R ./sims/tips_800_f_1.5/rep_48 &
Rscript src/analysis.R ./sims/tips_800_f_1.5/rep_49 &
Rscript src/analysis.R ./sims/tips_800_f_1.5/rep_50 &
Rscript src/analysis.R ./sims/tips_800_f_1.5/rep_51 &
Rscript src/analysis.R ./sims/tips_800_f_1.5/rep_52 &
Rscript src/analysis.R ./sims/tips_800_f_1.5/rep_53 &
Rscript src/analysis.R ./sims/tips_800_f_1.5/rep_54 &
Rscript src/analysis.R ./sims/tips_800_f_1.5/rep_55 &
Rscript src/analysis.R ./sims/tips_800_f_1.5/rep_56 &
Rscript src/analysis.R ./sims/tips_800_f_1.5/rep_57 &
Rscript src/analysis.R ./sims/tips_800_f_1.5/rep_58 &
Rscript src/analysis.R ./sims/tips_800_f_1.5/rep_59 &
Rscript src/analysis.R ./sims/tips_800_f_1.5/rep_60 ;

# wait for all tasks to complete
wait;

# DONE
