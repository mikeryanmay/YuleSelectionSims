# get the arguments
args <- commandArgs(TRUE)

# just the replicate number
indir <- args[1]
# indir <- "factor/tips_1000_size_10_factor_4/rep_1/"

# source the code
source("../../src/likelihood.R")

# simulation settings
lambda_0 <- 0.12      # birth rate
gamma    <- 0.005     # mutation rate
L        <- 1         # number of selected sites
phi      <- 0.1       # sampling rate

# get the factor
factor <- as.numeric(strsplit(gsub("/", "_",indir), "_")[[1]][7])
delta  <- lambda_0 * factor - lambda_0

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

# get just the first site
seq <- t(t(seq[,1]))

# make the calculator
calculator <- YuleLikelihood(tree, seq, model = c("-"), lambda_0, gamma, delta, 0, phi)

# compute marginal probability of tree (without sequence data)
calculator$computeLikelihood()
tree_probability <- calculator$getSelectedLikelihood()

# compute the joint probability of the tree and sequence data
calculator$setModel("A")
joint_probability <- calculator$computeLikelihood()

# compute the conditional probability of the site pattern, given the tree
conditional_site_probability <- joint_probability - tree_probability

# compute the probability of the tree under a constant-rate model
calculator$setModel("-")
calculator$setDelta(0)
calculator$computeLikelihood()
constant_tree_probability <- calculator$getSelectedLikelihood()

fits <- rbind(tree_probability, conditional_site_probability, joint_probability, constant_tree_probability)

# write to file
outdir <- gsub("data", "output", indir)
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)
write.table(fits, file = paste0(outdir, "/partition_info.tsv"), quote = FALSE, sep = "\t", row.names = FALSE)














