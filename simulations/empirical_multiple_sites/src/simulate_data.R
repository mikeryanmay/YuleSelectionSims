# RUN FROM simulations/multiple_sites
# setwd("simulations/empirical_multiple_sites/")

library(parallel)
library(ggtree)

# source code
source("../../src/simulate.R")

# color scheme
cols <- c("A" = "green", "C" = "blue", "G" = "grey50", "T" = "red")

# simulation settings
tips      <- c(100, 200, 400, 800, 1600)
size      <- c(1, 2, 3, 4) # number of sites under selection
factor    <- c(2, 3, 4)
reps      <- 100

# outer(size, factor, function(x,y) y^(1/x))

# mutation rate
genome_size <- 30000
mutation_rate_per_site_per_year <- 0.00084
mutation_rate_per_site_per_day  <- mutation_rate_per_site_per_year / 365
gamma <- mutation_rate_per_site_per_day

# diversification rates
r0      <- 2.5
phi     <- 1 / 7
lambda0 <- r0 * phi

# overwrite?
overwrite <- FALSE
# overwrite <- TRUE

# all combinations
all_sims <- expand.grid(N = tips, L = size, factor = factor, rep = 1:reps)

summary <- do.call(rbind, mclapply(1:nrow(all_sims), function(i) {
# summary <- do.call(rbind, lapply(1:nrow(all_sims), function(i, ...) {
  
  # get this simulation
  this_sim <- all_sims[i,]
  this_N   <- this_sim$N
  this_L   <- this_sim$L
  this_f   <- this_sim$factor
  this_rep <- this_sim$rep

  # create the directory
  dir <- paste0("sims/tips_", this_N, "_size_", this_L, "_f_", this_f, "/rep_", this_rep)
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)

  cat(i, " / ", nrow(all_sims) ,"\n", sep="")
  
  # check if tree already exists
  if ( ("tree.nex" %in% list.files(dir) == FALSE) | overwrite == TRUE ) {
    
    # simulate a tree
    
    # create the model
    model <- rep("A", this_L)
    
    # compute the factor
    # this_factor <- this_f^(1 / this_L)
    this_factor <- this_f
    
    # simulate the data
    repeat {
      sim <- simulateYuleSelectionTreeSingleton(model, lambda0, this_factor, phi, lambda0 / 20, this_N, model = "multiplicative")
      if ( is.null(sim) == FALSE && all(sim$num_gains == 1)) {
        # condition on variation at tips
        if ( all(apply(sim$seq[drop.fossil(sim$phy)$tip.label,,drop = FALSE], 2, function(x) length(unique(x))) > 1) ) {
          break
        }
      }
    }
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
    repeat {
      
      # simulate polymorphic sites
      neutral_sites <- as.DNAbin(simSeq(phy, l = genome_size, rate = gamma / 3))
      neutral_sites <- neutral_sites[,apply(neutral_sites, 2, function(x) length(unique(x))) > 1]
      
      # ensure at lest one polymorphic site
      if (ncol(neutral_sites) > 0) {
        break
      }
      
    }
    
    # make one alignment
    aln <- cbind(as.DNAbin(seq), neutral_sites)
    
    # write the data
    write.nexus(phy, file = paste0(dir, "/tree.nex"))
    write.nexus.data(aln, file = paste0(dir, "/seq.nex"))
    
  } else {
    
    # read the data
    phy <- read.nexus(file = paste0(dir, "/tree.nex"))
    seq <- do.call(rbind, read.nexus.data(file = paste0(dir, "/seq.nex")))
    neutral_sites <- seq[,-c(1:this_L)]
    
  }

  # some summary statistics
  tree_age <- max(branching.times(phy)) + phy$root.edge
  num_poly <- ncol(neutral_sites)
  
  # return statistics  
  res <- data.frame(N      = this_N,
                    L      = this_L,
                    factor = this_f,
                    rep    = this_rep,
                    age    = tree_age,
                    poly   = num_poly)
  
  return(res)
  
}, mc.cores = 6, mc.preschedule = FALSE))

# make a summary
splits <- split(summary, list(summary$N, summary$L, summary$factor))

df <- do.call(rbind, lapply(splits, function(x) {
  
  # summarize
  mean_age  <- mean(x$age)
  min_poly  <- min(x$poly)
  median_poly <- median(x$poly)
  max_poly  <- max(x$poly)
  
  res <- data.frame(N = x$N[1], 
                    L = x$L[1], 
                    factor = x$factor[1], 
                    mean_age = mean_age, 
                    min_poly = min_poly, 
                    median_poly = median_poly, 
                    max_poly = max_poly)
  
  return(res)
  
}))

write.table(df, file = "sims/summary.tsv", sep = "\t", quote = FALSE, col.names = TRUE, row.names = FALSE)





