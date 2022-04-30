#!/bin/bash

# move to single-site directory
cd simulations/single_site/

# simulate 1/10
echo "Simulation factor 1/10"
cd factor_1_size_10/
Rscript src/sim.R

# simulate 1/100
echo "Simulation factor 1/100"
cd ../factor_1_size_100/
Rscript src/sim.R

# simulate 1/1000
echo "Simulation factor 1/1000"
cd ../factor_1_size_1000/
Rscript src/sim.R

# simulate 2/10
echo "Simulation factor 2/10"
cd ../factor_2_size_10/
Rscript src/sim.R

# simulate 2/100
echo "Simulation factor 2/100"
cd ../factor_2_size_100/
Rscript src/sim.R

# simulate 2/1000
echo "Simulation factor 2/1000"
cd ../factor_2_size_1000/
Rscript src/sim.R

# simulate 3/10
echo "Simulation factor 3/10"
cd ../factor_3_size_10/
Rscript src/sim.R

# simulate 3/100
echo "Simulation factor 3/100"
cd ../factor_3_size_100/
Rscript src/sim.R

# simulate 3/1000
echo "Simulation factor 3/1000"
cd ../factor_3_size_1000/
Rscript src/sim.R

# simulate 4/10
echo "Simulation factor 4/10"
cd ../factor_4_size_10/
Rscript src/sim.R

# simulate 4/100
echo "Simulation factor 4/100"
cd ../factor_4_size_100/
Rscript src/sim.R

# simulate 4/1000
echo "Simulation factor 4/1000"
cd ../factor_4_size_1000/
Rscript src/sim.R


# scenario 1/10
echo "Simulation scenario 1/10"
cd ../scenario_1_size_10/
Rscript src/sim.R

# scenario 1/100
echo "Simulation scenario 1/100"
cd ../scenario_1_size_100/
Rscript src/sim.R

# scenario 1/1000
echo "Simulation scenario 1/1000"
cd ../scenario_1_size_1000/
Rscript src/sim.R


# scenario 2/10
echo "Simulation scenario 2/10"
cd ../scenario_2_size_10/
Rscript src/sim.R

# scenario 2/100
echo "Simulation scenario 2/100"
cd ../scenario_2_size_100/
Rscript src/sim.R

# scenario 2/1000
echo "Simulation scenario 2/1000"
cd ../scenario_2_size_1000/
Rscript src/sim.R


# scenario 3/10
echo "Simulation scenario 3/10"
cd ../scenario_3_size_10/
Rscript src/sim.R

# scenario 3/100
echo "Simulation scenario 3/100"
cd ../scenario_3_size_100/
Rscript src/sim.R

# scenario 3/1000
echo "Simulation scenario 3/1000"
cd ../scenario_3_size_1000/
Rscript src/sim.R


;
