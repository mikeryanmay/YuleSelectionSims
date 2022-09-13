# setwd("simulations/num_samples_over_time/")
library(cubature)
source("src/countClass.R")

# settings
r0      <- 2.5
phi     <- 0.2
lambda0 <- r0 * phi
lambda1 <- 2.5 * lambda0
gamma   <- 0.05
nmax    <- 10

# the data
t0 <- 0   # start time
t1 <- 0.5 # time of first sample
t2 <- 1.0 # time of second sample
t3 <- 1.5 # time of third sample

x0 <- "0" # state of the original lineage
x1 <- "0" # state of sample at time t1
x2 <- "0" # state of sample at time t2
x3 <- "1" # state of sample at time t3

################################
# likelihood under count model #
################################

# make the matrices
Q  <- countMatrixModel(nmax, lambda0, lambda1, phi, gamma, gamma)
R1 <- sampleMatrixModel(nmax, phi, x1)
R2 <- sampleMatrixModel(nmax, phi, x2)

# make init p
start_state <- c("0" = 0, "1" = 0)
start_state[x0] <- 1
start_state <- paste0("(", start_state[1], ",", start_state[2], ")")

p <- numeric(Q$num_states)
names(p) <- Q$labels
p[start_state] <- 1

# integrate to time t1
p <- Q$solve(p, t1, method = "Higham08")

# do the sample event
p <- R1$doSampleEvent(p)

# integrate to time t2
p <- Q$solve(p, t2 - t1, method = "Higham08")

# do the sample event
p <- R2$doSampleEvent(p)

# integrate to time t3
p <- Q$solve(p, t3 - t2, method = "Higham08")

# get probability of present sample
end_state <- c("0" = 0, "1" = 0)
end_state[x3] <- 1
end_state <- paste0("(", end_state[1], ",", end_state[2], ")")

lik_count <- as.numeric(p[end_state])

###############################
# likelihood under tree model #
###############################

# make the transition-rate matrix
Q <- matrix(0, 3, 3, dimnames = list(c("0","1","A"), c("0","1","A")))

# mutation events
Q["0", "1"] <- gamma
Q["1", "0"] <- gamma

# all other events
Q["0", "A"] <- lambda0 + phi
Q["1", "A"] <- lambda1 + phi

# diagonals
diag(Q) <- -rowSums(Q)

# eigen decomposition for exponentiation
e     <- eigen(Q)
evals <- e$values
evec  <- e$vectors
eveci <- solve(e$vectors)

# transition probability function
transitionProbability <- function(t) evec %*% diag(exp(evals * t)) %*% eveci

# conditional probabilities for tips
x3_cond_probs <- x2_cond_probs <- x1_cond_probs <-  x0_cond_probs <- numeric(3)
names(x3_cond_probs) <- names(x2_cond_probs) <- names(x1_cond_probs) <- names(x0_cond_probs) <- c("0","1","A")

x3_cond_probs[x3] <- 1
x2_cond_probs[x2] <- phi
x1_cond_probs[x1] <- phi
x0_cond_probs[x0] <- 1

# create a likelihood function given the age of the splits
tree_likelihood_1 <- function(a1, a2, Q) {
  
  # split between x3 and x2
  left_bl  <- t3 - a2
  left_cl  <- (transitionProbability(left_bl) %*% x3_cond_probs)[,1]
  right_bl <- t2 - a2
  right_cl <- (transitionProbability(right_bl) %*% x2_cond_probs)[,1]
  a2_cl    <- 2 * left_cl * right_cl * c(lambda0, lambda1, 0)
  
  # split between a1 and x1
  left_bl  <- a2 - a1
  left_cl  <- (transitionProbability(left_bl) %*% a2_cl)[,1]
  right_bl <- t1 - a1
  right_cl <- (transitionProbability(right_bl) %*% x1_cond_probs)[,1]
  a1_cl    <- 2 * left_cl * right_cl * c(lambda0, lambda1, 0)
  
  # transition along stem branch
  stem_bl <- a1 - t0
  stem_cl <- sum( (transitionProbability(stem_bl) %*% x0_cond_probs)[,1] * a1_cl)
  
  # return
  return(stem_cl)
  
}

# tree_likelihood_1(0.1, 0.2, Q)

tree_likelihood_2 <- function(a1, a2, Q) {
  
  # split between x2 and x1
  left_bl  <- t2 - a2
  left_cl  <- (transitionProbability(left_bl) %*% x2_cond_probs)[,1]
  right_bl <- t1 - a2
  right_cl <- (transitionProbability(right_bl) %*% x1_cond_probs)[,1]
  a2_cl    <- 2 * left_cl * right_cl * c(lambda0, lambda1, 0)
  
  # split between x3 and a2
  left_bl  <- t3 - a1
  left_cl  <- (transitionProbability(left_bl) %*% x3_cond_probs)[,1]
  right_bl <- a2 - a1
  right_cl <- (transitionProbability(right_bl) %*% a2_cl)[,1]
  a1_cl    <- 2 * left_cl * right_cl * c(lambda0, lambda1, 0)
  
  # transition along stem branch
  stem_bl <- a1 - t0
  stem_cl <- sum( (transitionProbability(stem_bl) %*% x0_cond_probs)[,1] * a1_cl)
  
  # return
  return(stem_cl)
  
}

tree_likelihood_3 <- function(a1, a2, Q) {
  
  # split between x3 and x1
  left_bl  <- t3 - a2
  left_cl  <- (transitionProbability(left_bl) %*% x3_cond_probs)[,1]
  right_bl <- t1 - a2
  right_cl <- (transitionProbability(right_bl) %*% x1_cond_probs)[,1]
  a2_cl    <- 2 * left_cl * right_cl * c(lambda0, lambda1, 0)
  
  # split between x2 and a2
  left_bl  <- a2 - a1
  left_cl  <- (transitionProbability(left_bl) %*% a2_cl)[,1]
  right_bl <- t2 - a1
  right_cl <- (transitionProbability(right_bl) %*% x2_cond_probs)[,1]
  a1_cl    <- 2 * left_cl * right_cl * c(lambda0, lambda1, 0)
  
  # transition along stem branch
  stem_bl <- a1 - t0
  stem_cl <- sum( (transitionProbability(stem_bl) %*% x0_cond_probs)[,1] * a1_cl)
  
  # return
  return(stem_cl)
  
}

# integrate for tree 1
tol <- 1e-10
int_tree_1 <- integral2(function(x, y) {
  
  cat("*")
  z <- x
  for(i in 1:ncol(x)) {
    for(j in 1:nrow(x)) {
      z[i,j] <- tree_likelihood_1(x[i,j], y[i,j], Q)
    }
  }
  
  return(z)
  
}, xmin = 0, xmax = t1, ymin = function(x) x, ymax = t2, reltol = tol, abstol = tol)$Q

# integrate for tree 2
int_tree_2 <- integral2(function(x, y) {
  
  cat("*")
  z <- x
  for(i in 1:ncol(x)) {
    for(j in 1:nrow(x)) {
      z[i,j] <- tree_likelihood_2(x[i,j], y[i,j], Q)
    }
  }
  
  return(z)
  
}, xmin = 0, xmax = t1, ymin = function(x) x, ymax = t1, reltol = tol, abstol = tol)$Q


# integrate for tree 3
int_tree_3 <- integral2(function(x, y) {
  
  cat("*")
  z <- x
  for(i in 1:ncol(x)) {
    for(j in 1:nrow(x)) {
      z[i,j] <- tree_likelihood_3(x[i,j], y[i,j], Q)
    }
  }
  
  return(z)
  
}, xmin = 0, xmax = t1, ymin = function(x) x, ymax = t1, reltol = tol, abstol = tol)$Q

# combine likelihoods
lik_tree <- int_tree_1 + int_tree_2 + int_tree_3

# compare
lik_tree; lik_count
lik_tree / lik_count
sprintf("%.15f", lik_tree - lik_count)










