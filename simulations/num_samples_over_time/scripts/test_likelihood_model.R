# setwd("simulations/num_samples_over_time/")
source("src/countClass.R", chdir = TRUE)

# mutation rate
genome_size <- 30000
mutation_rate_per_site_per_year <- 0.00084
mutation_rate_per_site_per_day  <- mutation_rate_per_site_per_year / 365
gamma <- mutation_rate_per_site_per_day

# diversification rates
r0      <- 2.5
phi     <- 0.2
lambda0 <- r0 * phi
lambda1 <- 1.5 * lambda0

# read a dataset
dir  <- "../empirical_single_site/sims/tips_100_f_2/rep_1/"
tree <- read.nexus(paste0(dir, "tree.nex"))
seq  <- read.nexus.data(paste0(dir, "seq.nex"))
seq  <- t(t(sapply(seq, head, n = 1)))

# remove the root edge if you want
# tree$root.edge <- NULL

# make the model object
calculator <- countModel(tree, seq, "A", lambda0, lambda1, phi, gamma / 3, gamma)
calculator$computeLikelihood()

calculator$setLambda1(lambda0)
calculator$computeLikelihood()