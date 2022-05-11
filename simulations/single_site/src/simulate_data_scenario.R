library(parallel)

# source code
source("../../src/simulate.R")

# simulation settings
scenarios <- 1:3
size      <- c(10, 100, 1000)
reps      <- 200

# parameters
lambda0 <- 0.12
gamma   <- 0.005
phi     <- 0.1

# all combinations
all_sims <- expand.grid(S = scenarios, L = size, rep = 1:reps)

invisible(mclapply(1:nrow(all_sims), function(i) {
  
  cat(i, " / ", nrow(all_sims) ,"\n", sep="")
  
  # get this simulation
  this_sim <- all_sims[i,]
  this_S   <- this_sim$S
  this_L   <- this_sim$L
  this_rep <- this_sim$rep
  
  # read the original data
  phy <- read.nexus(paste0("scenario/original_data/scenario_", this_S, "_tree.nex"))
  seq <- do.call(rbind, read.nexus.data(paste0("scenario/original_data/scenario_", this_S, "_seq.nex")))[,1]
  
  # simulate the neutral sites
  neutral_sites <- as.DNAbin(simSeq(phy, l = this_L - 1, rate = gamma / 3))
  
  # make one alignment
  aln <- cbind(as.DNAbin(t(t(seq))), neutral_sites)
  
  # write the data
  dir <- paste0("scenario/scenario_", this_S, "_size_", this_L, "/rep_", this_rep)
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  
  # write the data
  write.nexus(phy, file = paste0(dir, "/tree.nex"))
  write.nexus.data(aln, file = paste0(dir, "/seq.nex"))
  
}, mc.cores = 8, mc.preschedule = FALSE))