# setwd("simulations/num_samples_over_time/")

library(microbenchmark)
library(TESS)

source("src/countClass.R")

# combine state probabilities
combineProbs <- function(p) {
  sapply(split(p, rowSums(Q$states)), sum)
}

# settings
rho     <- 2.5
phi     <- 0
lambda0 <- rho * 1 / 7
lambda1 <- 2 * lambda0
# gamma   <- 1000 * 0.0008 / 365
gamma   <- 0.05
nmax    <- 1400

# make the matrix
Q <- countMatrixModel(nmax, lambda0, lambda1, phi, gamma, gamma)

# make init p
p <- numeric(Q$num_states)
names(p) <- Q$labels
p[nmax + 1] <- 1

# integrate some times
t   <- 15
dt  <- 0.5
ts  <- seq(0, t, dt)
nt  <- t / dt + 1
num <- matrix(0, nrow = nt, ncol = nmax)
num[1,] <- combineProbs(p)

bar <- txtProgressBar(style = 3, width = 40)
for(i in 2:nt) {
  
  # integrate one step
  p <- Q$solve(p, dt, method = "ode45", atol = 1e-6, rtol = 1e-6)
  
  # store combined probs
  num[i,] <- combineProbs(p)
  
  setTxtProgressBar(bar, i / nt)
  
}
close(bar)

plot(combineProbs(p))
# matplot(num, type = "l", lty = 1)

upper_q <- apply(num, 1, function(row) {
  min(which(cumsum(row / sum(row)) > 0.95))
})

mean <- apply(num, 1, function(row) {
  sum((1:nmax) * row)
})

# plot(ts, upper_q, type = "l", lty = 2, log = "y")
plot(ts, upper_q, type = "l", lty = 2, log = "")
lines(ts, mean)



