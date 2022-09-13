# get the arguments
args <- commandArgs(TRUE)

# just the replicate number
indir <- args[1]
# indir <- "scenario/scenario_1_size_10/rep_1/"
# indir <- "factor/tips_1000_size_1000_factor_4/rep_1/"
# indir <- "factor/tips_100_size_1_factor_4/rep_2/"
# indir <- "factor/tips_50_size_1_factor_1.5/rep_1/"

# source the code
library(cubature)
source("../../src/likelihood.R")

# simulation settings
lambda_0 <- 0.12      # birth rate
gamma    <- 0.005     # mutation rate
L        <- 1         # number of selected sites
phi      <- 0.1       # sampling rate
delta    <- 0

# find tree and data
tree_file <- list.files(indir, pattern = "tree.nex", full.names = TRUE)
seq_file  <- list.files(indir, pattern = "seq.nex", full.names = TRUE)

# if the files don't exist, abort
if ( file.exists(tree_file) == FALSE ) {
  cat("Couldn't find tree file.\n")
  q()
}

if ( file.exists(seq_file) == FALSE ) {
  cat("Couldn't find sequence file.\n")
  q()
}

# read the data
tree <- read.nexus(tree_file)
seq  <- read.nexus.data(seq_file)
seq  <- do.call(rbind, seq)
num_sites <- ncol(seq)

# only consider the first site
seq <- t(t(seq[,1]))

###################
# model with data #
###################

# create the model and calculator
model <- "A"
calculator <- YuleLikelihood(tree, seq, model, lambda_0, gamma, delta, 0, phi)
calculator$computeLikelihood()

# create the likelihood function
likelihood <- function(lambda_1) {
  
  # compute the delta
  delta <- lambda_1 - lambda_0
  
  # set the value
  calculator$setDelta(delta)
  
  # compute the log-likelihood
  ll <- calculator$computeLikelihood()
  
  cat(ll, "\n")
  
  return(ll)
  
}

likelihood_tree <- function(lambda_1) {
  
  # compute the delta
  delta <- lambda_1 - lambda_0
  
  # set the value
  calculator$setDelta(delta)
  
  # compute the log-likelihood
  calculator$computeLikelihood()
  ll <- calculator$getSelectedLikelihood()
  
  cat(ll, "\n")
  
  return(ll)
  
}

# create the prior distribution
# such that the median value is delta = 0, the 2.5% quantile is 1/6 of the median,
# and the 97.5% quantile is 6 times the median
m  <- lambda_0
sd <- log(36) / (qnorm(0.975) - qnorm(0.025))
prior <- function(lambda_1) dlnorm(lambda_1, log(m), sd, log = TRUE)

###################
# find the scalar #
###################

log_posterior <- function(x) {
  pp <- sapply(x, likelihood) + prior(x)
  return(pp)
}

opt <- optimize(log_posterior, lower = 0, upper = 1, maximum = TRUE)
scalar <- opt$objective

#############
# integrate #
#############

# make the integrand
posterior <- function(x) {
  pp <- exp(sapply(x, likelihood) + prior(x) - scalar)
  return(pp)
}

# integrate
int <- pcubature(posterior, lowerLimit = 0, upperLimit = 1)

# compute the marginal likelihood
joint_likelihood <- scalar + log(int$integral)

#################################
# constant-rate model with data #
#################################

calculator$setDelta(0)

# compute the likelihood under the neutral model
joint_likelihood_constant <- calculator$computeLikelihood()

###################################
# model without data, just a tree #
###################################

# make it a different site
calculator$setModel("-")

posterior_tree <- function(x) {
  pp <- exp(sapply(x, likelihood_tree) + prior(x) - scalar)
  return(pp)
}

# integrate
int <- pcubature(posterior_tree, lowerLimit = 0, upperLimit = 1)

# compute the marginal likelihood
tree_likelihood <- scalar + log(int$integral)

####################################
# constant-rate model without data #
####################################

calculator$setDelta(0)

# compute the likelihood under the neutral model
calculator$computeLikelihood()
tree_likelihood_constant <- calculator$getSelectedLikelihood()

#######################
# write stuff to file #
#######################

# joint_likelihood - joint_likelihood_constant
# tree_likelihood  - tree_likelihood_constant

# make the output file
outfile <- paste0(indir, "/marg_lik.tsv")

# make the output table
marg_liks <- rbind(joint_likelihood, joint_likelihood_constant, tree_likelihood, tree_likelihood_constant)

# write to file
write.table(marg_liks, file = outfile, quote = FALSE, sep = "\t", row.names = FALSE)





# quit
q()