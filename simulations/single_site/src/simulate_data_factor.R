library(parallel)

# source code
source("../../src/simulate.R")

# simulation settings
tips    <- c(100, 500, 1000)
size    <- c(10, 100, 1000)
factors <- c(1,2,3,4)
reps    <- 200

# parameters
lambda0 <- 0.12
gamma   <- 0.005
phi     <- 0.1

# all combinations
all_sims <- expand.grid(N = tips, L = size, factor = factors, rep = 1:reps)

invisible(mclapply(1:nrow(all_sims), function(i) {
  
  cat(i, " / ", nrow(all_sims) ,"\n", sep="")
  
  # get this simulation
  this_sim <- all_sims[i,]
  this_N   <- this_sim$N
  this_L   <- this_sim$L
  this_f   <- this_sim$factor
  this_rep <- this_sim$rep
  
  # compute the selection parameter
  lambda_max <- this_f * lambda0
  delta      <- (lambda_max - lambda0) / this_L
  
  # simulate the data
  sim <- simulateYuleSelection("A", lambda0, delta, phi, gamma, this_N, 1)
  phy <- sim$phy
  seq <- sim$seq
  
  # simulate the neutral sites
  neutral_sites <- as.DNAbin(simSeq(phy, l = this_L - 1, rate = gamma / 3))
  
  # make one alignment
  aln <- cbind(as.DNAbin(seq), neutral_sites)
  
  # write the data
  dir <- paste0("factor/tips_", this_N, "_size_", this_L, "_factor_", this_f, "/rep_", this_rep)
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  
  # write the data
  write.nexus(phy, file = paste0(dir, "/tree.nex"))
  write.nexus.data(aln, file = paste0(dir, "/seq.nex"))
  
}, mc.cores = 8, mc.preschedule = FALSE))