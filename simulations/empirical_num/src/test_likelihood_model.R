# setwd("simulations/num_samples_over_time/")
library(cubature)
source("../../src/countClass.R", chdir = TRUE)
source("../../src/YuleLikelihoodBinary.R", chdir = TRUE)

# mutation rate
genome_size <- 30000
mutation_rate_per_site_per_year <- 0.00084
mutation_rate_per_site_per_day  <- mutation_rate_per_site_per_year / 365
gamma <- mutation_rate_per_site_per_day

# diversification rates
r0      <- 2.5
phi     <- 1 / 7
lambda0 <- r0 * phi
lambda1 <- 2 * lambda0

# read a dataset
dir  <- "sims/tips_200_f_2/rep_12/"
tree <- read.nexus(paste0(dir, "tree.nex"))
seq  <- read.nexus.data(paste0(dir, "seq.nex"))
seq  <- t(t(sapply(seq, head, n = 1)))

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

exp(c(count_likelihood_true, count_likelihood_neutral)) / sum(exp(c(count_likelihood_true, count_likelihood_neutral)))
exp(c(tree_likelihood_true, tree_likelihood_neutral)) / sum(exp(c(tree_likelihood_true, tree_likelihood_neutral)))

# try some cubature
int_count <- pcubature(function(x) {
  
  cat(x, "\t", sep ="")
  
  # set the value
  count_calculator$setLambda1(lambda0 * x)
  
  # compute the likelihood
  ll <- count_calculator$computeLikelihood(verbose = FALSE) - log(5)
  
  cat(ll, "\n", sep = "")
  
  return(exp(ll))
  
}, lower = 1, upper = 6, tol = 1e-3)

int_tree <- pcubature(function(x) {
  
  cat(x, "\t", sep ="")
  
  # set the value
  tree_calculator$setLambda1(lambda0 * x)
  
  # compute the likelihood
  ll <- tree_calculator$computeLikelihood() - log(5)
  
  cat(ll, "\n", sep = "")
  
  return(exp(ll))
  
}, lower = 1, upper = 6, tol = 1e-3)


log(int_count$integral) - count_likelihood_neutral
log(int_tree$integral)  - tree_likelihood_neutral

exp(c(log(int_count$integral), count_likelihood_neutral)) / sum(exp(c(log(int_count$integral), count_likelihood_neutral)))
exp(c(log(int_tree$integral), tree_likelihood_neutral)) / sum(exp(c(log(int_tree$integral), tree_likelihood_neutral)))


