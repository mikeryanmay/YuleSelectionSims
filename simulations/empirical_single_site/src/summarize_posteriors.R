# RUN FROM simulations/single_site
# setwd("simulations/empirical_single_site/")

library(matrixStats)
library(ape)
library(TreeTools)
library(RColorBrewer)
library(ggplot2)
library(viridis)

# load vioplot function
source("../../src/weighted_vioplot.R")

# specify figure directory
# figdir <- "figures/"
figdir <- "~/repos/yuleselectionMS/figures/"

# enumerate the analyses
tips   <- c(100, 200, 400, 800, 1600)
size   <- 1
factor <- c(1.5, 2, 2.5, 3)
reps   <- 500

# make all combinations
grid <- expand.grid(tips = tips, size = size, factor = factor, rep = 1:reps, stringsAsFactors = FALSE)

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
  this_tsv <- paste0("sims/tips_", this_tips, "_f_", this_factor, "/rep_", this_rep, "/site_models.tsv")
  if ( file.exists(this_tsv) == FALSE ) {
    return(NULL)
  }
  
  # read output file
  results <- read.table(this_tsv, header = TRUE, sep = "\t", stringsAsFactors = FALSE)
  
  # normalize the likelihoods for numerical purposes
  results$lik <- results$lik - max(results$lik)
  
  # number of models
  num_models <- nrow(results) - 1
  
  
  # compute posterior probabilities of single-site (and constant) models
  prior_constant         <- 0.5
  prior_selected         <- 1 - prior_constant
  prior_over_models      <- rep( prior_selected / (nrow(results) - 1) , nrow(results))
  prior_over_models[results$model == "neutral"] <- prior_constant
  posterior_over_models  <- exp(results$lik) * prior_over_models
  posterior_over_models  <- posterior_over_models / sum(posterior_over_models)
  posterior_over_models  <- round(posterior_over_models, 10)
  
  # compute cumulative sorted posteriors
  posteriors <- posterior_over_models
  names(posteriors) <- results$model
  posteriors <- sort(posteriors, decreasing = TRUE)
  cum_posteriors <- cumsum(posteriors)
  
  # determine which models are definitely in the set
  if ( cum_posteriors[1] > 0.95 ) {
    definitely_in_set <- 1
  } else {
    definitely_in_set <- which(cum_posteriors < 0.95)  
  }
  
  # compute the remaining prob in set
  remainder <- 0.95 - max(cum_posteriors[definitely_in_set])
  if ( remainder > 0 ) {
    new_prob <- posteriors[max(definitely_in_set) + 1]
    if ( runif(1) < remainder / new_prob ) {
      definitely_in_set <- c(definitely_in_set, max(definitely_in_set) + 1)
    }
  }
  
  # get the models in the posterior
  contained_models <- names(posteriors[definitely_in_set])
  
  # check if neutral model is in set
  neutral_in_set <- as.numeric("neutral" %in% contained_models)
  
  # check if each true model is in the set
  true_site_contained <- as.numeric("1A" %in% contained_models)
  
  # compute whether true model is top ranked
  true_model_top_ranked <- as.numeric(contained_models[1] == "1A")
  
  # compute whether only true model is in set
  true_model_exclusive <- as.numeric(any((contained_models == "1A") == FALSE) == FALSE)
  
  # summarize posterior of true model
  this_tsv <- paste0("sims/tips_", this_tips, "_f_", this_factor, "/rep_", this_rep, "/true_model.tsv")
  fit_results <- read.table(this_tsv, header = TRUE, sep = "\t", stringsAsFactors = FALSE)
  
  # return
  res <- data.frame(tips                 = this_tips,
                    size                 = this_size, 
                    factor               = this_factor, 
                    rep                  = this_rep,
                    neutral_in_set       = neutral_in_set,
                    true_site_contained  = true_site_contained,
                    true_site_top_ranked = true_model_top_ranked,
                    only_site_true       = true_model_exclusive,
                    posterior_mean       = fit_results$posterior_mean,
                    posterior_var        = fit_results$posterior_var,
                    posterior_sd         = fit_results$posterior_sd,
                    posterior_quant      = fit_results$posterior_quant,
                    posterior_contain    = fit_results$is_contained,
                    posterior_PEST       = fit_results$PESL)
  
  return(res)
  
}))

print(dim(summaries))

#######################
# model probabilities #
#######################

colors <- gsub("FF", "", turbo(4, begin = 0.1, end = 0.95))
w <- 1.0
xlim <- c(1,length(tips))

layout_mat <- matrix(1:(length(factor)), ncol = length(factor), nrow = 1, byrow = TRUE)

pdf(paste0(figdir, "empirical_single_site_coverage.pdf"), height = 3.5, width = 12)
layout(layout_mat)
par(mar=c(0,0,0,0), oma = c(4,4.5,2,0) + 0.1, lend = 2)

for(i in 1:length(factor)) {
  
  # get the factor
  this_f <- factor[i]
  
  # get the relevant samples
  these_summaries <- summaries[summaries$factor == this_f,]

  plot(1, col = "black", cex = w, pch = NA, xlab = NA, ylab = NA, xaxt = "n", yaxt = "n", xlim = xlim, ylim = c(0,1), type = "b")
  abline(h = 0.95, lty = 2)
  
  if ( nrow(these_summaries) > 0 ) {
    
    # have data
    
    # is neutral model in set
    these_neu <- these_summaries$neutral_in_set
    neu_freq  <- sapply(split(these_neu, these_summaries$tips), mean)
    neu_num   <- sapply(split(these_neu, these_summaries$tips), length)
    
    # is true site in set
    these_true <- these_summaries$true_site_contained
    true_freq  <- sapply(split(these_true, these_summaries$tips), mean)
    
    # is true site top ranked
    map_true <- these_summaries$true_site_top_ranked
    map_freq <- sapply(split(map_true, these_summaries$tips), mean)
    
    # is true and exlusive
    true_exclusive      <- these_summaries$only_site_true
    true_exclusive_freq <- sapply(split(true_exclusive, these_summaries$tips), mean)
    
    # plot
    points(neu_freq,            cex = w, col = colors[1], pch = 19, type = "b")
    points(true_freq,           cex = w, col = colors[2], pch = 19, type = "b")
    points(map_freq,            cex = w, col = colors[3], pch = 19, type = "b")
    points(true_exclusive_freq, cex = w, col = colors[4], pch = 19, type = "b")
    
  } 
  
  mtext(paste0("f = ", this_f), side = 3, line = 0.5)
  axis(1, lwd = 0, lwd.tick = 1, at = 1:length(tips), labels = tips, las = 2)
  mtext("c", side = 1, line = 2.75)
  
  if (i == 1) {
    axis(2, lwd = 0, lwd.tick = 1, las = 2)
    mtext("frequency", side = 2, line = 3)
  }
  
  if (i == 1) {
    legend(x = 3.5, y = 0.65, legend = c("neutral in set", "true in set", "true top ranked", "only true in set"), title = "event", pch = 19, pt.cex = 1, bty = "n", ncol = 1, col = colors)
  }
  
}
dev.off()

#######################
# posterior estimates #
#######################

# colors <- brewer.pal(6, "Set1")
colors <- gsub("FF", "", plasma(length(tips), begin = 0.1, end = 0.9))

layout_mat <- matrix(1:(4 * length(factor)), ncol = length(factor), nrow = 4, byrow = TRUE)
layout_mat <- layout_mat[4:1,]

xlim <- c(1, length(tips))
xlim[1] <- xlim[1] - 0.5
xlim[2] <- xlim[2] + 0.5

pdf(paste0(figdir, "empirical_single_site_posterior_estimates.pdf"), height = 8, width = 12)
layout(layout_mat)
par(mar=c(0,0,0,0), oma = c(4,5.5,2,0) + 0.1)

# posterior expected loss
for(i in 1:length(factor)) {
  
  this_f <- factor[i]
  
  # get the relevant samples
  these_summaries <- summaries[summaries$factor == this_f,]
  
  # make into data frame
  these_tips   <- these_summaries$tips
  these_widths <- these_summaries$posterior_PEST
  df <- data.frame(c = these_tips, l = these_widths)
  
  if ( nrow(df) == 0 ) {
    plot(1, pch = NA, xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
    next
  }
  
  ymax <- max(pretty(quantile(summaries$posterior_PEST, 0.95)))
  
  # the vioplot
  v <- vioplot(formula = l ~ c,
               data    = df,
               ylim    = c(0, ymax),
               xlim    = xlim,
               col     = paste0(colors,"50"),
               rectCol = NA, lineCol = NA, pchMed = NA, border = NA,
               names   = size, areaEqual = FALSE,
               xlab    = NA, ylab = NA, xaxt = "n", yaxt = "n")
  
  # the points
  for(k in 1:length(v$base)) {
    
    # get base and height
    if ( any(tips[k] %in% df$c) == FALSE ) {
      next
    }
    
    this_base   <- v$base[[k]]
    this_height <- v$height[[k]]
    
    if ( all(is.na(this_height)) ) {
      fun <- function(x) 1/3
    } else {
      # approximate function
      fun <- approxfun(this_base, this_height)
    }
    
    # get y coordinates
    y <- df$l[df$c == tips[k]]
    
    # subset the coordinates
    # y <- sample(y, size = 200)
    
    # get jitter factor per coordinate
    jitter_factor <- fun(y)
    x <- k + runif(length(y), -jitter_factor, jitter_factor)
    
    c <- colors[k]
    w <- 0.3
    
    points(x, y, col = c, cex = w, pch = 19)
    
  }
  
  # mtext(paste0("f = ", this_f), side = 3, line = 0.5)
  axis(1, lwd = 0, lwd.tick = 1, at = 1:length(tips), labels = tips, las = 2)
  mtext("c", side = 1, line = 2.5)
  
  if (i == 1) {
    axis(2, lwd = 0, lwd.tick = 1, las = 2)
    mtext("posterior expected\nsquared error", side = 2, line = 3)
  }
  
}

# posterior widths
for(i in 1:length(factor)) {
  
  this_f <- factor[i]
  
  # get the relevant samples
  these_summaries <- summaries[summaries$factor == this_f,]
  
  # make into data frame
  these_tips   <- these_summaries$tips
  these_widths <- these_summaries$posterior_sd
  df <- data.frame(c = these_tips, m = these_widths)
  
  if ( nrow(df) == 0 ) {
    plot(1, pch = NA, xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
    next
  }
  
  ymax <- max(pretty(quantile(summaries$posterior_sd, 0.95)))
  
  # the vioplot
  v <- vioplot(formula = m ~ c,
               data    = df,
               ylim    = c(0, ymax),
               xlim    = xlim,
               col     = paste0(colors,"50"),
               rectCol = NA, lineCol = NA, pchMed = NA, border = NA,
               names   = size, areaEqual = FALSE,
               xlab    = NA, ylab = NA, xaxt = "n", yaxt = "n")
  
  # the points
  for(k in 1:length(v$base)) {
    
    # get base and height
    if ( any(tips[k] %in% df$c) == FALSE ) {
      next
    }
    
    this_base   <- v$base[[k]]
    this_height <- v$height[[k]]
    
    if ( all(is.na(this_height)) ) {
      fun <- function(x) 1/3
    } else {
      # approximate function
      fun <- approxfun(this_base, this_height)
    }
    
    # get y coordinates
    y <- df$m[df$c == tips[k]]
    
    # get jitter factor per coordinate
    jitter_factor <- fun(y)
    x <- k + runif(length(y), -jitter_factor, jitter_factor)
    
    c <- colors[k]
    w <- 0.3
    
    points(x, y, col = c, cex = w, pch = 19)
    
  }
  
  if (i == 1) {
    axis(2, lwd = 0, lwd.tick = 1, las = 2)
    mtext("posterior sd", side = 2, line = 3)
  }
  
}

# posterior means
for(i in 1:length(factor)) {
  
  this_f <- factor[i]
  
  # get the relevant samples
  these_summaries <- summaries[summaries$factor == this_f,]
  
  # make into data frame
  these_tips  <- these_summaries$tips
  these_means <- these_summaries$posterior_mean
  df <- data.frame(c = these_tips, m = these_means)
  
  if ( nrow(df) == 0 ) {
    plot(1, pch = NA, xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
    next
  }
  
  ymax <- max(pretty(quantile(summaries$posterior_mean, 0.95)))
  
  # the vioplot
  v <- vioplot(formula = m ~ c,
               data    = df,
               ylim    = c(0, 5),
               xlim    = xlim,
               col     = paste0(colors,"50"),
               rectCol = NA, lineCol = NA, pchMed = NA, border = NA,
               names   = size, areaEqual = FALSE,
               xlab    = NA, ylab = NA, xaxt = "n", yaxt = "n")
  
  # the points
  for(k in 1:length(v$base)) {
    
    # get base and height
    if ( any(tips[k] %in% df$c) == FALSE ) {
      next
    }
    
    this_base   <- v$base[[k]]
    this_height <- v$height[[k]]
    
    if ( all(is.na(this_height)) ) {
      fun <- function(x) 1/3
    } else {
      # approximate function
      fun <- approxfun(this_base, this_height)
    }
    
    # get y coordinates
    y <- df$m[df$c == tips[k]]
    
    # get jitter factor per coordinate
    jitter_factor <- fun(y)
    x <- k + runif(length(y), -jitter_factor, jitter_factor)
    
    c <- colors[k]
    w <- 0.3
    
    points(x, y, col = c, cex = w, pch = 19)
    
  }
  
  abline(h = this_f, lty = 2)
  
  if (i == 1) {
    axis(2, lwd = 0, lwd.tick = 1, las = 2)
    mtext(bquote(hat(f) ~ plain("(posterior mean)")), side = 2, line = 3)
  }
  
}

# coverage
for(i in 1:length(factor)) {
  
  this_f <- factor[i]
  
  # get the relevant samples
  these_summaries <- summaries[summaries$factor == this_f,]
  
  # make into data frame
  these_tips    <- these_summaries$tips
  these_covered <- these_summaries$posterior_contain
  df            <- data.frame(c = these_tips, m = these_covered)
  
  if ( nrow(df) == 0 ) {
    plot(1, pch = NA, xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
    next
  }
  
  # compute coverage
  coverage <- sapply(split(df, df$c), function(x) mean(x$m))
  
  plot(coverage, col = "black", type = "b", pch = NA, xlim = xlim, ylim = c(0, 1),
       xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
  abline(h = 0.95, lty = 2)
  points(coverage, col = colors, pch = 19)
  
  mtext(paste0("f = ", this_f), side = 3, line = 0.5)
  # axis(1, lwd = 0, lwd.tick = 1, at = 1:length(tips), labels = tips, las = 2)
  # mtext("c", side = 1, line = 2.5)
  
  if (i == 1) {
    axis(2, lwd = 0, lwd.tick = 1, las = 2)
    mtext("coverage", side = 2, line = 3)
  }
  
  if (i == 1) {
    legend("bottomleft", legend = tips, col = colors, pch = 19, pt.cex = 1, bty = "n", title = "c")
  }
  
}

dev.off()























