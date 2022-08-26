# get the arguments
args <- commandArgs(TRUE)

# just the replicate number
indir <- args[1]
# indir <- "scenario/scenario_1_size_10/rep_1/"
# indir <- "factor/tips_100_size_10_factor_4/rep_3/"
# indir <- "factor/tips_100_size_10_factor_1.5/rep_1/"
# indir <- "factor/tips_1000_size_10_factor_1/rep_1/"

# source the code
source("../../src/likelihood.R")

# simulation settings
lambda_0 <- 0.12      # birth rate
gamma    <- 0.005     # mutation rate
L        <- 1         # number of selected sites
phi      <- 0.1       # sampling rate
delta    <- 0

# point at the directory
# indir <- paste0("data/rep_", rep, "/")

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

# enumerate the models
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

# get the true value of lambda_1
tmp <- indir
tmp <- gsub("/", "_", tmp)
tmp <- strsplit(tmp, "_")[[1]]
f <- as.numeric(tmp[which(tmp == "factor")[2] + 1])
delta <- f * lambda_0 - lambda_0

# make the calculator
calculator <- YuleLikelihood(tree, seq, models[1,], lambda_0, gamma, delta, 0, phi)

# now fit the model with delta
model_liks <- vector("list", number_of_models)
bar <- txtProgressBar(style = 3, width = 40)
for(i in 1:number_of_models) {

  # get the model
  this_model <- models[i,]

  # set the model
  calculator$setModel(this_model)

  # compute the likelihood
  ll <- calculator$computeLikelihood()

  # store the fit
  model_liks[[i]] <- c(ll, gamma, delta)

  setTxtProgressBar(bar, i / number_of_models)

}
model_liks <- do.call(rbind, model_liks)

# fit the constant-rate model
calculator$setDelta(0)
constant_lik <- c(calculator$computeLikelihood(), gamma, 0)

# combine the models
liks <- rbind(model_liks, constant_lik)

# write to file
outdir <- gsub("data", "output", indir)
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)
write.table(liks, file = paste0(outdir, "/liks.tsv"), quote = FALSE, sep = "\t", row.names = FALSE)

# quit
q()







