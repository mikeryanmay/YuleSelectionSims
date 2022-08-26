library(adaptMCMC)

# get the arguments
args <- commandArgs(TRUE)

# just the replicate number
indir <- args[1]
# indir <- "scenario/scenario_1_size_10/rep_1/"
# indir <- "factor/tips_100_size_10_factor_4/rep_3/"

# source the code
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

# create the model and calculator
model <- rep("-", num_sites)
model[1] <- "A"
calculator <- YuleLikelihood(tree, seq, model, lambda_0, gamma, delta, 0, phi)

# create the likelihood function
likelihood <- function(lambda_1) {
  
  # compute the delta
  delta <- lambda_1 - lambda_0
  
  # set the value
  calculator$setDelta(delta)
  
  # compute the log-likelihood
  ll <- calculator$computeLikelihood()
  
  return(ll)
  
}

# create the prior distribution
# such that the median value is delta = 0, the 2.5% quantile is 1/6 of the median,
# and the 97.5% quantile is 6 times the median
m  <- lambda_0
sd <- log(36) / (qnorm(0.975) - qnorm(0.025))
prior <- function(lambda_1) dlnorm(lambda_1, m, sd, log = TRUE)

# create the posterior function
posterior <- function(lambda_1) {
  if (lambda_1 < 0) {
    return(-Inf)
  } else {
    likelihood(lambda_1) + prior(lambda_1)  
  }
}

# create the MCMC sampler
samples <- MCMC(posterior, 10000, lambda_0, acc.rate = 0.44)

# create the trace
trace <- cbind(1:nrow(samples$samples), samples$samples)
colnames(trace) <- c("iteration", "lambda1")

# write to file
outdir <- gsub("data", "output", indir)
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)
write.table(trace, file = paste0(outdir, "/posterior.log"), quote = FALSE, sep = "\t", row.names = FALSE)

# quit
q()







