#!/bin/bash

# synchronize all
rsync -azP --exclude=".*/" mrmay@farm.cse.ucdavis.edu:YuleSelectionSims/simulations/single_site/factor ~/repos/YuleSelectionSims/simulations/single_site/
rsync -azP --exclude=".*/" mrmay@farm.cse.ucdavis.edu:YuleSelectionSims/simulations/single_site/scenario ~/repos/YuleSelectionSims/simulations/single_site/
