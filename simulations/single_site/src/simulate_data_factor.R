# RUN FROM simulations/single_site
# setwd("simulations/single_site/")

library(parallel)

# source code
source("../../src/simulate.R")

# color scheme
cols <- c("A" = "green", "C" = "blue", "G" = "grey50", "T" = "red")

# simulation settings
tips    <- c(50, 100, 250, 500, 750, 1000)
size    <- c(1, 10, 100, 1000)
factors <- c(1, 1.5, 2, 2.5, 3, 4)
reps    <- 200

# parameters
lambda0 <- 0.12
gamma   <- 0.005
phi     <- 0.1

# overwrite?
overwrite <- FALSE

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

  # create the directory
  dir <- paste0("factor/tips_", this_N, "_size_", this_L, "_factor_", this_f, "/rep_", this_rep)
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)

  # check if tree already exists
  if ( overwrite == FALSE ) {
    if ( "tree.nex" %in% list.files(dir) ) {
      return(NULL)
    }
  }
    
  # compute the selection parameter
  lambda_max <- this_f * lambda0
  delta      <- (lambda_max - lambda0)
  
  # simulate the data
  sim <- simulateYuleSelection("A", lambda0, delta, phi, gamma, this_N, 1)
  phy <- ladderize(sim$phy)
  seq <- sim$seq
  
  if ( this_L > 1 ) {

    # simulate the neutral sites
    neutral_sites <- as.DNAbin(simSeq(phy, l = this_L - 1, rate = gamma / 3))
    
    # make one alignment
    aln <- cbind(as.DNAbin(seq), neutral_sites)
    
  } else {

    # make one alignment
    aln <- as.DNAbin(seq)
    
  }
  
  # write the data
  write.nexus(phy, file = paste0(dir, "/tree.nex"))
  write.nexus.data(aln, file = paste0(dir, "/seq.nex"))
  
  # make a plot
  pdf(paste0(dir,"/tree.pdf"))
  plot(phy, show.tip.label = FALSE, no.margin = TRUE)
  tiplabels(col = cols[seq[,1]], pch = 19, cex = 0.5)
  nodelabels(node = as.integer(rownames(sim$nodeseq)), col = cols[sim$nodeseq[,1]], pch = 19, cex = 0.5)
  dev.off()
  
  
}, mc.cores = 8, mc.preschedule = FALSE))
