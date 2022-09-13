#!/bin/bash

# synchronize all
rsync -azP --exclude=".*/" mrmay@farm.cse.ucdavis.edu:YuleSelectionSims/simulations/empirical_single_site/sims ~/repos/YuleSelectionSims/simulations/empirical_single_site/
