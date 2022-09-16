# setwd("simulations/num_samples_over_time/")
source("src/countClass.R", chdir = TRUE)
source("src/YuleLikelihoodBinary.R", chdir = TRUE)

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
dir  <- "../empirical_single_site/sims/tips_100_f_2/rep_4/"
tree <- read.nexus(paste0(dir, "tree.nex"))
seq  <- read.nexus.data(paste0(dir, "seq.nex"))
seq  <- t(t(sapply(seq, head, n = 1)))

# remove the root edge if you want
# tree$root.edge <- NULL

# make the model object
count_calculator <- countModel(tree, seq, "A", lambda0, lambda1, phi, gamma, gamma)
count_likelihood_true <- count_calculator$computeLikelihood()

count_calculator$setLambda1(lambda0)
count_likelihood_neutral <- count_calculator$computeLikelihood()

# try the tree model
tree_calculator <- YuleLikelihoodBinary(tree, seq, "A", lambda0, lambda1, gamma, gamma, phi)
tree_likelihood_true <- tree_calculator$computeLikelihood()

tree_calculator$setLambda1(lambda0)
tree_likelihood_neutral <- tree_calculator$computeLikelihood()

# compare
count_likelihood_true - count_likelihood_neutral
tree_likelihood_true - tree_likelihood_neutral
