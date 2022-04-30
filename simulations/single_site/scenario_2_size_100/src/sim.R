# source code
source("../../../src/simulate.R")

# simulation settings
gamma     <- 0.005     # mutation rate
nsites    <- 10        # the total number of sites in the alignment
L         <- 1         # the number of sites under selection
nsites    <- 100       # the total number of sites in the alignment
reps      <- 100       # the number of simulation replicates

# simulate the data
mclapply(1:reps, function(i) {

  cat("*")

  # get the tree
  phylo <- read.nexus("data/tree.nex")

  # get the selected site
  selected_site <- as.DNAbin(t(t(do.call(rbind, read.nexus.data("data/seq.nex"))[,1])))

  # simulate the neutral sites
  neutral_sites <- as.DNAbin(simSeq(phylo, l = nsites - 1, rate = gamma / 3))

  # make one alignment
  aln <- cbind(selected_site, neutral_sites)

  # make a directory
  dir <- paste0("data/rep_", i, "/")
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)

  # write the data
  write.nexus(phylo, file = paste0(dir, "tree.nex"))
  write.nexus.data(aln, file = paste0(dir, "/seq.nex"))


}, mc.cores = 8)

cat("\n")
