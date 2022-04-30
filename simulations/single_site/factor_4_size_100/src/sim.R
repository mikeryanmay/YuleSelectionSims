# source code
source("../../../src/simulate.R")

# simulation settings
t         <- 50        # total time
gamma     <- 0.005     # mutation rate
L         <- 1         # number of selected sites
mu        <- 0         # extinction rate
phi       <- 0.1       # the sampling rate
rho       <- 1.0       # sampling fraction at the present
rho_times <- t         # sampling time at the present (note: could be a vector)
factor    <- 4         # the relative fitness of the selected allele
nsites    <- 100       # the total number of sites in the alignment
L         <- 1         # the number of sites under selection
reps      <- 100       # the number of simulation replicates

# r0 for the initial sequences
r0 <- 1.2
lambda_0   <- r0 * (mu + phi) # the birth rate
lambda_max <- factor * lambda_0
delta      <- (lambda_max - lambda_0) / L

# create the fitness map
optimal_sequence <- "A"

# the rate matrix
Q <- matrix(gamma / 3, 4, 4)
diag(Q) <- -gamma

# plot colors
cols <- c(a = "green", c = "blue", g = "darkgrey", t = "red")

# simulate the data
mclapply(1:reps, function(i) {

  cat("*")

  # simulate the data
  repeat {

    tree <- simulateBirthDeathFitnessModelConditional(gamma,
                                                      L,
                                                      optimal_sequence,
                                                      lambda_0,
                                                      delta,
                                                      mu,
                                                      phi,
                                                      rho,
                                                      rho_times,
                                                      initial_state,
                                                      t,
                                                      NMAX = 2000)

    num_gains <- tree$computeNumGains()
    if ( num_gains > 0 & sum(tree$dat$status == "sampled") > 100 & sum(tree$dat$status == "sampled") < 1000 ) {
      break
    }

  }

  # get the tree
  phylo <- read.tree(text = tree$newick_string)

  # get the selected site
  selected_site <- tree$getAlignment()

  # simulate the neutral sites
  neutral_sites <- as.DNAbin(simSeq(phylo, l = nsites - 1, Q = Q, rate = gamma / 3))

  # make one alignment
  aln <- cbind(selected_site, neutral_sites)

  # make a directory
  dir <- paste0("data/rep_", i, "/")
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)

  # write the data
  write.nexus(phylo, file = paste0(dir, "tree.nex"))
  write.nexus.data(aln, file = paste0(dir, "/seq.nex"))

  # plot the tree with colored branches
  pdf(paste0(dir, "tree.pdf"), height = 4)
  par(mar=c(0,0,0,0))
  tree$plot(lwd = 2, lend = 2, xlab = "time", ylab = NA, bty = "n", yaxt = "n", colors = cols)
  legend("topleft", legend = c("A","C","G","T"), fill = cols, bty = "n", )
  dev.off()

}, mc.cores = 8)

cat("\n")

# bar <- txtProgressBar(style = 3, width = 40)
# for(i in 1:reps) {
#
#   # simulate the data
#   repeat {
#
#     tree <- simulateBirthDeathFitnessModelConditional(gamma,
#                                                       L,
#                                                       optimal_sequence,
#                                                       lambda_0,
#                                                       delta,
#                                                       mu,
#                                                       phi,
#                                                       rho,
#                                                       rho_times,
#                                                       initial_state,
#                                                       t,
#                                                       NMAX = 2000)
#
#     num_gains <- tree$computeNumGains()
#     if ( num_gains > 0 & sum(tree$dat$status == "sampled") > 100 & sum(tree$dat$status == "sampled") < 1000 ) {
#       break
#     }
#
#   }
#
#   # get the tree
#   phylo <- read.tree(text = tree$newick_string)
#
#   # get the selected site
#   selected_site <- tree$getAlignment()
#
#   # simulate the neutral sites
#   neutral_sites <- as.DNAbin(simSeq(phylo, l = nsites - 1, Q = Q, rate = gamma / 3))
#
#   # make one alignment
#   aln <- cbind(selected_site, neutral_sites)
#
#   # make a directory
#   dir <- paste0("data/rep_", i, "/")
#   dir.create(dir, recursive = TRUE, showWarnings = FALSE)
#
#   # write the data
#   write.nexus(phylo, file = paste0(dir, "tree.nex"))
#   write.nexus.data(aln, file = paste0(dir, "/seq.nex"))
#
#   # plot the tree with colored branches
#   pdf(paste0(dir, "tree.pdf"), height = 4)
#   par(mar=c(0,0,0,0))
#   tree$plot(lwd = 2, lend = 2, xlab = "time", ylab = NA, bty = "n", yaxt = "n", colors = cols)
#   legend("topleft", legend = c("A","C","G","T"), fill = cols, bty = "n", )
#   dev.off()
#
#   setTxtProgressBar(bar, i / reps)
#
# }
