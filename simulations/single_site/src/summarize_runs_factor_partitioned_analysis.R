# RUN FROM simulations/single_site
# setwd("simulations/single_site/")

library(ape)
library(TreeTools)
library(RColorBrewer)

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
  this_tsv <- paste0("factor/tips_", this_tips, "_size_", this_size, "_factor_", this_factor, "/rep_", this_rep, "/partition_info.tsv")
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
  tree_likelihood_selected <- results[1,1]
  tree_likelihood_constant <- results[4,1]
  tree_likelihoods <- c(tree_likelihood_selected, tree_likelihood_constant)
  tree_likelihoods <- tree_likelihoods - max(tree_likelihoods)
  tree_posteriors  <- tree_likelihoods + log(priors)
  tree_posteriors  <- tree_posteriors - log(sum(exp(tree_posteriors)))
  tree_BF_selected <- 2 * (tree_posteriors[1] - tree_posteriors[2]) - (log(prior_selected) - log(prior_constant))
    
  # compute bayes factor with sequence
  joint_likelihood_selected <- results[3,1]
  joint_likelihood_constant <- results[5,1]
  joint_likelihoods <- c(joint_likelihood_selected, joint_likelihood_constant)
  joint_likelihoods <- joint_likelihoods - max(joint_likelihoods)
  joint_posteriors  <- joint_likelihoods + log(priors)
  joint_posteriors  <- joint_posteriors - log(sum(exp(joint_posteriors)))
  joint_BF_selected <- 2 * (joint_posteriors[1] - joint_posteriors[2]) - (log(prior_selected) - log(prior_constant))
  
  # return
  res <- data.frame(tips        = this_tips,
                    size        = this_size, 
                    factor      = this_factor, 
                    rep         = this_rep,
                    tree_BF     = tree_BF_selected,
                    joint_BF    = joint_BF_selected)
  
  return(res)
  
}))

##############################
# reject constant-rate model #
##############################

# create the BF cutoffs
all_BFs    <- c(summaries$tree_BF, summaries$joint_BF)
all_BFs    <- all_BFs[is.finite(all_BFs)]
BF_range   <- range(pretty(all_BFs))
BF_cutoffs <- sort(c(all_BFs, BF_range))

pdf("figures/partitioned_rejection_rates.pdf", height = 10, width = 15)
layout_mat <- matrix(1:(length(tips) * length(factors)), nrow = length(tips), ncol = length(factors), byrow = TRUE)
layout(layout_mat)
par(mar=c(0,0,0,0), oma = c(4,7,2,0)+0.1)
for(i in 1:length(tips)) {
  
  # get the number of tips
  this_ntips <- tips[i]
  
  for(j in 1:length(factors)) {
    
    # get the factor
    this_factor <- factors[j]
    
    # get results for this ntips and f
    # these_summaries <- summaries[summaries$tips == this_ntips & summaries$factor == this_factor & summaries$size == 1000,]
    these_summaries <- summaries[summaries$tips == this_ntips & summaries$factor == this_factor,]
    
    # compute rejection rate for each BF cutoff without sequence data
    tree_BF <- sort(these_summaries$tree_BF)
    tree_rejection_rate <- 1.0 - findInterval(BF_cutoffs, tree_BF) / length(tree_BF)
    tree_rejection_rate <- c(tree_rejection_rate, 0)
    
    # compute rejection rate for each BF cutoff with sequence data
    joint_BF <- sort(these_summaries$joint_BF)
    joint_rejection_rate <- 1.0 - findInterval(BF_cutoffs, joint_BF) / length(joint_BF)
    joint_rejection_rate <- c(joint_rejection_rate, 0)
    
    # plot(tree_rejection_rate, joint_rejection_rate)
    # abline(a = 0, b = 1)
    
    plot(NA, xlim = c(0,1), ylim = c(0,1), xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
    if (j == 1) {
      mtext("joint positive rate", line = 3, side = 2)
      axis(2, lwd = 0, lwd.tick = 1, las = 1)
      mtext(paste0("N = ", this_ntips), line = 5, side = 2)
    }
    if (i == length(tips)) {
      axis(1, lwd = 0, lwd.tick = 1, las = 1)
      mtext("tree positive rate", line = 3, side = 1)
    }
    abline(a = 0, b = 1, lty = 2)
    if (i == 1) {
      mtext(paste0("lambda1 = ", this_factor, " x lambda0 "), line = 0.5)
    }

    points(x = tree_rejection_rate, y = joint_rejection_rate, type = "s")
    
  }
  
}
dev.off()


# now as a function of the Bayes factor 
cols <- brewer.pal(3, "Set1")[1:2]

pdf("figures/partitioned_rejection_rates_by_BF.pdf", height = 10, width = 15)
layout_mat <- matrix(1:(length(tips) * length(factors)), nrow = length(tips), ncol = length(factors), byrow = TRUE)
layout(layout_mat)
par(mar=c(0,0,0,0), oma = c(4,7,2,0)+0.1)
for(i in 1:length(tips)) {
  
  # get the number of tips
  this_ntips <- tips[i]
  
  for(j in 1:length(factors)) {
    
    # get the factor
    this_factor <- factors[j]
    
    # get results for this ntips and f
    these_summaries <- summaries[summaries$tips == this_ntips & summaries$factor == this_factor,]
    
    # compute rejection rate for each BF cutoff without sequence data
    tree_BF <- sort(these_summaries$tree_BF)
    tree_rejection_rate <- 1.0 - findInterval(BF_cutoffs, tree_BF) / length(tree_BF)
    
    # compute rejection rate for each BF cutoff with sequence data
    joint_BF <- sort(these_summaries$joint_BF)
    joint_rejection_rate <- 1.0 - findInterval(BF_cutoffs, joint_BF) / length(joint_BF)
    
    # plot(NA, xlim = c(-20, 20), ylim = c(0,1), xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
    plot(NA, xlim = c(-100, 500), ylim = c(0,1), xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
    # plot(NA, xlim = BF_range, ylim = c(0,1), xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
    if (j == 1) {
      mtext("rejection rate", line = 3, side = 2)
      axis(2, lwd = 0, lwd.tick = 1, las = 1)
      mtext(paste0("N = ", this_ntips), line = 5, side = 2)
    }
    if (i == length(tips)) {
      axis(1, lwd = 0, lwd.tick = 1, las = 1, las = 2)
      mtext("2 ln BF", line = 3, side = 1)
    }
    abline(v = 0, lty = 2, lend = 2)
    if (i == 1) {
      mtext(paste0("lambda1 = ", this_factor, " x lambda0 "), line = 0.5)
    }
    if (i == 1 & j == 1) {
      legend("topright", legend = c("tree", "tree + sequence"), lty = 1, col = cols, bty = "n")
    }
    
    points(x = BF_cutoffs, y = tree_rejection_rate,  type = "l", col = cols[1])
    points(x = BF_cutoffs, y = joint_rejection_rate, type = "l", col = cols[2])
    
  }
  
}
dev.off()








