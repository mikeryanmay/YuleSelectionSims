# setwd("simulations/num_samples_over_time/")

library(microbenchmark)
library(TESS)

source("src/countClass.R")

# settings
lambda0 <- 0.25
lambda1 <- 2 * lambda0
phi     <- 0
gamma   <- 0.05
t       <- 7

# simulate
reps <- 1000000
sims <- t(replicate(reps, forwardSimulate(t, c(1,0), lambda0, lambda1, gamma)))
nmax <- max(sims)

p_sim_0 <- tabulate(sims[,1] + 1, nbins = nmax + 1) / reps
p_sim_1 <- tabulate(sims[,2] + 1, nbins = nmax + 1) / reps
p_sim_n <- tabulate(rowSums(sims), nbins = nmax) / reps

# make the matrix
Q <- countMatrixModel(nmax, lambda0, lambda1, phi, gamma, gamma)

# make init p
p <- numeric(Q$num_states)
names(p) <- Q$labels
p[nmax + 1] <- 1

# integrate
p_ode   <- Q$solve(p, t, method = "ode23")
p_ode_0 <- sapply(split(p_ode, Q$states[,1]), sum)
p_ode_1 <- sapply(split(p_ode, Q$states[,2]), sum)
p_ode_n <- sapply(split(p_ode, rowSums(Q$states)), sum)

# plot
pdf("figures/num_samples_multitype.pdf", height = 4)
par(mar=c(4,4,0,0)+0.1)
plot(0:nmax,   p_ode_0, col = "blue",  pch = 3, type = "p", ylim = c(0, max(p_ode_0)), xlim = c(0, min(which(cumsum(p_ode_n) > 0.95))), xlab = "number of individuals", ylab = "probability")
points(0:nmax, p_ode_1, col = "orange",   pch = 3, type = "p")
points(1:nmax, p_ode_n, col = "black", pch = 3, type = "p")
points(0:nmax, p_ode_1, col = "orange",   pch = 3, type = "p")
points(0:nmax, p_sim_0, col = "blue",  pch = 4, type = "p")
points(0:nmax, p_sim_1, col = "orange",   pch = 4, type = "p")
points(1:nmax, p_sim_n, col = "black", pch = 4, type = "p")
legend("topright", legend = c("simulation", "ode"), pch = c(3,4), bty = "n", title = "method")
legend("top",      legend = c("type 0", "type 1", "total"), pch = 3, col = c("blue","orange","black"), bty = "n", title = "number of individuals")
dev.off()

# now compare against yule model

# make the matrix
Q <- countMatrixModel(nmax, lambda0, lambda0, phi, gamma, gamma)

# integrate
p_ode   <- Q$solve(p, t, method = "ode23")
p_ode_n <- sapply(split(p_ode, rowSums(Q$states)), sum)

# use TESS
p_ana_n <- sapply(1:nmax, function(i) TESS:::tess.equations.pN.constant(lambda0, 0, c(), c(), 1, i, 0, t))

# plot
pdf("figures/num_samples_onetype.pdf", height = 4)
par(mar=c(4,4,0,0)+0.1)
plot(1:nmax, p_ode_n, col = "black",  pch = 3, type = "p", xlim = c(1, min(which(cumsum(p_ode_n) > 0.95))), xlab = "number of individuals", ylab = "probability")
points(1:nmax, p_ana_n, col = "black", pch = 4, type = "p")
legend("topright", legend = c("ode", "analytical"), pch = c(3,4), bty = "n", title = "method")
dev.off()
