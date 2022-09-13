library(ape)
library(dispRity)
library(Matrix)
library(expm)

makeMatrix <- function(lambda0, lambda1, phi, gamma, kmax) {
  
  # get the states and labels
  states <- enumerateStates(kmax)
  labels <- makeStateLabelsFromStates(states)
  
  # pass on to matrix maker
  M <- makeMatrixWithStates(lambda0, lambda1, phi, gamma, states, labels)

  return(M)
    
}

makeMatrixWithStates <- function(lambda0, lambda1, phi, gamma, states, labels) {
  
  # get number of states
  num_states <- nrow(states)
  
  # make the empty matrix
  M <- spMatrix(nrow = num_states, ncol = num_states)
  
  # loop over states
  for(i in 1:num_states) {
    
    row_idx <- i
    
    # get this state
    this_state <- states[i,]
    
    # rate of leaving
    leaving_rate <- 0
    
    # mutation in state 0
    destination_state <- paste0("(", this_state[1] - 1, ",", this_state[2] + 1,")")
    r <- gamma * this_state[["0"]]
    if ( r > 0 && destination_state %in% labels ) {
      col_idx <- which(labels == destination_state)
      M[row_idx, col_idx] <- r
      leaving_rate <- leaving_rate + r
    }
    
    # mutation in state 1
    destination_state <- paste0("(", this_state[1] + 1, ",", this_state[2] - 1,")")
    r <- gamma * this_state[["1"]]
    if ( r > 0 && destination_state %in% labels ) {
      col_idx <- which(labels == destination_state)
      M[row_idx, col_idx] <- r
      leaving_rate <- leaving_rate + r
    }
    
    # birth in state 0
    destination_state <- paste0("(", this_state[1] + 1, ",", this_state[2],")")
    r <- lambda0 * this_state[["0"]]
    if ( r > 0 && destination_state %in% labels ) {
      col_idx <- which(labels == destination_state)
      M[row_idx, col_idx] <- r
    }
    leaving_rate <- leaving_rate + r
    
    # birth in state 1
    destination_state <- paste0("(", this_state[1], ",", this_state[2] + 1,")")
    r <- lambda1 * this_state[["1"]]
    if ( r > 0 && destination_state %in% labels ) {
      col_idx <- which(labels == destination_state)
      M[row_idx, col_idx] <- r
    }
    leaving_rate <- leaving_rate + r
    
    # sampling rate
    leaving_rate <- leaving_rate + sum(this_state) * phi
    
    # removal rate
    M[i,i] <- -leaving_rate
    
  }
  
  # name dimensions
  dimnames(M) <- list(labels, labels)
  
  # return
  return(M)
  
}

getSampleData <- function(tree, seq) {
  
  # get ages from tree
  init_age <- max(tree.age(tree, order = "present", digits = 6)$age)
  age <- init_age + tree$root.edge
  ages <- tree.age(tree, order = "present", age = age, digits = 6)
  
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
