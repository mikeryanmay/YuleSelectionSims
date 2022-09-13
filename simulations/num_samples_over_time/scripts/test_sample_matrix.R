# setwd("simulations/num_samples_over_time/")
source("src/countClass.R")

# settings
r0      <- 2.5
phi     <- 0.2
lambda0 <- r0 * phi
lambda1 <- 2 * lambda0
gamma   <- 0.05
nmax    <- 10

# make the matrix
Q  <- countMatrixModel(nmax, lambda0, lambda1, phi, gamma, gamma)
R0 <- sampleMatrixModel(nmax, phi, "0")
R1 <- sampleMatrixModel(nmax, phi, "1")

# make init p
p <- numeric(R0$num_states)
names(p) <- R0$labels
p[nmax + 1] <- 1

# integrate some time
p <- Q$solve(p, 0.5)
q <- R0$doSampleEvent(p)

p
q

q[R0$labels[R0$phi_indexes[,2]]] / p[R0$labels[R0$phi_indexes[,1]]]
