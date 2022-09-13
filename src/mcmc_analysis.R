# get the arguments
args <- commandArgs(TRUE)

# just the replicate number
indir <- args[1]
# indir <- "scenario/scenario_1_size_10/rep_1/"
# indir <- "factor/tips_1000_size_1000_factor_4/rep_1/"
# indir <- "factor2/tips_100_size_1_factor_4/rep_2/"

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
prior <- function(lambda_1) dlnorm(lambda_1, log(m), sd, log = TRUE)
# prior <- function(lambda_1) dunif(lambda_1, 0, 1, log = TRUE)

# create a proposal function
prop <- function(x, delta = 0.1) {
  
  x_prime <- rnorm(1, x, delta)
  if (x_prime < 0) {
    x_prime <- -x_prime
  }
  
  return(x_prime)
  
}

# initialize the sampler
# lambda_1 <- rlnorm(1, log(m), sd)
lambda_1 <- lambda_0
lpost    <- likelihood(lambda_1)

# do a burnin
proposed  <- 0
accepted  <- 0
tune_num  <- 10
tune_freq <- 100 
delta     <- 0.1

for(i in 1:tune_num) {
  
  for(j in 1:tune_freq) {
    
    # propose new value
    lambda_1_prime <- prop(lambda_1, delta)
    proposed <- proposed + 1
    
    # compute acceptance probability
    lpost_prime <- likelihood(lambda_1_prime) + prior(lambda_1_prime)
    R <- exp(lpost_prime - lpost)
    
    # accept/reject
    if ( runif(1) < R ) {
      
      # increment acceptance counter
      accepted <- accepted + 1
      
      # update values
      lambda_1 <- lambda_1_prime
      lpost    <- lpost_prime
      
    }
    
  }
  
  # compute the acceptance rate
  f <- accepted / proposed
  
  # tune
  if ( f < 0.44 ) {
    delta <- delta / (2.0 - f / 0.44)
  } else {
    delta <- delta * (1.0 + ((f - 0.44) / (1.0 - 0.44)))
  }
  
  # reset counters
  proposed <- 0
  accepted <- 0
  
  cat(f, " -- ", delta, "\n")
  
}

# sample the posterior
nsamples <- 10000
thin     <- 1
post     <- numeric(nsamples)
trace    <- numeric(nsamples)

bar <- txtProgressBar(style = 3, width = 40)
for(i in 1:nsamples) {
  
  for(j in 1:thin) {
    
    # propose new value
    lambda_1_prime <- prop(lambda_1, delta)
    proposed <- proposed + 1
    
    # compute acceptance probability
    lpost_prime <- likelihood(lambda_1_prime) + prior(lambda_1_prime)
    R <- exp(lpost_prime - lpost)
    
    # accept/reject
    if ( runif(1) < R ) {
      
      # increment acceptance counter
      accepted <- accepted + 1
      
      # update values
      lambda_1 <- lambda_1_prime
      lpost    <- lpost_prime
      
    }
    
  }
  
  # record samples
  post[i]  <- lpost
  trace[i] <- lambda_1
  
  setTxtProgressBar(bar, i / nsamples)
  
}

# close the progress bar
close(bar)

# create the trace
samples <- data.frame(iteration = 1:nsamples, post = post, lambda1 = trace)

# write to file
outdir <- gsub("data", "output", indir)
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)
write.table(samples, file = paste0(outdir, "/posterior.log"), quote = FALSE, sep = "\t", row.names = FALSE)

# quit
q()







