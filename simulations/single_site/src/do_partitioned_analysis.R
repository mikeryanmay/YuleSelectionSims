# RUN FROM simulations/single_site
# setwd("simulations/single_site/")

library(ape)
library(parallel)
source("../../src/likelihood.R")

# color scheme
cols <- c("A" = "green", "C" = "blue", "G" = "grey50", "T" = "red")

# simulation settings
tips    <- c(50, 100, 250, 500, 750, 1000)
size    <- c(1, 10, 100, 1000)
factors <- c(1, 1.5, 2, 2.5, 3, 4)
reps    <- 200

# parameters
lambda_0 <- 0.12      # birth rate
gamma    <- 0.005     # mutation rate
phi      <- 0.1       # sampling rate

# overwrite?
overwrite <- FALSE
# file.remove(list.files(pattern = "partition_info.tsv", recursive = TRUE, full.names = TRUE))

# all combinations
all_sims <- expand.grid(N = tips, L = size, factor = factors, rep = 1:reps)

invisible(mclapply(1:nrow(all_sims), function(i) {
  
  # get this simulation
  this_sim <- all_sims[i,]
  this_N   <- this_sim$N
  this_L   <- this_sim$L
  this_f   <- this_sim$factor
  this_rep <- this_sim$rep
  delta    <- lambda_0 * this_f - lambda_0
  
  # get the directory
  indir <- paste0("factor/tips_", this_N, "_size_", this_L, "_factor_", this_f, "/rep_", this_rep)

  cat(i, " / ", nrow(all_sims), " -- ", indir, "\n", sep="")
  
  # check if output file exists
  outdir  <- gsub("data", "output", indir)
  dir.create(outdir, recursive = TRUE, showWarnings = FALSE)
  outfile <- paste0(outdir, "/partitioned.tsv")
  if ( overwrite == FALSE ) {
    if ( "partitioned.tsv" %in% list.files(indir) ) {
      return(NULL)
    }
  }
  
  # find tree and data
  tree_file <- list.files(indir, pattern = "tree.nex", full.names = TRUE)
  seq_file  <- list.files(indir, pattern = "seq.nex", full.names = TRUE)
  
  # read the data
  tree <- read.nexus(tree_file)
  seq  <- read.nexus.data(seq_file)
  seq  <- do.call(rbind, seq)
  
  # get just the first site
  seq <- t(t(seq[,1]))
  
  # make the calculator
  calculator <- YuleLikelihood(tree, seq, model = c("-"), lambda_0, gamma, delta, 0, phi)
  
  # compute marginal probability of tree (without sequence data)
  x <- calculator$computeLikelihood()
  tree_probability <- calculator$getSelectedLikelihood()
  
  # compute the joint probability of the tree and sequence data
  calculator$setModel("A")
  joint_probability <- calculator$computeLikelihood()
  
  # compute the conditional probability of the site pattern, given the tree
  conditional_site_probability <- joint_probability - tree_probability
  
  # compute the probability of the tree under a constant-rate model
  calculator$setModel("-")
  calculator$setDelta(0)
  constant_joint_probability <- calculator$computeLikelihood()
  constant_tree_probability  <- calculator$getSelectedLikelihood()
  
  # concatenate the results
  fits <- rbind(tree_probability, conditional_site_probability, joint_probability, constant_tree_probability, constant_joint_probability)
  
  # write to file
  write.table(fits, file = outfile, quote = FALSE, sep = "\t", row.names = FALSE)
  
}, mc.cores = 6, mc.preschedule = FALSE))




