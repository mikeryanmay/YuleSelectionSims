# RUN FROM simulations/single_site
# setwd("simulations/single_site/")

library(matrixStats)
library(ape)
library(TreeTools)
library(RColorBrewer)
library(ggplot2)
library(parallel)
library(coda)
library(viridis)

# load vioplot function
source("../../src/weighted_vioplot.R")

# specify figure directory
# figdir <- "figures/"
figdir <- "~/repos/yuleselectionMS/figures/"

# enumerate the analyses
true_lambda <- 0.12
tips    <- c(50, 100, 250, 500, 750, 1000)
size    <- c(1, 10, 100, 1000)
factors <- c(1, 1.5, 2, 2.5, 3, 4)
reps    <- 1:200

# make all combinations
grid <- expand.grid(tips = tips, size = size, factor = factors, rep = reps, stringsAsFactors = FALSE)

# compute all the summaries
summaries <- do.call(rbind, mclapply(1:nrow(grid), function(i) {
  
  # get the analysis
  this_grid   <- grid[i,]
  this_tips   <- this_grid$tips
  this_size   <- this_grid$size
  this_factor <- this_grid$factor
  this_rep    <- this_grid$rep
  
  cat(i, " -- ", nrow(grid),"\n", sep = "")
  
  # check if the output file exists
  this_log <- paste0("factor/tips_", this_tips, "_size_", this_size, "_factor_", this_factor, "/rep_", this_rep, "/posterior.log")
  if ( file.exists(this_log) == FALSE ) {
    return(NULL)
  }
  
  # read output file
  results <- read.table(this_log, header = TRUE, sep = "\t", stringsAsFactors = FALSE)
  
  # check convergence
  failed <- effectiveSize(results$lambda1) < 1000
  
  # compute posterior mean
  posterior_mean <- mean(results$lambda1)
  
  # compute posterior error
  # posterior_expected_loss <- mean((results$lambda1 - posterior_mean)^2)
  posterior_expected_loss <- mean((results$lambda1 - true_lambda * this_factor)^2)
  
  # 95% quantile
  posterior_quantile <- as.numeric(quantile(results$lambda1, c(0.025, 0.975)))
  
  # width of quantile
  posterior_width <- diff(posterior_quantile)
  
  # coefficient of variance
  # variance <- mean((results$lambda1 - posterior_mean)^2)
  # posterior_cv <- sqrt(variance) / posterior_mean
  posterior_cv <- sd(results$lambda1) / posterior_mean
  
  # is included
  true_value <- true_lambda * this_factor
  included   <- true_value > posterior_quantile[1] & true_value < posterior_quantile[2]
  
  # return
  res <- data.frame(tips              = this_tips,
                    size              = this_size, 
                    factor            = this_factor, 
                    rep               = this_rep,
                    posterior_mean    = posterior_mean,
                    posterior_width   = posterior_width,
                    posterior_cv      = posterior_cv,
                    posterior_expected_loss = posterior_expected_loss,
                    included          = included,
                    converged         = !failed)
  
  return(res)
  
}, mc.cores = 4))

print(dim(summaries))

###########################
# posterior-mean estimate #
###########################

# colors <- brewer.pal(6, "Set1")
colors <- gsub("FF", "", plasma(6, begin = 0.1, end = 0.9))
col_theoretical <- "black"

layout_mat <- matrix(1:(4 * length(factors)), ncol = length(factors), nrow = 4, byrow = TRUE)
layout_mat <- layout_mat[4:1,]

pdf(paste0(figdir, "posterior_estimates.pdf"), height = 8, width = 12)
layout(layout_mat)
par(mar=c(0,0,0,0), oma = c(4,5.5,2,0) + 0.1)

# posterior expected loss
for(i in 1:length(factors)) {
  
  this_f <- factors[i]
  
  # get the relevant samples
  these_summaries <- summaries[summaries$factor == this_f,]
  
  # make into data frame
  these_tips   <- these_summaries$tips
  these_widths <- these_summaries$posterior_expected_loss
  these_conv   <- these_summaries$converged
  df <- data.frame(c = these_tips, l = these_widths, p = these_conv)
  df <- df[df$p,]
  
  if ( nrow(df) == 0 ) {
    plot(1, pch = NA, xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
    next
  }
  
  # the vioplot
  v <- vioplot(formula = l ~ c,
               data    = df,
               ylim    = c(0, 0.15),
               col     = paste0(colors,"50"),
               rectCol = NA, lineCol = NA, pchMed = NA, border = NA,
               names   = size, areaEqual = TRUE,
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
    y <- sample(y, size = 200)
    
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
  
  # if (i == 1) {
  #   legend("topleft", legend = tips, col = colors, pch = 19, pt.cex = 1, bty = "n", title = "c")
  # }
  
}

# posterior widths
for(i in 1:length(factors)) {
  
  this_f <- factors[i]
  
  # get the relevant samples
  these_summaries <- summaries[summaries$factor == this_f,]
  
  # make into data frame
  these_tips   <- these_summaries$tips
  these_widths <- these_summaries$posterior_width
  these_conv   <- these_summaries$converged
  df <- data.frame(c = these_tips, m = these_widths, p = these_conv)
  df <- df[df$p,]
  
  if ( nrow(df) == 0 ) {
    plot(1, pch = NA, xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
    next
  }
  
  # the vioplot
  v <- vioplot(formula = m ~ c,
               data    = df,
               ylim    = c(0, 1),
               col     = paste0(colors,"50"),
               rectCol = NA, lineCol = NA, pchMed = NA, border = NA,
               names   = size, areaEqual = TRUE,
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
    
    # subset the coordinates
    y <- sample(y, size = 200)
    
    # get jitter factor per coordinate
    jitter_factor <- fun(y)
    x <- k + runif(length(y), -jitter_factor, jitter_factor)
    
    c <- colors[k]
    w <- 0.3
    
    points(x, y, col = c, cex = w, pch = 19)
    
  }
  
  # mtext(paste0("f = ", this_f), side = 3, line = 0.5)
  # axis(1, lwd = 0, lwd.tick = 1, at = 1:length(tips), labels = tips, las = 2)
  # mtext("c", side = 1, line = 2.5)
  
  if (i == 1) {
    axis(2, lwd = 0, lwd.tick = 1, las = 2)
    mtext("posterior width", side = 2, line = 3)
  }
  
  # if (i == 1) {
  #   legend("topleft", legend = tips, col = colors, pch = 19, pt.cex = 1, bty = "n", title = "c")
  # }
  
}

# posterior means
for(i in 1:length(factors)) {
  
  this_f <- factors[i]
  
  # get the relevant samples
  these_summaries <- summaries[summaries$factor == this_f,]
  
  # make into data frame
  these_tips  <- these_summaries$tips
  these_means <- these_summaries$posterior_mean
  these_conv  <- these_summaries$converged
  df <- data.frame(c = these_tips, m = these_means, p = these_conv)
  df <- df[df$p,]
  
  if ( nrow(df) == 0 ) {
    plot(1, pch = NA, xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
    next
  }
  
  # the vioplot
  v <- vioplot(formula = m ~ c,
               data    = df,
               ylim    = c(0, 0.8),
               col     = paste0(colors,"50"),
               rectCol = NA, lineCol = NA, pchMed = NA, border = NA,
               names   = size, areaEqual = TRUE,
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
    
    # subset the coordinates
    y <- sample(y, size = 200)
    
    # get jitter factor per coordinate
    jitter_factor <- fun(y)
    x <- k + runif(length(y), -jitter_factor, jitter_factor)
    
    c <- colors[k]
    w <- 0.3
    
    points(x, y, col = c, cex = w, pch = 19)
    
  }
    
  abline(h = true_lambda * this_f, lty = 2)
  
  # mtext(paste0("f = ", this_f), side = 3, line = 0.5)
  # axis(1, lwd = 0, lwd.tick = 1, at = 1:length(tips), labels = tips, las = 2)
  # mtext("c", side = 1, line = 2.5)
  
  if (i == 1) {
    axis(2, lwd = 0, lwd.tick = 1, las = 2)
    mtext(bquote(lambda[1] ~ plain("(posterior mean)")), side = 2, line = 3)
  }
  
  # if (i == 1) {
  #   legend("topleft", legend = tips, col = colors, pch = 19, pt.cex = 1, bty = "n", title = "c")
  # }
   
}

new_xlim <- v$xlim

# coverage
for(i in 1:length(factors)) {
  
  this_f <- factors[i]
  
  # get the relevant samples
  these_summaries <- summaries[summaries$factor == this_f,]
  
  # make into data frame
  these_tips    <- these_summaries$tips
  these_covered <- these_summaries$included
  these_conv    <- these_summaries$converged
  df            <- data.frame(c = these_tips, m = these_covered, p = these_conv)
  df            <- df[df$p,]
  
  if ( nrow(df) == 0 ) {
    plot(1, pch = NA, xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
    next
  }
  
  # compute coverage
  coverage <- sapply(split(df, df$c), function(x) mean(x$m))
  
  plot(coverage, col = "black", type = "b", pch = NA, xlim = new_xlim, ylim = c(0, 1),
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










