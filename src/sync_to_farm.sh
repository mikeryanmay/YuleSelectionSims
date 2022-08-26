#!/bin/bash

# synchronize all
rsync -azP --exclude=".*/" ~/repos/YuleSelectionSims mrmay@farm.cse.ucdavis.edu:.
