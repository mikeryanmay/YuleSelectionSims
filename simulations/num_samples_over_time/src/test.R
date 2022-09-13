# setwd("simulations/num_samples_over_time/")

library(deSolve)
library(pracma)
library(microbenchmark)
source("src/matrixModel.R")

# mutation rate
genome_size <- 30000
mutation_rate_per_site_per_year <- 0.00084
mutation_rate_per_site_per_day  <- mutation_rate_per_site_per_year / 365
gamma <- mutation_rate_per_site_per_day

# diversification rates
r0      <- 2.5
phi     <- 0.2
lambda0 <- r0 * phi
lambda1 <- 2 * lambda0

# read a dataset
dir  <- "../empirical_single_site/sims/tips_100_f_1.5/rep_1/"
tree <- read.nexus(paste0(dir, "tree.nex"))
seq  <- read.nexus.data(paste0(dir, "seq.nex"))
seq  <- t(t(sapply(seq, head, n = 1)))

# format the data as sample times and sampled states
temporal_data <- getSampleData(tree, seq)

# get the kmax
# kmax <- nrow(temporal_data)
# kmax <- 20C
kmax <- 50
# kmax <- 100
# kmax <- 200

# number of state combinations
choose(kmax + 2, 2) - 1     # triangle
(kmax + 1) * (kmax + 1) - 1 # all possible combinations

# make all the states
states       <- enumerateStates(kmax)
state_labels <- makeStateLabels(kmax)

# make the matrix
Q <- makeMatrix(lambda0, lambda1, phi, gamma, kmax)

# try exponentiation
t <- 1.5
A <- expm::expm(Q * t, method = "R_Eigen")
B <- expm::expm(Q * t, method = "AlMohy-Hi09")
C <- expm::expm.Higham08(Q * t, balancing = FALSE)

# check if they're the same
head(rowSums(A))
head(rowSums(B))
head(rowSums(C))

# initial value
p <- numeric(nrow(states))
p[1] <- 1.0

# ode solver
ode <- function(time) {
  solve <- ode45(function(t, y, ...) {
    as.matrix(y[,1] %*% Q)
  }, t0 = 0, tfinal = time, y0 = p, atol = 1e-8, rtol = 1e-8)
}

# use the solver
solve <- ode(t)

head(solve$y[nrow(solve$y),])
head((p %*% C)[1,])

mb <- microbenchmark(
  expm::expm(Q * t, method = "R_Eigen", do.sparseMsg = FALSE),
  expm::expm(Q * t, method = "AlMohy-Hi09", do.sparseMsg = FALSE),
  expm::expm.Higham08(Q * t, balancing = FALSE),
  ode(t),
  times = 5
)
mb

solve2 <- deSolve::ode(y = p, times = c(0, t), func = function(t, y, ...) {
  list((y %*% Q)[1,])
})

head(solve2[2,-1])
head(solve$y[nrow(solve$y),])

mb <- microbenchmark(
  ode45(function(t, y, ...) {
    as.matrix(y[,1] %*% Q)
  }, t0 = 0, tfinal = t, y0 = p, atol = 1e-8, rtol = 1e-8),
  deSolve::ode(y = p, times = c(0, t), func = function(t, y, ...) {
    list((y %*% Q)[1,])
  }, method = "lsoda", atol = 1e-8, rtol = 1e-8),
  deSolve::ode(y = p, times = c(0, t), func = function(t, y, ...) {
    list((y %*% Q)[1,])
  }, method = "ode45", atol = 1e-8, rtol = 1e-8, parms = list()),
  deSolve::ode(y = p, times = c(0, t), func = function(t, y, ...) {
    list((y %*% Q)[1,])
  }, method = "adams", atol = 1e-8, rtol = 1e-8, parms = list()),
  times = 5
)
mb

A <- ode45(function(t, y, ...) {
  as.matrix(y[,1] %*% Q)
}, t0 = 0, tfinal = t, y0 = p, atol = 1e-8, rtol = 1e-8)

B <- deSolve::ode(y = p, times = c(0, t), func = function(t, y, ...) {
  list((y %*% Q)[1,])
}, method = "lsoda", atol = 1e-8, rtol = 1e-8)

C <- deSolve::ode(y = p, times = c(0, t), func = function(t, y, ...) {
  list((y %*% Q)[1,])
}, method = "ode45", atol = 1e-8, rtol = 1e-8, parms = list())

D <- deSolve::ode(y = p, times = c(0, t), func = function(t, y, ...) {
  list((y %*% Q)[1,])
}, method = "adams", atol = 1e-8, rtol = 1e-8, parms = list())


head(A$y[nrow(A$y),])
head(B[2,-1])
head(C[2,-1])
head(D[2,-1])


# compare matrix multiplication
D <- as.matrix(Q)

head((p %*% Q)[1,])
head((p %*% D)[1,])

microbenchmark(
  p %*% Q,
  p %*% D,
  times = 100
)


