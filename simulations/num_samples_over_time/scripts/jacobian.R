# setwd("simulations/num_samples_over_time/")
library(cubature)
source("src/countClass.R")

# settings
r0      <- 2.5
phi     <- 0.2
lambda0 <- r0 * phi
lambda1 <- 2.5 * lambda0
gamma   <- 0.05
nmax    <- 4

# matrix
Q  <- countMatrixModel(nmax, lambda0, lambda1, phi, gamma, gamma)

t(Q$Q) == Q$J

# vector
p <- numeric(Q$num_states)
names(p) <- Q$labels
p[nmax + 1] <- 1
p <- Q$solve(p, 0.1)

J <- jacobian(function(x) {
  (x %*% Q$Q)[1,]
}, x0 = p)

rownames(J) <- colnames(J) <- Q$labels


- Q$states[,1] * (lambda0 + gamma + phi) - Q$states[,2] * (lambda1 + gamma + phi)


