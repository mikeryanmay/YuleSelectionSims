# setwd("simulations/num_samples_over_time/")
source("src/countClass.R")

# settings
r0      <- 2.5
phi     <- 0.1
lambda0 <- r0 * phi
lambda1 <- 2.5 * lambda0
gamma   <- 0.005
nmax    <- 5

# the data
t0 <- 0   # start time
t1 <- 0.5 # time of sample
t2 <- 1.0 # end time
x0 <- "1" # state of the original lineage
x1 <- "0" # state of sample at time t1
x2 <- "1" # state of sample at time t2

################################
# likelihood under count model #
################################

# make the matrices
Q <- countMatrixModel(nmax, lambda0, lambda1, phi, gamma, gamma)
R <- sampleMatrixModel(nmax, phi, x1)

# make init p
start_state <- c("0" = 0, "1" = 0)
start_state[x0] <- 1
start_state <- paste0("(", start_state[1], ",", start_state[2], ")")

p <- numeric(R$num_states)
names(p) <- R$labels
p[start_state] <- 1

# create the events
events <- list(
  time  = t1,
  func  = function(t, y, parms) {
    if (t == t1) {
      return(y = R$doSampleEvent(y))
    } else{
      return(y = y)
    }
  }
)

# integrate all at once
q <- Q$solve(p, c(events$time, t2), method = "ode45", events = events)

# integrate to time t1
p <- Q$solve(p, t1, method = "Higham08")

# do the sample event
p <- R$doSampleEvent(p)

# integrate to time t2
p <- Q$solve(p, t2 - t1, method = "Higham08")

# get probability of present sample
end_state <- c("0" = 0, "1" = 0)
end_state[x2] <- 1
end_state <- paste0("(", end_state[1], ",", end_state[2], ")")

lik_count <- as.numeric(p[end_state])

# plot(p)
# points(q, pch = 3)

# p[end_state]
# q[end_state]

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

# create a likelihood function given the age of the split
tree_likelihood <- function(t, Q) {

  # prob of sampled descendant
  left_bl <- t1 - t
  left_cl <- phi * expm(Q * left_bl)[,x1]
  
  # prob of observed descendant
  right_bl <- t2 - t
  right_cl <- expm(Q * right_bl)[,x2]
  
  # take product
  node_cl <- left_cl * right_cl
  
  # multiply by density of speciation event
  node_cl[1] <- node_cl[1] * lambda0
  node_cl[2] <- node_cl[2] * lambda1
  
  # transition along stem branch
  stem_bl <- t - t0
  stem_cl <- sum(expm(Q * stem_bl)[x0,] * node_cl)
  
  # return
  return(stem_cl)
  
}

tree_likelihood(0.2, Q)

int <- integrate(function(t) {
  sapply(t, tree_likelihood, Q = Q)
}, lower = 0, upper = t1)
lik_tree <- int$value

# compare
lik_tree; lik_count
lik_tree / lik_count














