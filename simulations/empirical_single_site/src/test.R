# RUN FROM simulations/multiple_sites
# setwd("simulations/empirical_single_site/")

# source code
source("../../src/simulate.R")

# color scheme
cols <- c("A" = "green", "C" = "blue", "G" = "grey50", "T" = "red")

# simulation settings
tips   <- 100
delta  <- 1.5
reps   <- 200

# mutation rate
genome_size <- 30000
mutation_rate_per_site_per_year <- 0.00084
mutation_rate_per_site_per_day  <- mutation_rate_per_site_per_year / 365
gamma <- mutation_rate_per_site_per_day

# diversification rates
r0      <- 2.5
phi     <- 0.2
lambda0 <- r0 * phi
model   <- "A"


sim_1 <- simulateYuleSelection(model, lambda0, factor, phi, gamma, tips, 1, "multiplicative", verbose = TRUE)
sim_2 <- simulateYuleSelectionTreeSingleton(model, lambda0, factor, phi, lambda0 / 10, tips, "multiplicative")
