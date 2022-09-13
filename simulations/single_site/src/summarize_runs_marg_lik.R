# RUN FROM simulations/single_site
# setwd("simulations/single_site/")

library(ape)
library(TreeTools)
library(RColorBrewer)
library(viridis)

# load vioplot function
source("../../src/weighted_vioplot.R")

# specify figure directory
# figdir <- "figures/"
figdir <- "~/repos/yuleselectionMS/figures/"

# enumerate the analyses
tips    <- c(50, 100, 250, 500, 750, 1000)
size    <- c(1, 10, 100, 1000)
factors <- c(1, 1.5, 2, 2.5, 3, 4)
reps    <- 1:200

# make all combinations
grid <- expand.grid(tips = tips, size = size, factor = factors, rep = reps, stringsAsFactors = FALSE)

# compute all the summaries
summaries <- do.call(rbind, lapply(1:nrow(grid), function(i) {
  
  # get the analysis
  this_grid   <- grid[i,]
  this_tips   <- this_grid$tips
  this_size   <- this_grid$size
  this_factor <- this_grid$factor
  this_rep    <- this_grid$rep
  
  cat(i, " -- ", nrow(grid),"\n", sep = "")
  
  # check if the output file exists
  this_tsv <- paste0("factor/tips_", this_tips, "_size_", this_size, "_factor_", this_factor, "/rep_", this_rep, "/marg_lik.tsv")
  if ( file.exists(this_tsv) == FALSE ) {
    return(NULL)
  }
  
  # read output file
  results <- read.table(this_tsv, header = TRUE, sep = "\t", stringsAsFactors = FALSE)
  
  # specify priors over models
  prior_constant <- 0.5
  prior_selected <- 1 - prior_constant
  priors         <- c(prior_selected, prior_constant)
  
  # compute bayes factors without sequence
  tree_likelihood_selected <- results[3,1]
  tree_likelihood_constant <- results[4,1]
  tree_likelihoods <- c(tree_likelihood_selected, tree_likelihood_constant)
  tree_likelihoods <- tree_likelihoods - max(tree_likelihoods)
  tree_posteriors  <- tree_likelihoods + log(priors)
  tree_posteriors  <- tree_posteriors - log(sum(exp(tree_posteriors)))
  tree_BF_selected <- 2 * (tree_posteriors[1] - tree_posteriors[2]) - (log(prior_selected) - log(prior_constant))
  
  # compute the raw posteriors
  tree_posteriors  <- exp(tree_posteriors)
  
  # compute bayes factor with sequence
  joint_likelihood_selected <- results[1,1]
  joint_likelihood_constant <- results[2,1]
  joint_likelihoods <- c(joint_likelihood_selected, joint_likelihood_constant)
  joint_likelihoods <- joint_likelihoods - max(joint_likelihoods)
  joint_posteriors  <- joint_likelihoods + log(priors)
  joint_posteriors  <- joint_posteriors - log(sum(exp(joint_posteriors)))
  joint_BF_selected <- 2 * (joint_posteriors[1] - joint_posteriors[2]) - (log(prior_selected) - log(prior_constant))
  
  # compute the raw posteriors
  joint_posteriors <- exp(joint_posteriors)
  
  # return
  res <- data.frame(tips        = this_tips,
                    size        = this_size, 
                    factor      = this_factor, 
                    rep         = this_rep,
                    tree_BF     = tree_BF_selected,
                    joint_BF    = joint_BF_selected,
                    tree_post   = I(list(tree_posteriors)),
                    join_post   = I(list(joint_posteriors)))
  
  return(res)
  
}))

print(dim(summaries))

# plot the distributions

# colors <- brewer.pal(6, "Set1")
# colors <- brewer.pal(6, "RdYlBu")
# colors <- brewer.pal(8, "GnBu")[2:7]
colors <- gsub("FF", "", plasma(6, begin = 0.1, end = 0.9))
col_theoretical <- "black"

layout_mat <- matrix(1:(length(factors)), ncol = length(factors), nrow = 1, byrow = TRUE)

pdf(paste0(figdir, "posterior_tree_vs_joint.pdf"), height = 2.8, width = 12)
layout(layout_mat)
par(mar=c(0,0,0,0), oma = c(4,5.5,2,0) + 0.1)

for(i in 1:length(factors)) {
  
  this_f <- factors[i]
  
  # get the relevant samples
  these_summaries <- summaries[summaries$factor == this_f,]
  
  # make into data frame
  these_tips       <- these_summaries$tips
  these_tree_post  <- do.call(rbind, these_summaries$tree_post)[,1]
  these_joint_post <- do.call(rbind, these_summaries$join_post)[,1]
  df               <- data.frame(c = these_tips, t = these_tree_post, j = these_joint_post)
  
  # plot tree stuff
  adj <- 0.05
  v <- vioplot(formula = t ~ c,
               data    = df,
               side    = "left",
               ylim    = c(0, 1),
               at      = (1:length(factors)) - adj,
               xlim    = c(0.5, 6.5),
               col     = paste0(colors,"75"),
               rectCol = NA, lineCol = NA, pchMed = NA, border = NA,
               names   = size, areaEqual = FALSE,
               xlab    = NA, ylab = NA, xaxt = "n", yaxt = "n")

  for(k in 1:length(factors)) {
    
    this_base   <- v$base[[k]]
    this_height <- v$height[[k]]
    
    if ( all(is.na(this_height)) ) {
      fun <- function(x) 1/3
    } else {
      # approximate function
      fun <- approxfun(this_base, this_height)
    }
    
    # get y coordinates
    y <- df$t[df$c == tips[k]]
    
    # subset the coordinates
    y <- sample(y, size = 400)
    
    # get jitter factor per coordinate
    jitter_factor <- fun(y)
    x <- k + runif(length(y), -jitter_factor, 0) - adj
    
    c <- colors[k]
    w <- 0.3
    
    points(x, y, col = c, cex = w, pch = 19)
    
  }
  
  # plot joint stuff
  v <- vioplot(formula = j ~ c,
               data    = df,
               side    = "right", add = TRUE,
               at      = (1:length(factors)) + adj,
               ylim    = c(0, 1),
               col     = paste0(colors,"50"),
               rectCol = NA, lineCol = NA, pchMed = NA, border = NA,
               areaEqual = FALSE)
  
  for(k in 1:length(factors)) {
    
    this_base   <- v$base[[k]]
    this_height <- v$height[[k]]
    
    if ( all(is.na(this_height)) ) {
      fun <- function(x) 1/3
    } else {
      # approximate function
      fun <- approxfun(this_base, this_height)
    }
    
    # get y coordinates
    y <- df$j[df$c == tips[k]]
    
    # subset the coordinates
    y <- sample(y, size = 400)
    
    # get jitter factor per coordinate
    jitter_factor <- fun(y)
    x <- k + runif(length(y), 0, jitter_factor) + adj
    
    c <- colors[k]
    w <- 0.3
    
    points(x, y, col = c, cex = w, pch = 19)
    
  }
  
  mtext(paste0("f = ", this_f), side = 3, line = 0.5)
  axis(1, lwd = 0, lwd.tick = 1, at = 1:length(tips), labels = tips, las = 2)
  mtext("c", side = 1, line = 2.5)
  
  if (i == 1) {
    axis(2, lwd = 0, lwd.tick = 1, las = 2)
    mtext("P(true)", side = 2, line = 3)
  }
  
}

dev.off()















# 