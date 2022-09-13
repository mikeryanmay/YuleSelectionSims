#!/bin/bash

# synchronize all
rsync -azP --exclude=".*/" mrmay@farm.cse.ucdavis.edu:YuleSelectionSims/simulations/multiple_sites/sims ~/repos/YuleSelectionSims/simulations/multiple_sites/
