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

