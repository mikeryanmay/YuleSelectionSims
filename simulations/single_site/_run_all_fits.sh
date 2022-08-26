#!/bin/bash

# move to _run dir
cd _run_fits

# get all the tasks in this directory
for file in *.sh; do
  echo $file
  sbatch $file
done
