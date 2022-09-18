# setwd("simulations/validation/")
library(viridis)
library(RColorBrewer)
library(microbenchmark)
source("../../src/countClass.R", chdir = TRUE)

# settings
r0      <- 2.5
phi     <- 0.2
lambda0 <- r0 * phi
lambda1 <- 2 * lambda0
gamma   <- 0.05
nmax    <- 100

# make the matrix
Q <- countMatrixModel(nmax, lambda0, lambda1, phi, gamma, gamma)

# make init p
p <- numeric(Q$num_states)
names(p) <- Q$labels
p[nmax + 1] <- 1

# integrate a little
p <- Q$solve(p, 1, method = "ode45")

# find good tolerances for solvers
t <- 10

eigen  <- Q$solve(p, t, method = "Higham08")
pracma <- Q$solve(p, t, method = "pracma",   atol = 1e-16, rtol = 1e-16)
# rk4    <- Q$solve(p, t, method = "rk4") # very inaccurate
# ode23  <- Q$solve(p, t, method = "ode23",    atol = 1e-20, rtol = 1e-20) # not very stable
ode45  <- Q$solve(p, t, method = "ode45",    atol = 1e-16, rtol = 1e-16)
lsoda  <- Q$solve(p, t, method = "lsoda",    atol = 1e-12, rtol = 1e-12)
lsode  <- Q$solve(p, t, method = "lsode",    atol = 1e-6, rtol = 1e-6)
lsodes <- Q$solve(p, t, method = "lsodes",   atol = 1e-6, rtol = 1e-6)
radau  <- Q$solve(p, t, method = "radau",    atol = 1e-4, rtol = 1e-4)

res <- cbind(eigen, pracma, ode45, lsoda, lsode, lsodes, radau)
cols <- rep("black", ncol(res))
cols[1] <- "red"
pch <- 1:ncol(res)
pch[1] <- 19
matplot(res, log = "y", pch = pch, col = cols, xlim = c(0, nmax + 1) + 3 * nmax)
# matplot(res, log = "y", pch = pch, col = cols)
legend("topright", legend = colnames(res), pch = pch, bty = "n")

# compare runtimes for given tolerance
microbenchmark(
  Q$solve(p, t, method = "pracma", atol = 1e-16, rtol = 1e-16),
  # Q$solve(p, t, method = "rk4",    atol = tol, rtol = tol),
  # Q$solve(p, t, method = "ode23",  atol = tol, rtol = tol),
  Q$solve(p, t, method = "ode45",  atol = 1e-16, rtol = 1e-16),
  Q$solve(p, t, method = "lsoda",  atol = 1e-12, rtol = 1e-12),
  Q$solve(p, t, method = "lsode",  atol = 1e-6, rtol = 1e-6),
  Q$solve(p, t, method = "lsodes", atol = 1e-6, rtol = 1e-6),
  Q$solve(p, t, method = "radau",  atol = 1e-4, rtol = 1e-4),
  times = 5
)



