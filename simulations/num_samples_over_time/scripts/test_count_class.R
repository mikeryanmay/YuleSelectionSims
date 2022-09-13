# setwd("simulations/num_samples_over_time/")

library(microbenchmark)

source("src/countClass.R")

# settings
r0      <- 2.5
phi     <- 0.2
lambda0 <- r0 * phi
lambda1 <- 2 * lambda0
gamma   <- 0.05
# gamma   <- 0.00084 / 365
nmax    <- 500

# make the matrix
Q <- countMatrixModel(nmax, lambda0, lambda1, phi, gamma, gamma)

# make init p
p <- numeric(Q$num_states)
names(p) <- Q$labels
p[nmax + 1] <- 1

# integrate a little
p <- Q$solve(p, 5, method = "ode23")

# check agreement
t <- 5
tol <- 1e-8

p_pracma <- Q$solve(p, t, method = "pracma", atol = tol, rtol = tol)
p_ode45  <- Q$solve(p, t, method = "ode45", atol = tol, rtol = tol)
p_ode23  <- Q$solve(p, t, method = "ode23", atol = tol, rtol = tol)
# p_rk4    <- Q$solve(p, t, method = "rk4", atol = tol, rtol = tol) # very inaccurate
p_lsoda  <- Q$solve(p, t, method = "lsoda", atol = tol, rtol = tol)
p_lsode  <- Q$solve(p, t, method = "lsode", atol = tol, rtol = tol)
p_lsodes <- Q$solve(p, t, method = "lsodes", atol = tol, rtol = tol)
p_radau  <- Q$solve(p, t, method = "radau", atol = tol, rtol = tol)
# p_higham <- Q$solve(p, t, method = "Higham08", atol = tol, rtol = tol)

plot(p_pracma)
points(p_ode45, pch = 2)
points(p_ode23, pch = 3)
# points(p_rk4, pch = 4)
points(p_lsoda, pch = 5)
points(p_lsode, pch = 6)
points(p_lsodes, pch = 7)
points(p_radau, pch = 8)

# compare performance
microbenchmark(
  Q$solve(p, t, method = "pracma", atol = tol, rtol = tol),
  Q$solve(p, t, method = "ode45",  atol = tol, rtol = tol),
  Q$solve(p, t, method = "ode23",  atol = tol, rtol = tol),
  # Q$solve(p, t, method = "rk4",  atol = tol, rtol = tol),
  # Q$solve(p, t, method = "lsoda",  atol = tol, rtol = tol),
  # Q$solve(p, t, method = "lsode",  atol = tol, rtol = tol),
  # Q$solve(p, t, method = "lsodes", atol = tol, rtol = tol),
  # Q$solve(p, t, method = "radau",  atol = tol, rtol = tol),
  times = 5
)

microbenchmark(
  Q$solve(p, 0.1, method = "ode45"),
  Q$solve(p, 0.2, method = "ode45"),
  Q$solve(p, 0.4, method = "ode45"),
  Q$solve(p, 0.8, method = "ode45"),
  Q$solve(p, 1.6, method = "ode45"),
  times = 5
)

microbenchmark(
  Q$solve(p, 0.1, method = "ode23"),
  Q$solve(p, 0.2, method = "ode23"),
  Q$solve(p, 0.4, method = "ode23"),
  Q$solve(p, 0.8, method = "ode23"),
  Q$solve(p, 1.6, method = "ode23"),
  times = 5
)

# new_p <- Q$solve(p, 1.6, method = "ode23")
# new_q <- pmax(new_p, 0)
# new_q <- new_q / max(new_q)

microbenchmark(
  Q$solve(p, 0.1, method = "ode23"),
  Q$solve(new_p, 0.1, method = "ode23"),
  Q$solve(new_p, 0.1, method = "rk4"),
  times = 5
)

# Rprof(interval = 0.001)
# s <- Q$solve(p, t, method = "ode45")
# # s <- Q$solve(p, t, method = "lsoda")
# Rprof(NULL)
# summaryRprof("Rprof.out")

# profvis({
#   Q$solve(p, t, method = "ode45")
# })


