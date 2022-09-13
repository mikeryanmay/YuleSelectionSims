# RUN FROM simulations/multiple_sites
# setwd("simulations/multiple_sites/")

library(parallel)
library(ggtree)

# source code
source("../../src/simulate.R")

# color scheme
cols <- c("A" = "green", "C" = "blue", "G" = "grey50", "T" = "red")

# simulation settings
tips      <- c(50, 100, 250, 500, 750, 1000)
size      <- c(1, 2, 3, 4)
factor    <- c(1.5, 2, 2.5, 3)
reps      <- 200
num_sites <- 100

# parameters
lambda0 <- 0.12
gamma   <- 0.005
phi     <- 0.1

# overwrite?
overwrite <- FALSE
# overwrite <- TRUE

# all combinations
all_sims <- expand.grid(N = tips, L = size, factor = factor, num_sites = num_sites, rep = 1:reps)

invisible(mclapply(1:nrow(all_sims), function(i) {
  
  # get this simulation
  this_sim <- all_sims[i,]
  this_N   <- this_sim$N
  this_L   <- this_sim$L
  this_f   <- this_sim$factor
  this_n   <- this_sim$num_sites
  this_rep <- this_sim$rep

  # create the directory
  dir <- paste0("sims/tips_", this_N, "_size_", this_L, "_f_", this_f, "/rep_", this_rep)
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)

  # check if tree already exists
  if ( overwrite == FALSE ) {
    if ( "tree.nex" %in% list.files(dir) ) {
      # cat("skipping\n")
      return(NULL)
    }
  }
  
  cat(i, " / ", nrow(all_sims) ,"\n", sep="")
    
  # create the model
  model <- rep("A", this_L)

  # simulate the data
  sim <- simulateYuleSelection(model, lambda0, lambda0 * this_f - lambda0, phi, gamma, this_N, 1)
  phy <- ladderize(sim$phy)
  seq <- sim$seq
  
  # make the alignment
  aln <- as.DNAbin(seq)
  
  # dummy intermediate
  fasta_file <- paste0(dir, "/seq.fasta")
  if ( this_L == 1 ) {
    tmp_aln <- cbind(seq, seq)
    write.FASTA(as.DNAbin(tmp_aln), file = fasta_file)
  } else {
    write.FASTA(aln, file = fasta_file)
  }

  # make a plot w/ MSA
  pdf(paste0(dir,"/tree.pdf"))
  print(msaplot(p=ggtree(phy), fasta = paste0(dir, "/seq.fasta"), width = 0.1))
  dev.off()

  # remove the fasta file
  file.remove(fasta_file)

  # simulate neutral sites
  if ( this_n > this_L ) {

    # simulate the neutral sites
    neutral_sites <- simulatePolymorphicNeutralSites(phy, gamma, this_n - this_L)

    # make one alignment
    aln <- cbind(as.DNAbin(seq), neutral_sites)

  } else {

    # make one alignment
    aln <- as.DNAbin(seq)

  }
  
  # write the data
  write.nexus(phy, file = paste0(dir, "/tree.nex"))
  write.nexus.data(aln, file = paste0(dir, "/seq.nex"))
  
}, mc.cores = 6, mc.preschedule = FALSE))
