#!/bin/bash

# move to _run dir
cd _run_numerical_posterior

# get all the tasks in this directory
for file in *.sh; do
  echo $file
  sbatch $file
done
