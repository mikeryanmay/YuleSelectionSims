# setwd("simulations/multiple_sites/")

# source the code
library(cubature)
library(microbenchmark)
source("../../src/likelihood.R")
source("../../src/likelihood2.R")

indir <- "sims/tips_100_size_4_f_1.5/rep_8/"

# simulation settings
lambda_0 <- 0.12      # birth rate
gamma    <- 0.005     # mutation rate
L        <- 1         # number of selected sites
phi      <- 0.1       # sampling rate
delta    <- 0

# find tree and data
tree_file <- list.files(indir, pattern = "tree.nex", full.names = TRUE)
seq_file  <- list.files(indir, pattern = "seq.nex", full.names = TRUE)

# read the data
tree <- read.nexus(tree_file)
seq  <- read.nexus.data(seq_file)
seq  <- do.call(rbind, seq)
num_sites <- ncol(seq)

# only consider the first site
# seq <- t(t(seq[,1]))

###################
# model with data #
###################

# create the model and calculator
model <- rep("-", num_sites)
model[1:4] <- "A"

calculator_2 <- YuleLikelihood(tree, seq, model, lambda_0, gamma, 0.1, 0, phi)
calculator_2$computeLikelihood()

calculator_1 <- YuleLikelihoodOld(tree, seq, model, lambda_0, gamma, 0.1, 0, phi)
calculator_1$computeLikelihood()


foo_1 <- function(x) {
  calculator_1$setDelta(x)
  calculator_1$computeLikelihood()
}

foo_2 <- function(x) {
  calculator_2$setDelta(x)
  calculator_2$computeLikelihood()
}

microbenchmark(
  foo_1(0.1),
  foo_2(0.1)
)

calculator <- YuleLikelihood(tree, seq, model, lambda_0, gamma, delta, 0, phi)
calculator$computeLikelihood()

foo <- function(x) {
  calculator$setDelta(x)
  calculator$computeLikelihood()
}

Rprof(interval = 0.0001)
# calculator$computeLikelihood()
for(i in 1:100) {
  foo(0.1)
}
# calculator$setDelta(0.1)
# calculator$computeLikelihood()
Rprof(NULL)
summaryRprof("Rprof.out")
