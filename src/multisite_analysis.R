# get the arguments
args <- commandArgs(TRUE)

# just the replicate number
indir <- args[1]
# indir <- "sims/tips_100_size_1_f_3/rep_1/"
# indir <- "sims/tips_500_size_3_f_3/rep_1/"
# indir <- "sims/tips_500_size_2_f_2/rep_1/"
# indir <- "sims/tips_500_size_2_f_2/rep_4/"
# indir <- "sims/tips_1000_size_2_f_1.5/rep_8/"

# source the code
library(cubature)
source("../../src/likelihood.R")

# simulation settings
lambda_0 <- 0.12      # birth rate
gamma    <- 0.005     # mutation rate
L        <- 1         # number of selected sites
phi      <- 0.1       # sampling rate
delta    <- 0

# find tree and data
tree_file <- list.files(indir, pattern = "tree.nex", full.names = TRUE)
seq_file  <- list.files(indir, pattern = "seq.nex", full.names = TRUE)

# if the files don't exist, abort
if ( file.exists(tree_file) == FALSE ) {
  cat("Couldn't find tree file.\n")
  q()
}

if ( file.exists(seq_file) == FALSE ) {
  cat("Couldn't find sequence file.\n")
  q()
}

# read the data
tree <- read.nexus(tree_file)
seq  <- read.nexus.data(seq_file)
seq  <- do.call(rbind, seq)
num_sites <- ncol(seq)

# only consider the first site
# seq <- t(t(seq[,1]))

###################
# model with data #
###################

# create the model and calculator
model <- rep("-", num_sites)
calculator <- YuleLikelihood(tree, seq, model, lambda_0, gamma, delta, 0, phi)
calculator$computeLikelihood()

########################
# enumerate the models #
########################

# all models with a single site/allele under selection
num_sites             <- ncol(seq)
num_selected_sites    <- 1
sites_under_selection <- t(combn(1:num_sites, num_selected_sites))
selected_states       <- expand.grid(lapply(1:num_selected_sites, function(x) c("A","C","G","T") ), stringsAsFactors = FALSE)
number_of_models      <- nrow(sites_under_selection) * nrow(selected_states)

models <- vector("list", number_of_models)
blank_model <- rep("-", num_sites)
k <- 0
for(i in 1:nrow(sites_under_selection)) {
  for(j in 1:nrow(selected_states)) {
    
    # create the model
    this_model <- blank_model
    this_model[sites_under_selection[i,]] <- unlist(selected_states[j,])
    
    # save the model
    k <- k + 1
    models[[k]] <- this_model
    
  }
}
models <- do.call(rbind, models)

######################
# make the functions #
######################

# create the likelihood function 
likelihood <- function(f, L) {
  
  # compute the delta
  delta <- (lambda_0 * f - lambda_0) / L
  
  # set the value
  calculator$setDelta(delta)
  
  # compute the log-likelihood
  ll <- calculator$computeLikelihood()
  
  return(ll)
  
}

# create the prior distribution
# such that the median value is f = 1, the 2.5% quantile is 1/6 of the median,
# and the 97.5% quantile is 6 times the median
m  <- 1
sd <- log(36) / (qnorm(0.975) - qnorm(0.025))
prior <- function(f) dlnorm(f, log(m), sd, log = TRUE)

# log posterior, unnormalize, vectorized
log_posterior_un <- function(x, L) {
  pp <- sapply(x, likelihood, L = L) + prior(x)
  return(pp)
}

# normalized posterior, not vectorized
posterior <- function(x, L, scalar) {
  pp <- exp(likelihood(x, L = L) + prior(x) - scalar)
  return(pp)
}

#######################
# iterate over models #
#######################

# first, selection models
model_likelihoods <- numeric(number_of_models)
posterior_mode    <- numeric(number_of_models)
convergence       <- numeric(number_of_models)
bar <- txtProgressBar(style = 3, width = 40)
for(i in 1:number_of_models) {
  
  # get the model
  this_model <- models[i,]
  
  # set the model
  calculator$setModel(this_model)
  
  # find the scalar
  opt    <- optimize(log_posterior_un, lower = 0, upper = 10, maximum = TRUE, L = 1)
  scalar <- opt$objective
  delta  <- opt$maximum
  
  # # find the min
  # scalar <- log_posterior_un(0.01, L = 1)
  
  # compute the marginal probability
  # int <- integrate(posterior, 0, 10, L = 1, scalar = scalar)
  # int <- pcubature(posterior, lowerLimit = 0, upperLimit = 10, scalar = scalar, L = 1)
  int <- hcubature(posterior, lowerLimit = 0, upperLimit = 10, scalar = scalar, L = 1)
  marginal_probability <- scalar + log(int$integral)
  
  # write down
  model_likelihoods[i] <- marginal_probability
  posterior_mode[i]    <- delta
  convergence[i]       <- int$returnCode
  
  setTxtProgressBar(bar, i / number_of_models)
  
  # cat(marginal_probability, "\n")
  
}

close(bar)

#######################
# now, constant model #
#######################

calculator$setDelta(0.0)
marginal_probability <- calculator$computeLikelihood()

model_likelihoods <- c(model_likelihoods, marginal_probability)
posterior_mode    <- c(posterior_mode, 0.0)
convergence       <- c(convergence, 0.0)

######################
# now the true model #
######################

# determine the true model
tmp <- strsplit(indir, "_")[[1]]
true_size <- as.numeric(tmp[which(tmp == "size") + 1])

true_model <- rep("-", num_sites)
true_model[1:true_size] <- "A"

# set the true model
calculator$setModel(true_model)
# calculator$computeLikelihood()

# find the scalar
opt    <- optimize(log_posterior_un, lower = 0, upper = 5 * true_size, maximum = TRUE, L = true_size)
scalar <- opt$objective
delta  <- opt$maximum / true_size

# compute the marginal probability
int <- hcubature(posterior, lowerLimit = 0, upperLimit = 5 * true_size, scalar = scalar, L = true_size)
marginal_probability <- scalar + log(int$integral)

model_likelihoods <- c(model_likelihoods, marginal_probability)
posterior_mode    <- c(posterior_mode, delta)
convergence       <- c(convergence, 0.0)

########################
# now a credible model #
########################

# assume the size of the credible set is the true number
# of sites under selection

# get the likelihoods per site model
site_model_likelihoods <- model_likelihoods[1:number_of_models]
liks_per_site   <- numeric(num_sites)
states_per_site <- character(num_sites)
new_models <- vector("list", num_sites)
for(i in 1:num_sites) {
  
  # get these models
  these_models <- site_model_likelihoods[models[,i] != "-"]
  
  # get the max likelihood
  this_max <- max(these_models)
  
  # get the state
  this_state <- sample(c("A","C","G","T")[which(these_models == this_max)], size = 1)
  # this_state <- c("A","C","G","T")[which(these_models == this_max)]
  
  # create the new model
  new_model <- rep("-", num_sites)
  new_model[i] <- this_state
  
  # store stuff
  liks_per_site[i]   <- this_max
  states_per_site[i] <- this_state
  new_models[[i]]    <- new_model
  
}

# choose the new site models
if ( true_size < 2 ) {
  # new_size <- 2
  new_size <- 1
} else {
  new_size <- true_size
}
new_models <- new_models[order(liks_per_site, decreasing = TRUE)[1:new_size]]

# combine the models
combine <- function(x, y) {
  x[y != "-"] <- y[y != "-"]
  return(x)
}
combined_model <- Reduce("combine", new_models)

# compute the marginal likelihood
calculator$setModel(combined_model)

# find the scalar
opt    <- optimize(log_posterior_un, lower = 0, upper = 10, maximum = TRUE, L = new_size)
scalar <- opt$objective
delta  <- opt$maximum / new_size

# compute the marginal probability
int <- hcubature(posterior, lowerLimit = 0, upperLimit = 10, scalar = scalar, L = new_size)
marginal_probability <- scalar + log(int$integral)

# store values
model_likelihoods <- c(model_likelihoods, marginal_probability)
posterior_mode    <- c(posterior_mode, delta)
convergence       <- c(convergence, 0.0)

# get the name of the model
combined_model_name <- paste0(which(combined_model != "-"), combined_model[combined_model != "-"], collapse = "")

#######################
# write stuff to file #
#######################

# make the output file
outfile <- paste0(indir, "/site_models.tsv")

# make the output table
model_names <- c(paste0(which(models != "-", arr.ind = TRUE)[,2], models[models != "-"]), "neutral", "true", combined_model_name)
model_liks  <- data.frame(model = model_names, lik = model_likelihoods, mode = posterior_mode, convergence = convergence)

# write to file
write.table(model_liks, file = outfile, quote = FALSE, sep = "\t", row.names = FALSE)

# make a plot
model_col <- rep("black", nrow(model_liks))
model_col[4 * (1:true_size - 1) + 1] <- "red"
model_col[number_of_models + 2] <- "red"

pdf(paste0(indir, "/model_plot.pdf"), width = 20)
par(mar=c(4,4,0,0) + 0.1)
plot(model_liks$lik, col = model_col, pch = 19, xaxt = "n", xlab = NA)
axis(1, at = 1:nrow(model_liks), label = model_liks$model, las = 2)
abline(h = model_likelihoods[number_of_models + 1], lty = 2, col = "green")
dev.off()

# quit
q()





