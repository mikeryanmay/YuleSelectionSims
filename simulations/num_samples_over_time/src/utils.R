getSampleData <- function(tree, seq) {

  # get ages from tree
  init_age <- max(tree.age(tree, order = "present", digits = 6)$age)
  if ( is.null(tree$root.edge) == FALSE ) {
    age  <- init_age + tree$root.edge
    ages <- tree.age(tree, order = "present", age = age, digits = 6)
  } else {
    ages <- tree.age(tree, order = "present", age = init_age, digits = 6)
  }

  # get the time of each event
  sample_ages <- ages[grepl("t", ages$elements),]
  
  # get the time and state for each sample
  max_age <- max(sample_ages$age)
  sample_ages$type  <- ifelse(sample_ages$ages == max_age, "extant", "sample")
  sample_ages$state <- toupper(seq[sample_ages$elements,])
  
  return(sample_ages)
  
}

enumerateStates <- function(kmax) {
  
  # the states for one allele
  states <- 0:kmax
  
  # combined states
  combined_states <- expand.grid("0" = states, "1" = states)
  
  # remove the first state
  combined_states <- combined_states[-1,]
  
  # remove any state with too large a sum
  combined_states <- combined_states[rowSums(combined_states) <= kmax,]
  
  return(combined_states)
  
}

makeStateLabelsFromStates <- function(states) {
  
  paste0("(",states[,1], ",", states[,2],")")
  
}

makeStateLabels <- function(kmax) {
  
  # make the states
  combined_states <- enumerateStates(kmax)
  
  # make the labels
  state_labels <- makeStateLabelsFromStates(combined_states)
  
  return(state_labels)
  
}

forwardSimulate <- function(t, init, lambda0, lambda1, gamma) {
  
  # start at time 0
  current_time <- 0
  
  # store number of individuals of each type
  nums <- init
  
  # simulate until end
  repeat {
    
    # get current rate
    current_rate <- nums[1] * (lambda0 + gamma) + nums[2] * (lambda1 + gamma)
    
    # increment time
    current_time <- current_time + rexp(1, current_rate)
    
    # if we exceed time, break
    if ( current_time > t ) {
      break
    }
    
    # determine type of event
    probs <- c(nums[1] * lambda0, nums[1] * gamma, nums[2] * lambda1, nums[2] * gamma) / current_rate
    event <- sample.int(4, size = 1, prob = probs)
    
    # execute event
    if (event == 1) {
      nums[1] <- nums[1] + 1
    } else if (event == 2) {
      nums[1] <- nums[1] - 1
      nums[2] <- nums[2] + 1
    } else if (event == 3) {
      nums[2] <- nums[2] + 1
    } else if (event == 4) {
      nums[1] <- nums[1] + 1
      nums[2] <- nums[2] - 1
    } else {
      stop("WTF.")
    }
    
  }
  
  return(nums)
  
}

enumerateStates <- function(nmax) {
  
  # the states for one allele
  states <- 0:nmax
  
  # combined states
  combined_states <- expand.grid("1" = states, "0" = states)
  combined_states <- combined_states[,2:1]
  
  # remove the first state
  combined_states <- combined_states[-1,]
  
  # remove any state with too large a sum
  combined_states <- combined_states[rowSums(combined_states) <= nmax,]
  
  # make names
  labels <- paste0("(",combined_states[,1], ",", combined_states[,2],")")
  rownames(combined_states) <- labels
  
  return(combined_states)
  
}

stateToReducedIndex <- function(nmax, state) {
  
  # the reduced index is in the state space constrained so that 0 < i + j <= n
  # given a state, what is the reduced index?
  # it's the full index of the state minus the number of states that have been removed below it,
  # which is the running sum of (i - 1)
  
  # get states i and j
  state_i <- state$`0`
  state_j <- state$`1`
  
  # get full index
  full_index <- state_j + state_i * (nmax + 1)
  
  # get reduced index
  offset        <- state_i - 1 + choose(state_i - 1, 2)
  reduced_index <- full_index - offset
  
  return(reduced_index)
  
}
