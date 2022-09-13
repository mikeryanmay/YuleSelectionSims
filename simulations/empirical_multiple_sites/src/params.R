library(parallel)

source("../../src/simulate.R")

# mutation rate
genome_size <- 30000
mutation_rate_per_site_per_year <- 0.00084
mutation_rate_per_site_per_day  <- mutation_rate_per_site_per_year / 365
gamma <- mutation_rate_per_site_per_day

# diversification rates
r0       <- 2.5
phi      <- 1 / 7
lambda_0 <- r0 * sampling_rate

# simulate some tree sizes
reps   <- 100
ntips  <- c(100, 200, 400, 800, 1600)
nsites <- c(1, 2, 3, 4)
factor <- c(1.5, 2, 2.5, 3) # factor is multiplicative, not divided by the number of sites!
grid   <- expand.grid(ntips = ntips, nsites = nsites, factor = factor)

summary <- do.call(rbind, lapply(1:nrow(grid), function(i) {
  
  # get parameters
  this_sim <- grid[i,]
  this_N   <- this_sim$ntips
  this_L   <- this_sim$nsites
  this_f   <- this_sim$factor
  
  print(this_sim)
  
  # make the model
  model <- rep("A", this_L)
  
  # simulate initial trees, conditional on survival
  trees <- mclapply(1:reps, function(x) {
    repeat {
      sim <- simulateYuleSelection(model, lambda_0, this_f, phi, gamma = 1 / this_N, this_N, min_num_gains = 1, model = "multiplicative")  
      if ( all(sim$num_gains == 1) ) {
        return(sim)
      }
    }
  }, mc.cores = 6)
  
  # trees <- vector("list", reps)
  # bar <- txtProgressBar(style = 3, width = 40)
  # for(j in 1:reps) {
  #   
  #   # simulate a surviving tree with exactly one change
  #   repeat {
  #     sim <- simulateYuleSelection(model, lambda_0, this_f, phi, gamma = 0.01, this_N, min_num_gains = 1, model = "multiplicative")  
  #     if ( all(sim$num_gains == 1) ) {
  #       break
  #     }
  #   }
  #   
  #   # store the tree
  #   trees[[j]] <- sim
  #   
  #   setTxtProgressBar(bar, j / reps)
  #   
  # }
  # close(bar)

  # compute edge lengths
  tree_lengths <- sapply(trees, function(x) sum(x$phy$edge.length))
  mean_tree_length <- mean(tree_lengths)
  
  # number of transitions
  num_gains <- sapply(trees, function(x) x$num_gains)
  mean_num_gains <- mean(num_gains)
  
  # compute probability of invariant site
  invariant_site <- rep("A", this_N)
  names(invariant_site) <- trees[[1]]$phy$tip.label
  invariant_site <- as.phyDat(invariant_site)
  
  prob_variable <- numeric(reps)
  for(j in 1:reps) {
    
    # get the tree
    tree <- trees[[j]]$phy
    
    # compute the likelihood
    likelihood <- pml(tree, invariant_site, rate = gamma / 3)
    
    # compute probability of variable site
    prob_variable[j] <- 1 - 4 * exp(likelihood$logLik)
    
  }
  mean_prob_variable <- mean(prob_variable)
  
  # compute the expected number of polymorphic sites
  exected_num_variable_sites <- genome_size * mean_prob_variable
  cat("\texpected number of polymorphic sites: ", exected_num_variable_sites, "\n", sep = "")
  
  res <- data.frame(ntips  = this_N,
                    nsites = this_L,
                    factor = this_f,
                    npoly  = exected_num_variable_sites)

  return(res)
    
}))















