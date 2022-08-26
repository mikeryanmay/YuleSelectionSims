# RUN FROM simulations/single_site
# setwd("simulations/single_site/")

library(matrixStats)
library(ape)
library(TreeTools)
library(RColorBrewer)
library(ggplot2)

# load vioplot function
source("../../src/weighted_vioplot.R")

# enumerate the analyses
tips    <- c(50, 100, 250, 500, 750, 1000)
size    <- c(1, 10, 100, 1000)
factors <- c(1, 1.5, 2, 2.5, 3, 4)
# factors <- c(1.5, 2, 2.5, 3, 4)
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
  # this_tsv <- paste0("factor/tips_", this_tips, "_size_", this_size, "_factor_", this_factor, "/rep_", this_rep, "/fits.tsv")
  this_tsv <- paste0("factor/tips_", this_tips, "_size_", this_size, "_factor_", this_factor, "/rep_", this_rep, "/liks.tsv")
  if ( file.exists(this_tsv) == FALSE ) {
    return(NULL)
  }
  
  # read output file
  results <- read.table(this_tsv, header = TRUE, sep = "\t", stringsAsFactors = FALSE)
  
  # normalize the likelihoods for numerical purposes
  # results$lik <- results$lik - max(results$lik)
  results$lik <- results[,1] - max(results[,1])
  
  if ( all(is.na(results$lik)) ) {
    cat("\tOops!\n")
    return(NULL)
  }
  
  # number of models
  num_models <- nrow(results) - 1
  
  # compute priors and posteriors
  prior_constant        <- 0.5
  prior_selected        <- 1 - prior_constant
  prior_site_selected   <- prior_selected / num_models
  prior_over_models     <- c(rep(prior_site_selected, num_models), prior_constant)
  posterior_over_models <- exp(results$lik) * prior_over_models
  posterior_over_models <- posterior_over_models / sum(posterior_over_models)
  
  # compute credible set
  posteriors <- posterior_over_models
  names(posteriors) <- 1:length(posterior_over_models)
  posteriors <- sort(posteriors, decreasing = TRUE)
  cum_posteriors <- cumsum(posteriors)
  
  # does the credible set include the true model?
  true_model_index <- which(names(cum_posteriors) == "1")
  if ( true_model_index == 1 ) {
    # case 1: true model is first
    if ( cum_posteriors[1] < 0.95 ) {
      # case 1a: true model has probability < 0.95
      included <- 1
    } else {
      # case 1b: true model has probability > 0.95 and so may not be in the 95% credible set
      included <- 0.95 / cum_posteriors[1]
    }
  } else {
    # case 2: true model is not first
    if ( cum_posteriors[true_model_index] < 0.95 ) {
      # case 2a: true model is in credible set
      included <- 1
    } else if ( cum_posteriors[true_model_index - 1] < 0.95 ) {
      # case 2b: true model has some chance of being in credible set
      remainder <- 0.95 - cum_posteriors[true_model_index - 1]
      included  <- remainder / posteriors[true_model_index]
    } else {
      # case 2c: true model not in credible set
      included <- 0.0
    }
  }

  # compute width of credible set
  if ( cum_posteriors[1] > 0.95 ) {
    # case 1: first model dominates the credible set
    credible_set_size <- 0.95 / cum_posteriors[1]
  } else {
    # case 2: credible set includes one or more models
    definitely_in_set <- cum_posteriors < 0.95
    remainder         <- 0.95 - cum_posteriors[max(which(definitely_in_set))]
    remainder         <- remainder / (remainder + 0.05)
    credible_set_size <- sum(definitely_in_set) + remainder
  }
    
  # BF per site
  BF_per_site <- 2 * log((posterior_over_models / (1 - posterior_over_models)) / (prior_over_models / (1 - prior_over_models)))
  
  # return
  res <- data.frame(tips              = this_tips,
                    size              = this_size, 
                    factor            = this_factor, 
                    rep               = this_rep,
                    posteriors        = I(list(posterior_over_models)),
                    included          = included,
                    credible_set_size = credible_set_size,
                    BF_per_site       = I(list(BF_per_site)))
  
  return(res)
  
}))

################################################
# posterior probability of constant-rate model #
################################################

colors <- brewer.pal(4, "Set1")

layout_mat <- matrix(1:(length(tips) * length(factors)), ncol = length(factors), nrow = length(tips), byrow = TRUE)

pdf("figures/posterior_neutral.pdf", height = 14, width = 12)
layout(layout_mat)
par(mar=c(0,0,0,0), oma = c(4,6.5,2,0) + 0.1)

# loop over rows
for(i in 1:length(tips)) {
  
  this_c <- tips[i]
  
  # loop over columns
  for(j in 1:length(factors)) {
    
    this_f <- factors[j]
    
    # get the relevant samples
    these_summaries <- summaries[summaries$tips == this_c & summaries$factor == this_f,]
    
    # get the posterior of the true model
    these_sizes      <- these_summaries$size
    these_posteriors <- sapply(these_summaries$posteriors, tail, n = 1)
    these_set_sizes  <- these_summaries$credible_set_size
    these_included   <- these_summaries$included
    df <- data.frame(n = these_sizes, p = these_posteriors, s = these_set_sizes)
    
    # the vioplot
    v <- vioplot(formula = p ~ n,
                 data    = df,
                 ylim    = c(0,1),
                 col     = paste0(colors,"50"),
                 rectCol = NA, lineCol = NA, pchMed = NA, border = NA,
                 names   = size, areaEqual = TRUE,
                 xlab    = NA, ylab = NA, xaxt = "n", yaxt = "n")
    
    # vioplot(formula = p ~ n, 
    #         data    = df, 
    #         ylim    = c(0,1),
    #         col     = paste0(colors,"50"),
    #         rectCol = NA, lineCol = NA, pchMed = NA, border = NA,
    #         names   = size, areaEqual = FALSE,
    #         xlab    = NA, ylab = NA, xaxt = "n", yaxt = "n")
    
    # the points
    for(k in 1:length(size)) {
      
      # get base and height
      if ( any(size[k] %in% df$n) == FALSE ) {
        next
      }
      this_base   <- v$base[[k]]
      this_height <- v$height[[k]]
      
      if ( all(is.na(this_height)) ) {
        next
      }
      
      # approximate function
      fun <- approxfun(this_base, this_height)
      
      # get y coordinates
      y <- df$p[df$n == size[k]]
      
      # get jitter factor per coordinate
      jitter_factor <- fun(y)
      x <- k + runif(length(y), -jitter_factor, jitter_factor)
      
      c <- colors[k]
      w <- 0.5
      
      points(x, y, col = c, cex = w, pch = 19)
      
    }
    
    # x <- jitter(match(df$n, size), factor = 1.0)
    # y <- df$p
    # c <- colors[match(df$n, size)]
    # w <- 0.5
    # # w <- 0.5 * these_included
    # 
    # points(x, y, col = c, cex = w, pch = 19)
   
    if (i == 1) {
      mtext(paste0("f = ", this_f), side = 3, line = 0.5)
    }
    
    if (i == length(tips)) {
      axis(1, lwd = 0, lwd.tick = 1, at = 1:length(size), labels = size, las = 2)
      mtext("n", side = 1, line = 2.5)
    }
    
    if (j == 1) {
      axis(2, lwd = 0, lwd.tick = 1, las = 2)
      mtext("P(neutral)", side = 2, line = 3)
      mtext(paste0("c = ", this_c), side = 2, line = 5)
    }
    
    if (i == 1 & j == 1) {
      legend("topleft", legend = size, col = colors, pch = 19, pt.cex = 1, bty = "n", title = "n")
    }
     
  }
  
}
dev.off()

#######################################
# posterior probability of true model #
#######################################

pdf("figures/posterior_true.pdf", height = 14, width = 12)
layout(layout_mat)
par(mar=c(0,0,0,0), oma = c(4,6.5,2,0) + 0.1)

# loop over rows
for(i in 1:length(tips)) {
  
  this_c <- tips[i]
  
  # loop over columns
  for(j in 1:length(factors)) {
    
    this_f <- factors[j]
    
    # get the relevant samples
    these_summaries <- summaries[summaries$tips == this_c & summaries$factor == this_f,]
    
    # get the posterior of the true model
    these_sizes      <- these_summaries$size
    these_posteriors <- sapply(these_summaries$posteriors, head, n = 1)
    these_set_sizes  <- these_summaries$credible_set_size
    these_included   <- these_summaries$included
    df <- data.frame(n = these_sizes, p = these_posteriors, s = these_set_sizes)
    
    # the vioplot
    v <- vioplot(formula = p ~ n, 
                 data    = df, 
                 ylim    = c(0,1),
                 col     = paste0(colors,"50"),
                 rectCol = NA, lineCol = NA, pchMed = NA, border = NA,
                 names   = size, areaEqual = TRUE,
                 xlab    = NA, ylab = NA, xaxt = "n", yaxt = "n")
    
    # the points
    for(k in 1:length(size)) {
      
      # get base and height
      this_base   <- v$base[[k]]
      this_height <- v$height[[k]]
      
      # approximate function
      fun <- approxfun(this_base, this_height)
      
      # get y coordinates
      y <- df$p[df$n == size[k]]
      
      # get jitter factor per coordinate
      jitter_factor <- fun(y)
      x <- k + runif(length(y), -jitter_factor, jitter_factor)
      
      c <- colors[k]
      w <- 0.5
      
      points(x, y, col = c, cex = w, pch = 19)
      
    }
    
    # # the points
    # x <- jitter(match(df$n, size), factor = 1.0)
    # y <- df$p
    # c <- colors[match(df$n, size)]
    # w <- 0.5
    # # w <- 0.5 * these_included
    # 
    # points(x, y, col = c, cex = w, pch = 19)
    
    if (i == 1) {
      mtext(paste0("f = ", this_f), side = 3, line = 0.5)
    }
    
    if (i == length(tips)) {
      axis(1, lwd = 0, lwd.tick = 1, at = 1:length(size), labels = size, las = 2)
      mtext("n", side = 1, line = 2.5)
    }
    
    if (j == 1) {
      axis(2, lwd = 0, lwd.tick = 1, las = 2)
      mtext("P(true)", side = 2, line = 3)
      mtext(paste0("c = ", this_c), side = 2, line = 5)
    }
    
    if (i == 1 & j == 1) {
      legend("topleft", legend = size, col = colors, pch = 19, pt.cex = 1, bty = "n", title = "n")
    }
    
  }
  
}
dev.off()

######################################
# frequency included in credible set #
######################################

pdf("figures/posterior_in_cs.pdf", height = 14, width = 12)
layout(layout_mat)
par(mar=c(0,0,0,0), oma = c(4,6.5,2,0) + 0.1)

# loop over rows
for(i in 1:length(tips)) {
  
  this_c <- tips[i]
  
  # loop over columns
  for(j in 1:length(factors)) {
    
    this_f <- factors[j]
    
    # get the relevant samples
    these_summaries <- summaries[summaries$tips == this_c & summaries$factor == this_f,]
    
    # get the posterior of the true model
    these_included   <- these_summaries$included
    included_freq    <- sapply(split(these_included, these_summaries$size), mean)
    
    # the points
    x <- size
    y <- included_freq
    w <- 1.0

    # plot    
    plot(1:length(size), y, col = "black", cex = w, pch = NA, xlab = NA, ylab = NA, xaxt = "n", yaxt = "n", ylim = c(0,1), type = "b")
    points(1:length(size), y, col = colors, cex = w, pch = 19, xlab = NA, ylab = NA, xaxt = "n", yaxt = "n", ylim = c(0,1), type = "p")
    
    if (i == 1) {
      mtext(paste0("f = ", this_f), side = 3, line = 0.5)
    }
    
    if (i == length(tips)) {
      axis(1, lwd = 0, lwd.tick = 1, at = 1:length(size), labels = size, las = 2)
      mtext("n", side = 1, line = 2.5)
    }
    
    if (j == 1) {
      axis(2, lwd = 0, lwd.tick = 1, las = 2)
      mtext("P(in set)", side = 2, line = 3)
      mtext(paste0("c = ", this_c), side = 2, line = 5)
    }
    
    if (i == 1 & j == 1) {
      legend("topleft", legend = size, col = colors, pch = 19, pt.cex = 1, bty = "n", title = "n")
    }
    
  }
  
}
dev.off()


##############################
# relative credible-set site #
##############################


pdf("figures/posterior_relative_cs_size.pdf", height = 14, width = 12)
layout(layout_mat)
par(mar=c(0,0,0,0), oma = c(4,6.5,2,0) + 0.1)

# loop over rows
for(i in 1:length(tips)) {
  
  this_c <- tips[i]
  
  # loop over columns
  for(j in 1:length(factors)) {
    
    this_f <- factors[j]
    
    # get the relevant samples
    these_summaries <- summaries[summaries$tips == this_c & summaries$factor == this_f,]
    
    # get the posterior of the true model
    these_sizes      <- these_summaries$size
    these_posteriors <- sapply(these_summaries$posteriors, head, n = 1)
    these_set_sizes  <- these_summaries$credible_set_size
    these_included   <- these_summaries$included
    df <- data.frame(n = these_sizes, p = these_posteriors, s = these_set_sizes)
    
    # the vioplot
    v <- vioplot(formula = s / (4 * n + 1) ~ n, 
                 data    = df, 
                 w       = split(these_included, df$n), 
                 ylim    = c(0,1),
                 col     = paste0(colors,"50"),
                 rectCol = NA, lineCol = NA, pchMed = NA, border = NA,
                 names   = size, areaEqual = TRUE,
                 xlab    = NA, ylab = NA, xaxt = "n", yaxt = "n")
    
    # the points
    for(k in 1:length(size)) {
      
      # get base and height
      this_base   <- v$base[[k]]
      this_height <- v$height[[k]]
      
      # approximate function
      fun <- approxfun(this_base, this_height)
      
      # get y coordinates
      y <- df$s[df$n == size[k]] / (4 * size[k] + 1)
      
      # get jitter factor per coordinate
      jitter_factor <- fun(y)
      x <- k + runif(length(y), -jitter_factor, jitter_factor)
      
      c <- colors[k]
      w <- 0.5 * these_summaries$included[these_summaries$size == size[k]]
      # w <- 0.5 
      
      points(x, y, col = c, cex = w, pch = 19)
      
    }
    
    # the points
    # x <- jitter(match(df$n, size), factor = 1.0)
    # y <- df$s / (4 * df$n + 1)
    # c <- colors[match(df$n, size)]
    # w <- 0.5
    # # w <- 0.5 * these_included
    # 
    # points(x, y, col = c, cex = w, pch = 19)
    
    if (i == 1) {
      mtext(paste0("f = ", this_f), side = 3, line = 0.5)
    }
    
    if (i == length(tips)) {
      axis(1, lwd = 0, lwd.tick = 1, at = 1:length(size), labels = size, las = 2)
      mtext("n", side = 1, line = 2.5, las = 2)
    }
    
    if (j == 1) {
      axis(2, lwd = 0, lwd.tick = 1, las = 2)
      mtext("set size", side = 2, line = 3)
      mtext(paste0("c = ", this_c), side = 2, line = 5)
    }
    
    if (i == 1 & j == 1) {
      legend("topleft", legend = size, col = colors, pch = 19, pt.cex = 1, bty = "n", title = "n")
    }
    
  }
  
}
dev.off()


#########################
# raw credible-set site #
#########################


pdf("figures/posterior_raw_cs_size.pdf", height = 14, width = 12)
layout(layout_mat)
par(mar=c(0,0,0,0), oma = c(4,6.5,2,0) + 0.1)

# loop over rows
for(i in 1:length(tips)) {
  
  this_c <- tips[i]
  
  # loop over columns
  for(j in 1:length(factors)) {
    
    this_f <- factors[j]
    
    # get the relevant samples
    these_summaries <- summaries[summaries$tips == this_c & summaries$factor == this_f,]
    
    # get the posterior of the true model
    these_sizes      <- these_summaries$size
    these_posteriors <- sapply(these_summaries$posteriors, head, n = 1)
    these_set_sizes  <- these_summaries$credible_set_size
    these_included   <- these_summaries$included
    df <- data.frame(n = these_sizes, p = these_posteriors, s = these_set_sizes)
    
    # the vioplot
    v <- vioplot(formula = s ~ n, 
                 data    = df, 
                 ylim    = c(1, 4000),
                 ylog    = TRUE,
                 w       = split(these_included, df$n), 
                 col     = paste0(colors,"50"),
                 rectCol = NA, lineCol = NA, pchMed = NA, border = NA,
                 names   = size, areaEqual = TRUE,
                 xlab    = NA, ylab = NA, xaxt = "n", yaxt = "n")
    
    # the points
    for(k in 1:length(size)) {
      
      # get base and height
      this_base   <- v$base[[k]]
      this_height <- v$height[[k]]
      
      # approximate function
      fun <- approxfun(this_base, this_height)
      
      # get y coordinates
      y <- df$s[df$n == size[k]]
      
      # get jitter factor per coordinate
      jitter_factor <- fun(y)
      x <- k + runif(length(y), -jitter_factor, jitter_factor)
      
      c <- colors[k]
      w <- 0.5 * these_summaries$included[these_summaries$size == size[k]]
      # w <- 0.5 
      
      points(x, y, col = c, cex = w, pch = 19)
      
    }
    
    # the points
    # x <- jitter(match(df$n, size), factor = 1.0)
    # y <- df$s / (4 * df$n + 1)
    # c <- colors[match(df$n, size)]
    # w <- 0.5
    # # w <- 0.5 * these_included
    # 
    # points(x, y, col = c, cex = w, pch = 19)
    
    if (i == 1) {
      mtext(paste0("f = ", this_f), side = 3, line = 0.5)
    }
    
    if (i == length(tips)) {
      axis(1, lwd = 0, lwd.tick = 1, at = 1:length(size), labels = size, las = 2)
      mtext("n", side = 1, line = 2.5, las = 2)
    }
    
    if (j == 1) {
      axis(2, lwd = 0, lwd.tick = 1, las = 2)
      mtext("set size", side = 2, line = 3)
      mtext(paste0("c = ", this_c), side = 2, line = 5)
    }
    
    if (i == 1 & j == 1) {
      legend("topleft", legend = size, col = colors, pch = 19, pt.cex = 0.5, bty = "n", title = "n")
    }
    
  }
  
}
dev.off()

