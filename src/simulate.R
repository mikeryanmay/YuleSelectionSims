library(ape)
library(phangorn)
library(parallel)

simulatePolymorphicNeutralSites <- function(tree, gamma, num_sites) {

  # upscale the number of sites to simulate
  empirical_estimated_num_sites <- num_sites
  
  # simulate the sites
  sites <- as.DNAbin(simSeq(tree, l = empirical_estimated_num_sites, rate = gamma / 3))
  
  repeat {
    
    # determine which sites are variable
    sites <- sites[,apply(sites, 2, function(x) length(unique(x))) > 1]
    
    # check if there are enough
    if ( ncol(sites) < num_sites ) {
      
      # simulate some new sites
      new_sites <- as.DNAbin(simSeq(tree, l = empirical_estimated_num_sites, rate = gamma / 3))
      
      # add to existing sites
      sites <- cbind(sites, new_sites)
      
    } else {
      sites <- sites[,1:num_sites]
      break
    }
    
  }
  
  return(sites)
  
}

simulateYuleSelection <- function(S, lambda0, delta, phi, gamma, n, min_num_gains = 1, model = "additive", verbose = FALSE) {
  
  num_sims  <- 0
  num_gains <- 0
  while (any(num_gains < min_num_gains)) {
    
    sim <- NULL
    while ( is.null(sim) ) {
      sim <- simulateYuleSelectionTree(S, lambda0, delta, phi, gamma, n, model)  
    }
    
    num_gains <- sim$num_gains
    num_sims  <- num_sims + 1
    
    if ( verbose == TRUE ) {
      cat(num_sims, "\n")
    }
    
  }
  
  # append the number of simulations
  sim$num_sims <- num_sims
  
  # done
  return(sim)
    
}

additiveFitnessFunction <- function(S, lambda0, delta) {
 
  # get the number of sites
  num_sites <- length(S)
  
  # enumerate all state combinations
  nucleotides <- c("A","C","G","T")
  state_combos <- expand.grid(lapply(1:num_sites, function(x) nucleotides), stringsAsFactors = FALSE)
  states <- apply(state_combos, 1, paste0, collapse = "")
  
  # compute the fitness for each state
  fitness <- apply(state_combos, 1, function(x) {
    lambda0 * prod(ifelse(x == S, delta, 1))
  })
  names(fitness) <- states
  
  return(fitness)
    
}

multiplicativeFitnessFunction <- function(S, lambda0, delta) {
  
  # get the number of sites
  num_sites <- length(S)
  
  # enumerate all state combinations
  nucleotides <- c("A","C","G","T")
  state_combos <- expand.grid(lapply(1:num_sites, function(x) nucleotides), stringsAsFactors = FALSE)
  states <- apply(state_combos, 1, paste0, collapse = "")
  
  # compute the fitness for each state
  fitness <- apply(state_combos, 1, function(x) {
    lambda0 * prod(ifelse(x == S, delta, 1))
  })
  names(fitness) <- states
  
  return(fitness)
  
}

simulateYuleSelectionTree <- function(S, lambda0, delta, phi, gamma, n, model = "additive") {
  
  # get the number of sites
  num_sites <- length(S)
  nucleotides <- c("A","C","G","T")
  
  # scale the mutation rate by the number of sites
  gamma <- gamma * num_sites
  
  if ( model == "additive" ) {
    fitness <- additiveFitnessFunction(S, lambda0, delta)
  } else if ( model == "multiplicative" ) {
    fitness <- multiplicativeFitnessFunction(S, lambda0, delta)
  } else {
    stop("Please specify either additive or multiplicative model.")
  }
  
  # choose a random starting state
  init_state <- sample(names(fitness[fitness == lambda0]), size = 1)
  
  # compute the (maximum) number of lineages (including the stem)
  num_lineages <- 2 * n - 1
  
  # pre-allocate the lineage container
  lineages   <- data.frame(anc = rep(NA, num_lineages), desc = NA, start = NA, end = NA, state = NA, fitness = NA, active = FALSE)
  
  # initialize the stem
  lineages[1,]$anc     <- 0
  lineages[1,]$start   <- 0
  lineages[1,]$state   <- init_state
  lineages[1,]$fitness <- fitness[init_state]
  lineages[1,]$active  <- TRUE
  
  # incrementers
  num_lineages <- 1
  node_index   <- n + 1
  num_samples  <- 0
  num_gains    <- numeric(num_sites)
  current_time <- 0
  
  # simulate
  repeat {
    
    # determine the active lineages
    active_lineage_index <- which(lineages$active)
    
    # compute the number of active lineages
    num_active <- length(active_lineage_index)
    
    # cat(num_active, "\t", num_samples, "\n", sep = "")
    
    # stop if the number of samples is n (complete) or n is 0 (extinct)
    if ( num_active == 0 || num_active + num_samples == n ) {
      break
    } else if ( num_active + num_samples > n ) {
      stop("Too many samples... what happened?")
    }
    
    # otherwise, choose a waiting time for each lineage
    active_fitnesses <- lineages$fitness[active_lineage_index]
    active_rates     <- active_fitnesses + phi + gamma
    
    # simulate waiting times
    next_event_times <- rexp(num_active, rate = active_rates)
    current_time     <- current_time + min(next_event_times)
    
    # choose the lineage on which an event occurs
    event_lineage <- active_lineage_index[which.min(next_event_times)]
    
    # choose the type of event
    this_lineage_fitness <- lineages$fitness[event_lineage]
    relative_event_probs <- c(this_lineage_fitness, phi, gamma) / (this_lineage_fitness + phi + gamma)
    event_type           <- sample.int(3, size = 1, prob = relative_event_probs)
    
    # perform the event
    if (event_type == 1) {
      # speciation event
      
      # terminate the current lineage
      lineages[event_lineage,]$desc   <- node_index
      lineages[event_lineage,]$end    <- current_time
      lineages[event_lineage,]$active <- FALSE
      
      # add the two new lineages
      lineages[num_lineages + 1,]$anc     <- node_index
      lineages[num_lineages + 1,]$start   <- current_time
      lineages[num_lineages + 1,]$state   <- lineages[event_lineage,]$state
      lineages[num_lineages + 1,]$fitness <- lineages[event_lineage,]$fitness
      lineages[num_lineages + 1,]$active  <- TRUE

      lineages[num_lineages + 2,]$anc     <- node_index
      lineages[num_lineages + 2,]$start   <- current_time
      lineages[num_lineages + 2,]$state   <- lineages[event_lineage,]$state
      lineages[num_lineages + 2,]$fitness <- lineages[event_lineage,]$fitness
      lineages[num_lineages + 2,]$active  <- TRUE
      
      # increment the counters
      node_index   <- node_index + 1
      num_lineages <- num_lineages + 2
        
    } else if (event_type == 2) {
      # sampling event
      num_samples <- num_samples + 1
      lineages[event_lineage,]$desc   <- num_samples
      lineages[event_lineage,]$end    <- current_time
      lineages[event_lineage,]$active <- FALSE
    } else if (event_type == 3) {
      # mutation event
      
      # get the current state
      current_state <- lineages[event_lineage,]$state
      
      # choose which site mutates
      site_index <- sample.int(num_sites, size = 1)
      
      # get the state at this site
      current_site_state <- substr(current_state, site_index, site_index)
      
      # get the new state for this site
      new_site_state <- sample(nucleotides[nucleotides != current_site_state], size = 1)
      
      # create the new state
      new_state <- current_state
      substr(new_state, site_index, site_index) <- new_site_state
      
      # keep track if this is a new gain
      if ( new_site_state == S[site_index] ) {
        num_gains[site_index] <- num_gains[site_index] + 1
      }
      
      # update the lineage
      lineages[event_lineage,]$state   <- new_state
      lineages[event_lineage,]$fitness <- fitness[new_state]
        
    } else {
      stop("Invalid event type... what happened?")
    }
    
  }
  
  # get to the end
  num_active <- sum(lineages$active)
  if ( (num_samples + num_active) != n ) {
    # dead simulation
    return(NULL)
  } else {
    # we survived!    
  }
  
  # add some extra time
  active_fitnesses <- lineages$fitness[active_lineage_index]
  active_rates     <- active_fitnesses + phi + gamma
  next_event_times <- rexp(num_active, rate = active_rates)
  current_time     <- current_time + min(next_event_times)
  
  # finalize the lineages
  lineages[lineages$active,]$desc <- num_samples + 1:num_active
  lineages[lineages$active,]$end  <- current_time
  
  # create the phylo object
  edge        <- as.matrix(lineages[-1,1:2])
  edge.length <- (lineages$end - lineages$start)[-1]
  tip.label   <- paste0("t_", 1:n)
  Nnode       <- length(tip.label) - 1
  root.edge   <- lineages[1,]$end
  phy         <- list(edge        = edge, 
                      edge.length = edge.length,
                      tip.label   = tip.label,
                      Nnode       = Nnode,
                      root.edge   = root.edge)
  class(phy) <- "phylo"
  
  # create the sequence alignment
  seq <- matrix(lineages$state[lineages$desc <= n], ncol = 1)
  rownames(seq) <- paste0("t_", lineages$desc[lineages$desc <= n])
  seq <- t(t(seq[tip.label,]))

  # get sequences for nodes
  nodes <- sort(lineages$desc[lineages$desc > n])
  nodeseq <- matrix(lineages$state[match(nodes, lineages$desc)], ncol = 1)
  rownames(nodeseq) <- nodes
  
  # if we have more than one site we need to split the sequence string into a matrix
  if ( num_sites > 1 ) {
    
    # tip data
    seq_tax <- rownames(seq)
    seq <- do.call(rbind, strsplit(seq, ""))
    rownames(seq) <- seq_tax

    # internal data
    nodeseq_tax <- rownames(nodeseq)
    nodeseq <- do.call(rbind, strsplit(nodeseq, ""))
    rownames(nodeseq) <- nodeseq_tax
    
  }
  
  # return tree and alignment
  res <- list(phy = phy, seq = seq, nodeseq = nodeseq, num_gains = num_gains)
  return(res)
    
}


simulateYuleSelectionTreeSingleton <- function(S, lambda0, delta, phi, gamma, n, model = "additive") {
  
  # get the number of sites
  num_sites <- length(S)
  nucleotides <- c("A","C","G","T")
  
  # scale the mutation rate by the number of sites
  gamma_per_site <- gamma
  gamma <- gamma * num_sites
  
  if ( model == "additive" ) {
    fitness <- additiveFitnessFunction(S, lambda0, delta)
  } else if ( model == "multiplicative" ) {
    fitness <- multiplicativeFitnessFunction(S, lambda0, delta)
  } else {
    stop("Please specify either additive or multiplicative model.")
  }
  
  # choose a random starting state
  init_state <- sample(names(fitness[fitness == lambda0]), size = 1)
  
  # compute the (maximum) number of lineages (including the stem)
  num_lineages <- 2 * n - 1
  
  # pre-allocate the lineage container
  lineages   <- data.frame(anc = rep(NA, num_lineages), desc = NA, start = NA, end = NA, state = NA, fitness = NA, active = FALSE)
  
  # initialize the stem
  lineages[1,]$anc     <- 0
  lineages[1,]$start   <- 0
  lineages[1,]$state   <- init_state
  lineages[1,]$fitness <- fitness[init_state]
  lineages[1,]$active  <- TRUE
  
  # incrementers
  num_lineages <- 1
  node_index   <- n + 1
  num_samples  <- 0
  num_gains    <- numeric(num_sites)
  current_time <- 0
  
  # simulate
  repeat {
    
    # determine the active lineages
    active_lineage_index <- which(lineages$active)
    
    # compute the number of active lineages
    num_active <- length(active_lineage_index)
    
    # cat(num_active, "\t", num_samples, "\n", sep = "")
    
    # stop if the number of samples is n (complete) or n is 0 (extinct)
    if ( num_active == 0 || num_active + num_samples == n ) {
      break
    } else if ( num_active + num_samples > n ) {
      stop("Too many samples... what happened?")
    }
    
    # otherwise, choose a waiting time for each lineage
    active_fitnesses <- lineages$fitness[active_lineage_index]
    active_rates     <- active_fitnesses + phi + gamma
    
    # simulate waiting times
    next_event_times <- rexp(num_active, rate = active_rates)
    current_time     <- current_time + min(next_event_times)
    
    # choose the lineage on which an event occurs
    event_lineage <- active_lineage_index[which.min(next_event_times)]
    
    # choose the type of event
    this_lineage_fitness <- lineages$fitness[event_lineage]
    relative_event_probs <- c(this_lineage_fitness, phi, gamma) / (this_lineage_fitness + phi + gamma)
    event_type           <- sample.int(3, size = 1, prob = relative_event_probs)
    
    # perform the event
    if (event_type == 1) {
      # speciation event
      
      # terminate the current lineage
      lineages[event_lineage,]$desc   <- node_index
      lineages[event_lineage,]$end    <- current_time
      lineages[event_lineage,]$active <- FALSE
      
      # add the two new lineages
      lineages[num_lineages + 1,]$anc     <- node_index
      lineages[num_lineages + 1,]$start   <- current_time
      lineages[num_lineages + 1,]$state   <- lineages[event_lineage,]$state
      lineages[num_lineages + 1,]$fitness <- lineages[event_lineage,]$fitness
      lineages[num_lineages + 1,]$active  <- TRUE
      
      lineages[num_lineages + 2,]$anc     <- node_index
      lineages[num_lineages + 2,]$start   <- current_time
      lineages[num_lineages + 2,]$state   <- lineages[event_lineage,]$state
      lineages[num_lineages + 2,]$fitness <- lineages[event_lineage,]$fitness
      lineages[num_lineages + 2,]$active  <- TRUE
      
      # increment the counters
      node_index   <- node_index + 1
      num_lineages <- num_lineages + 2
      
    } else if (event_type == 2) {
      # sampling event
      num_samples <- num_samples + 1
      lineages[event_lineage,]$desc   <- num_samples
      lineages[event_lineage,]$end    <- current_time
      lineages[event_lineage,]$active <- FALSE
    } else if (event_type == 3) {
      
      # mutation event
      
      # get the current state
      current_state <- lineages[event_lineage,]$state
      
      # choose which site mutates
      site_index <- sample.int(num_sites, size = 1, prob = as.numeric(num_gains == 0))
      
      # get the state at this site
      current_site_state <- substr(current_state, site_index, site_index)
      
      # get the new state for this site
      new_site_state <- S[site_index]
      
      # create the new state
      new_state <- current_state
      substr(new_state, site_index, site_index) <- new_site_state
      
      # keep track if this is a new gain
      num_gains[site_index] <- 1
      
      # decrement total mutation rate
      gamma <- gamma - gamma_per_site
      
      # update the lineage
      lineages[event_lineage,]$state   <- new_state
      lineages[event_lineage,]$fitness <- fitness[new_state]
      
    } else {
      stop("Invalid event type... what happened?")
    }
    
  }
  
  # get to the end
  num_active <- sum(lineages$active)
  if ( (num_samples + num_active) != n ) {
    # dead simulation
    return(NULL)
  } else {
    # we survived!    
  }
  
  # add some extra time
  active_fitnesses <- lineages$fitness[active_lineage_index]
  active_rates     <- active_fitnesses + phi + gamma
  next_event_times <- rexp(num_active, rate = active_rates)
  current_time     <- current_time + min(next_event_times)
  
  # finalize the lineages
  lineages[lineages$active,]$desc <- num_samples + 1:num_active
  lineages[lineages$active,]$end  <- current_time
  
  # create the phylo object
  edge        <- as.matrix(lineages[-1,1:2])
  edge.length <- (lineages$end - lineages$start)[-1]
  tip.label   <- paste0("t_", 1:n)
  Nnode       <- length(tip.label) - 1
  root.edge   <- lineages[1,]$end
  phy         <- list(edge        = edge, 
                      edge.length = edge.length,
                      tip.label   = tip.label,
                      Nnode       = Nnode,
                      root.edge   = root.edge)
  class(phy) <- "phylo"
  
  # create the sequence alignment
  seq <- matrix(lineages$state[lineages$desc <= n], ncol = 1)
  rownames(seq) <- paste0("t_", lineages$desc[lineages$desc <= n])
  seq <- t(t(seq[tip.label,]))
  
  # get sequences for nodes
  nodes <- sort(lineages$desc[lineages$desc > n])
  nodeseq <- matrix(lineages$state[match(nodes, lineages$desc)], ncol = 1)
  rownames(nodeseq) <- nodes
  
  # if we have more than one site we need to split the sequence string into a matrix
  if ( num_sites > 1 ) {
    
    # tip data
    seq_tax <- rownames(seq)
    seq <- do.call(rbind, strsplit(seq, ""))
    rownames(seq) <- seq_tax
    
    # internal data
    nodeseq_tax <- rownames(nodeseq)
    nodeseq <- do.call(rbind, strsplit(nodeseq, ""))
    rownames(nodeseq) <- nodeseq_tax
    
  }
  
  # return tree and alignment
  res <- list(phy = phy, seq = seq, nodeseq = nodeseq, num_gains = num_gains)
  return(res)
  
}


# make the initial sequence
initial_state <- function(states, L, M) {
  
  # sample an initial state with minimal fitness
  sim <- numeric(L)
  for(i in 1:L) {
    sim[i] <- sample(states[states != M[i]], size = 1)
  }
  return(sim)
  
}

computeNumGains <- function(tree, optimal_sequence) {
  
  # store the data
  data <- tree$dat
  
  # find all the mutation events
  mutation_edges <- which(data$status == "mutation")
  num_mutation_edges <- length(mutation_edges)
  
  # determine if each mutation event is to the selected state
  n <- 0
  for(i in seq_len(num_mutation_edges)) {
    
    # get this edge
    this_edge <- mutation_edges[i]
    
    # get this node index
    this_idx <- data[this_edge,]$desc
    
    # find the state of the descendant edge
    this_state <- data[data$anc == this_idx,]$seq[[1]]
    
    # increment the counter if it matches the optimal state
    if (all(this_state == optimal_sequence)) {
      n <- n + 1
    }
    
  }
  
  return(n)
  
}

Tree <- setRefClass(
  
  "Tree",
  
  fields = c(
    
    "dat",
    "labels",
    
    "lambda0",
    "gamma",
    "delta",
    "mu",
    "phi",
    "rho",
    "rhoTimes",
    "L",
    "M",
    
    "newick_string",
    
    "horizontal_coordinates",
    "horiz_idx",
    "vertical_coordinates",
    "vert_idx",
    "index",
    
    "num_independent_gains"
    
  ),
  
  methods = list(
    
    initialize = function(data,
                          lambda0_,
                          gamma_,
                          delta_,
                          mu_,
                          phi_,
                          rho_,
                          rhoTimes_,
                          L_,
                          M_
    ) {
      
      # assign the data frame
      dat <<- data
      
      # assign parameters
      lambda0 <<- lambda0_
      gamma <<- gamma_
      delta <<- delta_
      mu <<- mu_
      phi <<- phi_
      rho <<- rho_
      rhoTimes <<- rhoTimes_
      L <<- L_
      M <<- M_
      
      # ladderize the tree
      ladderize()
      
    },
    
    getAlignment = function() {
      
      # make the matrix
      aln <- do.call(rbind, dat$seq)
      
      # make the labels
      rownames(aln) <- labels
      
      # make into DNAbin
      aln <- as.DNAbin(aln)
      
      # remove the nodes that aren't sampled
      aln <- aln[dat$status == "sampled",]
      
      # return
      return(aln)
      
    },
    
    computeNumGains = function() {
      
      # reset the counter
      num_independent_gains <<- 0
      
      # call on stem
      recursiveComputeNumGains(1)
      
      return(num_independent_gains)
      
    },
    
    recursiveComputeNumGains = function(index) {
      
      # get the end state for this edge
      this_row <- which(dat$desc == index)
      this_seq <- dat[this_row,]$seq[[1]]
      
      # check whether it's the optimal sequence
      if ( all(this_seq == M) == TRUE ) {
        num_independent_gains <<- num_independent_gains + 1
      } else {
        # call on descendants
        descendants <- dat[dat$anc == index,]$desc
        num_descendants <- length(descendants)
        for(i in seq_len(num_descendants)) {
          recursiveComputeNumGains(descendants[i])
        }
        
      }
      
    },
    
    makeNewickString = function() {
      
      # make the newick string empty
      newick_string <<- ""
      recursiveWriteNewickString(1, 0)
      
      # append final semicolon
      newick_string <<- paste0(newick_string, ";")
      
    },
    
    recursiveWriteNewickString = function(index, cumulative_time = 0) {
      
      # get the type of event
      edge_index <- which(dat$desc == index)
      event_type <- dat[edge_index,]$status
      
      # get the branch length
      bl <- dat[edge_index,]$t1 - dat[edge_index,]$t0
      
      # add to the string
      if ( event_type == "internal" ) {
        # if this is a node
        
        # open parens
        newick_string <<- paste0(newick_string, "(")
        
        # call on descendants
        descendants <- dat[dat$anc == index,]$desc
        num_descendants <- length(descendants)
        for(i in seq_len(num_descendants)) {
          # write newick string for descendant
          recursiveWriteNewickString(descendants[i], 0)
          
          # add a comma after each descendant
          if (i != num_descendants) {
            newick_string <<- paste0(newick_string, ",")
          }
        }
        
        # close parens
        newick_string <<- paste0(newick_string, ")")
        
        # add branch length
        newick_string <<- paste0(newick_string, ":", bl + cumulative_time)
        
      } else if ( event_type == "sampled" ) {
        # if this is a tip
        
        # add the tip label
        this_label <- labels[dat$desc == index]
        newick_string <<- paste0(newick_string, this_label)
        
        # add branch length
        newick_string <<- paste0(newick_string, ":", bl + cumulative_time)
        
      } else if ( event_type == "mutation" ) {
        # if this is a knuckle
        
        # accumulate branch length and pass to descendant
        descendant <- dat[dat$anc == index,]$desc
        recursiveWriteNewickString(descendant, bl + cumulative_time)
        
      }
      
    },
    
    copy = function() {
      
      return(Tree$new(dat, lambda0, gamma, delta, mu, phi, rho, rhoTimes, L, M))
      
    },
    
    prune = function() {
      
      # get the number of descendants on the left and right
      dat$num_sampled_descendants <<- rep(NA, nrow(dat))
      recursiveComputeNumSampledDescendants(1)
      
      # drop any lineages where num sampled is 0
      dat <<- dat[dat$num_sampled_descendants != 0,]
      
      # reindex the tree
      
      # get all the indexes
      old_index <- unique(c(dat$anc, dat$desc))
      new_index <- 1:length(old_index) - 1
      dat$anc  <<- new_index[match(dat$anc, old_index)]
      dat$desc <<- new_index[match(dat$desc, old_index)]
      
      # relabel knuckles
      relabelKnuckles()
      
      # ladderize the tree
      ladderize()
      
    },
    
    relabelKnuckles = function() {
      
      # get all internals
      row_indices <- which(dat$status == "internal")
      
      # for each internal, check if it has two immediate descendants
      for(i in 1:length(row_indices)) {
        
        # get the label
        this_index <- dat$desc[row_indices[i]]
        
        # compute the number of immediate descendants
        num_descendants <- sum(dat$anc == this_index)
        
        # relabel if it has one descendant
        if (num_descendants == 1) {
          dat$status[row_indices[i]] <<- "knuckle"
        }
        
      }
      
    },
    
    recursiveComputeNumSampledDescendants = function(index) {
      
      # if this is a tip, set the number to 1
      if ( dat$status[dat$desc == index] %in% c("sampled") ) {
        dat$num_sampled_descendants[dat$desc == index] <<- 1
      } else if (dat$status[dat$desc == index] %in% c("unsampled", "extinct")) {
        dat$num_sampled_descendants[dat$desc == index] <<- 0
      } else {
        
        # compute the number of descendants for all daughters
        desc_idx <- dat$desc[dat$anc == index]
        for(i in seq_len(length(desc_idx))) {
          recursiveComputeNumSampledDescendants(desc_idx[i])
        }
        
        # compute the number for this node
        dat$num_sampled_descendants[dat$desc == index] <<- sum(dat$num_sampled_descendants[desc_idx])
        
      }
      
    },
    
    ladderize = function() {
      
      # get the number of descendants on the left and right
      dat$num_descendants <<- rep(NA, nrow(dat))
      recursiveComputeNumDescendants(1)
      
      # now ladderize
      recursiveLadderizeNodes(1)
      
      # relabel
      labels <<- paste0("s", dat$desc)
      
      # populate the newick string
      makeNewickString()
      
    },
    
    recursiveComputeNumDescendants = function(index) {
      
      # if this is a tip, set the number to 1
      if ( dat$status[dat$desc == index] %in% c("sampled", "unsampled", "extinct") ) {
        dat$num_descendants[dat$desc == index] <<- 1
      } else {
        
        # compute the number of descendants for all daughters
        desc_idx <- dat$desc[dat$anc == index]
        for(i in seq_len(length(desc_idx))) {
          recursiveComputeNumDescendants(desc_idx[i])
        }
        
        # compute the number for this node
        dat$num_descendants[dat$desc == index] <<- sum(dat$num_descendants[dat$anc == index])
        # dat$num_descendants[dat$desc == index] <<- sum(dat$num_descendants[desc_idx])
        
      }
      
    },
    
    recursiveLadderizeNodes = function(index) {
      
      # if this is a tip, do nothing
      if ( dat$status[dat$desc == index] %in% c("sampled", "unsampled", "extinct") ) {
      } else {
        
        # otherwise, put the larger clades farther down the matrix
        # desc_idx <- dat$desc[dat$anc == index]
        desc_idx <- which(dat$anc == index)
        desc_num_desc <- dat$num_descendants[desc_idx]
        order_desc <- order(desc_num_desc)
        dat[desc_idx,] <<- dat[desc_idx[order_desc],]
        
        # recurse
        # desc_idx <- dat$desc[dat$anc == index]
        desc_idx <- which(dat$anc == index)
        for(i in seq_len(length(desc_idx))) {
          recursiveLadderizeNodes(desc_idx[i])
        }
        
      }
      
    },
    
    computeCoordinates = function() {
      
      # reset the coordinates
      horizontal_coordinates <<- data.frame(idx = 1:nrow(dat), x0 = NA, x1 = NA, y0 = NA, rate = NA, state = NA)
      horiz_idx <<- 1
      
      vertical_coordinates <<- data.frame(idx = 1:sum(dat$status == "internal"), x0 = NA, y0 = NA, y1 = NA, rate = NA, state = NA)
      vert_idx <<- 1
      
      # compute the coordinates recursively
      recursiveComputeCoordinates(1)
      
    },
    
    recursiveComputeCoordinates = function(index) {
      
      # get the row index
      row_index <- which(dat$desc == index)
      
      # if this node is a tip, assign a y coordinate
      if ( dat$status[dat$desc == index] %in% c("sampled", "unsampled", "extinct") ) {
        
        horizontal_coordinates[row_index,]$y0   <<- horiz_idx
        horizontal_coordinates[row_index,]$x0   <<- dat[row_index,]$t0
        horizontal_coordinates[row_index,]$x1   <<- dat[row_index,]$t1
        horizontal_coordinates[row_index,]$rate <<- dat[row_index,]$lambda
        horizontal_coordinates[row_index,]$state <<- dat[row_index,]$seq
        
        # increment the horizontal segment index
        horiz_idx <<- horiz_idx + 1
        
      } else {
        
        # otherwise, put the larger clades farther down the matrix
        
        # horizontal segment
        desc_idx <- dat$desc[dat$anc == index]
        for(i in seq_len(length(desc_idx))) {
          recursiveComputeCoordinates(desc_idx[i])
        }
        
        # compute the mean of the descendants
        horizontal_coordinates[row_index,]$y0   <<- mean(horizontal_coordinates[dat$anc == index,]$y0)
        # horizontal_coordinates[row_index,]$y0   <<- mean(horizontal_coordinates[desc_idx,]$y0)
        horizontal_coordinates[row_index,]$x0   <<- dat[row_index,]$t0
        horizontal_coordinates[row_index,]$x1   <<- dat[row_index,]$t1
        horizontal_coordinates[row_index,]$rate <<- dat[row_index,]$lambda
        horizontal_coordinates[row_index,]$state <<- dat[row_index,]$seq
        
        # vertical segment
        if ( dat$status[dat$desc == index] == "internal" ) {
          
          # add the vertical segment
          vertical_coordinates[vert_idx,]$x0   <<- dat[row_index,]$t1
          vertical_coordinates[vert_idx,]$y0   <<- horizontal_coordinates[which(dat$anc == index)[1],]$y0
          vertical_coordinates[vert_idx,]$y1   <<- horizontal_coordinates[which(dat$anc == index)[2],]$y0
          vertical_coordinates[vert_idx,]$rate <<- dat[row_index,]$lambda
          vertical_coordinates[vert_idx,]$state <<- dat[row_index,]$seq
          
          # increment the vertical segment index
          vert_idx <<- vert_idx + 1
          
        }
        
      }
      
      
    },
    
    plot = function(xlim, colors = c("blue","yellow","red"), nbins = 1001, ...) {
      
      # compute coordinates
      computeCoordinates()
      
      # compute the limits
      if ( missing(xlim) ) {
        xlim <- range(c(horizontal_coordinates$x0, horizontal_coordinates$x1))
      }
      ylim <- range(horizontal_coordinates$y0)
      
      if (all(unique(unlist(horizontal_coordinates$state)) %in% toupper(names(colors)))) {
        
        horiz_colors <- colors[tolower(unlist(horizontal_coordinates$state))]
        vert_colors  <- colors[tolower(unlist(vertical_coordinates$state))]
        
      } else {
        
        # compute the colors for each rate
        all_rates <- lambda0 + delta * 0:L
        all_rate_colors <- colorRampPalette(colors)(L + 1)
        names(all_rate_colors) <- all_rates
        
        # compute the colors for each interval
        horiz_colors <- all_rate_colors[as.character(horizontal_coordinates$rate)]
        vert_colors  <- all_rate_colors[as.character(vertical_coordinates$rate)]
        
      }
      
      # plot the coordinates
      plot.default(NA, xlim = xlim, ylim = ylim, ...)
      
      # add horizontal segments
      segments(x0 = horizontal_coordinates$x0,
               x1 = horizontal_coordinates$x1,
               y0 = horizontal_coordinates$y0,
               col = horiz_colors, ...)
      
      # add the vertical segments
      segments(x0 = vertical_coordinates$x0,
               y0 = vertical_coordinates$y0,
               y1 = vertical_coordinates$y1,
               col = vert_colors, ...)
      
    }
    
  )
  
)

getFitnessForSequence <- function(sequence, map, lambda0, delta) {
  lambda0 + delta * sum(sequence == map)
}

simulateBirthDeathFitnessModelConditional <- function(
    gamma,     # the mutation rate
    L,         # the number of sites
    M,         # the fitness map
    lambda0,   # the base fitness
    delta,     # the fitness effect
    mu,        # the extinction rate
    phi,       # the continuous sampling rate
    rho,       # the sampling fraction at given times
    rhoTimes,  # the times at which sampling occurs (measures from the initial time, t = 0)
    initState, # the initial state of the process
    t,         # the time to simulate for
    states = c("A","C","G","T"),
    NMAX = 5000,
    ...
) {

  repeat {

    sim <- simulateBirthDeathFitnessModel(gamma,
                                          L,
                                          M,
                                          lambda0,
                                          delta,
                                          mu,
                                          phi,
                                          rho,
                                          rhoTimes,
                                          initState,
                                          t,
                                          states = c("A","C","G","T"),
                                          NMAX = 5000,
                                          ...)

    # condition on survival
    if ( is.null(sim) == FALSE ) {
      if ( "sampled" %in% sim[sim$t1 == t,]$status ) {
        # cat("!\n", sep = "")
        return(Tree$new(sim, lambda0, gamma, delta, mu, phi, rho, rhoTimes, L, M))
      } else {
        # cat("*", sep = "")
        # cat("Tree went extinct.\n")
      }
    } else {
      # cat("-", sep = "")
      # cat("Tree got too big.\n")
    }

  }

  # cat("\n", sep = "")

}

simulateBirthDeathFitnessModel <- function(
    gamma,     # the mutation rate
    L,         # the number of sites
    M,         # the fitness map
    lambda0,   # the base fitness
    delta,     # the fitness effect
    mu,        # the extinction rate
    phi,       # the continuous sampling rate
    rho,       # the sampling fraction at given times
    rhoTimes,  # the times at which sampling occurs (measures from the initial time, t = 0)
    initState, # the initial state of the process
    t,         # the time to simulate for
    states = c("A","C","G","T"),
    NMAX = 5000,
    ...
) {

  # some precomputations
  gamma_total <- gamma * L

  # get the initial state
  if ( class(initState) == "function" ) {
    init_state <- initState(states, L, M)
  } else if ( initState == "stationary" ) {
    init_state <- sample(states, L, replace = TRUE)
  } else {
    init_state <- initState
  }

  # initialize a container
  df <- vector("list", NMAX)
  df[[1]] <- data.frame(t0  = 0, t1 = NA,  lambda = getFitnessForSequence(init_state, M, lambda0, delta), seq = I(list(init_state)),
                        anc = 0, desc = 1, status = "internal", stringsAsFactors = FALSE)

  # initialize the process
  current_index <- 1
  num_lineages  <- 1
  num_extant    <- 1

  # simulate
  repeat {

    # cat(num_extant, num_lineages, current_index, "\n", sep = "\t")

    # check for termination
    if ( num_extant == 0 ) {
      break
    }

    # check for too many lineages
    if ( num_lineages > NMAX ) {
      return(NULL)
    }

    # check if we've simulated everyone
    if ( is.null(df[[current_index]]) ) {
      break
    }

    # get the row
    this_lineage <- df[[current_index]]
    this_idx     <- this_lineage$desc

    # get the current time
    current_time <- this_lineage$t0

    # get the rates
    current_lambda <- this_lineage$lambda
    current_mu     <- mu
    current_gamma  <- gamma_total
    current_phi    <- phi
    total_rate     <- current_lambda + current_mu + current_gamma + current_phi

    # simulate the next event
    next_event_time <- current_time + rexp(1, total_rate)

    # check if the next time is a sampling time
    future_sample_time <- min(rhoTimes[rhoTimes > current_time])
    next_time_horizon  <- unique(c(future_sample_time, t))
    if ( length(next_event_time) == 0 ) {
      recover()
    }

    # if too long, terminate
    if ( next_event_time > next_time_horizon ) {

      # terminate at the present
      df[[current_index]]$t1 <- next_time_horizon

      # determine if it's sampled
      if ( next_time_horizon %in% rhoTimes ) {

        # get the corresponding sampling rate
        this_sample_rate <- rho[rhoTimes == next_time_horizon]

        # check if we're sampled
        is_sampled <- rbinom(1, 1, this_sample_rate)
        if ( is_sampled == 1 ) {
          df[[current_index]]$status <- "sampled"
        } else {
          df[[current_index]]$status <- "unsampled"
        }

      } else {
        df[[current_index]]$status <- "unsampled"
      }

    } else {

      # update the time
      df[[current_index]]$t1 <- next_event_time

      # pick the type of event
      event_probs <- c(current_lambda, current_mu, current_gamma, current_phi) / total_rate
      event <- sample.int(4, size = 1, prob = event_probs)

      if ( event == 1 ) {

        # get the current state
        current_sequence <- this_lineage$seq[[1]]

        # speciation event
        df[[num_lineages + 1]] <- data.frame(t0 = next_event_time, t1 = NA, lambda = current_lambda, seq = I(list(current_sequence)), anc = this_idx, desc = 1 + num_lineages, status = "internal", stringsAsFactors = FALSE)
        df[[num_lineages + 2]] <- data.frame(t0 = next_event_time, t1 = NA, lambda = current_lambda, seq = I(list(current_sequence)), anc = this_idx, desc = 2 + num_lineages, status = "internal", stringsAsFactors = FALSE)

        # increment the number of lineages
        num_lineages <- num_lineages + 2
        num_extant   <- num_extant + 1

      } else if ( event == 2 ) {

        # extinction event

        # set the lineage to an extinction event
        df[[current_index]]$status <- "extinct"

      } else if ( event == 3 ) {

        # mutation event

        # get the current state
        current_sequence <- this_lineage$seq[[1]]

        # gammatate the sequence
        mutation_position <- sample.int(L, 1)
        current_state <- current_sequence[mutation_position]
        new_state <- sample(states[states != current_state], size = 1)
        current_sequence[mutation_position] <- new_state

        # get the new fitness
        new_lambda <- getFitnessForSequence(current_sequence, M, lambda0, delta)

        # set the lineage status
        df[[current_index]]$status <- "mutation"

        # create one new lineage with the new rate
        new_lineage <- data.frame(t0 = next_event_time, t1 = NA, lambda = new_lambda, seq = I(list(current_sequence)), anc = this_idx, desc = 1 + num_lineages, status = "internal", stringsAsFactors = FALSE)

        # attach the new lineages
        df[[num_lineages + 1]] <- new_lineage

        # increment the number of lineages
        num_lineages <- num_lineages + 1

      } else if ( event == 4 ) {

        # sampling event

        # set the lineage to a sampling event (also equals extinction)
        df[[current_index]]$status <- "sampled"

      } else {
        stop("UH OH!")
      }

    }

    # increment the index
    current_index <- current_index + 1

  }

  # chop off the unused stuff
  df <- do.call(rbind, df)

}












