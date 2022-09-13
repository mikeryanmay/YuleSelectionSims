# setwd("simulations/num_samples_over_time/")

source("src/matrixModel.R")
source("src/countClass.R")

# mutation rate
genome_size <- 30000
mutation_rate_per_site_per_year <- 0.00084
mutation_rate_per_site_per_day  <- mutation_rate_per_site_per_year / 365
gamma <- mutation_rate_per_site_per_day

# diversification rates
r0      <- 2.5
phi     <- 0.2
lambda0 <- r0 * phi
lambda1 <- 1.5 * lambda0

# read a dataset
dir  <- "../empirical_single_site/sims/tips_100_f_1.5/rep_6/"
tree <- read.nexus(paste0(dir, "tree.nex"))
seq  <- read.nexus.data(paste0(dir, "seq.nex"))
seq  <- t(t(sapply(seq, head, n = 1)))

# format the data as sample times and sampled states
temporal_data <- getSampleData(tree, seq)
temporal_data$code <- ifelse(temporal_data$state == "A", 1, 0)
nmax <- nrow(seq)
end_state <- paste0("(", paste0(table(temporal_data[temporal_data$type == "extant",]$code), collapse = ","), ")")

# get sample times
sample_times <- temporal_data[temporal_data$type == "sample",]$ages
max_time     <- max(temporal_data$ages)

# make a matrix
# Q <- countMatrixModel(nmax, lambda0, lambda1, phi, gamma / 3, gamma)
Q <- countMatrixModel(nmax, lambda0, lambda0, phi, gamma / 3, gamma)

# make the events
R0 <- sampleMatrixModel(nmax, phi, "0")
R1 <- sampleMatrixModel(nmax, phi, "1")

# initial probs
start_state <- "(1,0)"
p <- numeric(Q$num_states)
names(p) <- Q$labels
p[start_state] <- 1

# make the event function
event_function <- function(t, y, parms) {
  cat(t, "\n")
  if ( t %in% temporal_data$ages ) {
    if ( temporal_data[temporal_data$ages == t,]$code == 0 ) {
      y <- R0$doSampleEvent(y)
    } else if ( temporal_data[temporal_data$ages == t,]$code == 1 ) {
      y = R1$doSampleEvent(y)
    }
  }
  # y <- y / max(y)
  return(y)
}

# do some integration
end_p <- Q$solve(p, c(sample_times, max_time), method = "ode45", events = list(
  func = event_function, time = sample_times
), atol = 1e-12, rtol = 1e-12)


plot(end_p, type = "l", log = "")
abline(v = which(Q$labels == end_state))

log(end_p[end_state])


