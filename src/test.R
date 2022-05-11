library(ape)
source("src/simulate.R")

# parameters
lambda <- 0.12
delta  <- 0.12
phi    <- 0.1
gamma  <- 0.005

# make the selected sequence
S <- c("A")

sim <- simulateYuleSelection(S, lambda, delta, phi, gamma, 100)
