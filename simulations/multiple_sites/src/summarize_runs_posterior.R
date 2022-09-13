# RUN FROM simulations/single_site
# setwd("simulations/multiple_sites/")

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
tips    <- c(50, 100, 250, 500, 750, 1000)
size    <- c(1, 2, 3, 4)
factors <- c(1.5, 2, 2.5, 3)
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
  this_tsv <- paste0("sims/tips_", this_tips, "_size_", this_size, "_f_", this_factor, "/rep_", this_rep, "/site_models.tsv")
  if ( file.exists(this_tsv) == FALSE ) {
    return(NULL)
  }

  # read output file
  results <- read.table(this_tsv, header = TRUE, sep = "\t", stringsAsFactors = FALSE)

  # get the single site (and constant-rate) models, normalize likelihood
  single_site_models <- results[1:401,]
  single_site_models$lik <- single_site_models$lik - max(single_site_models$lik)

  # compute posterior probabilities of single-site (and constant) models
  prior_constant         <- 0.5
  prior_selected         <- 1 - prior_constant
  prior_over_models      <- rep( prior_selected / (nrow(single_site_models) - 1) , nrow(single_site_models))
  prior_over_models[single_site_models$model == "neutral"] <- prior_constant
  posterior_over_models  <- exp(single_site_models$lik) * prior_over_models
  posterior_over_models  <- posterior_over_models / sum(posterior_over_models)
  posterior_over_models  <- round(posterior_over_models, 10)
  
  # compute cumulative sorted posteriors
  posteriors <- posterior_over_models
  names(posteriors) <- single_site_models$model
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
  true_site_contained <- logical(this_size)
  for(j in 1:this_size) {
    this_site_model <- paste0(j, "A")
    true_site_contained[j] <- this_site_model %in% contained_models
  }
  
  # summaries
  any_site_true        <- any(true_site_contained)
  all_sites_true       <- all(true_site_contained)
  only_sites_true      <- mean(contained_models %in% paste0(1:this_size, "A")) == 1
  all_sites_top_ranked <- all(match(paste0(1:this_size, "A"), names(cum_posteriors)) <= this_size)
  # contained_false_models <- contained_models[contained_models %in% paste0(1:this_size, "A") == FALSE]
  # all_sites_top_ranked   <- any(match(contained_false_models, contained_models) <= this_size) == FALSE
  top_rank_model_is_true <- contained_models[1] %in% paste0(1:this_size, "A")
  
  # bayes factors of best single-site model against true model, combined model
  best_single_site_model_likelihood <- max(results$lik[1:401])
  combined_model_likelihood         <- tail(results$lik, 1)
  true_model_likelihood             <- results$lik[results$model == "true"]
  bf_combined_vs_single             <- 2 * (combined_model_likelihood - best_single_site_model_likelihood)
  bf_true_vs_single                 <- 2 * (true_model_likelihood - best_single_site_model_likelihood)
  bf_true_vs_combined               <- 2 * (true_model_likelihood - combined_model_likelihood)
  
  # return
  res <- data.frame(tips                   = this_tips,
                    size                   = this_size, 
                    factor                 = this_factor, 
                    rep                    = this_rep,
                    neutral_in_set         = neutral_in_set,
                    any_site_true          = any_site_true,
                    all_sites_true         = all_sites_true,
                    only_sites_true        = only_sites_true,
                    all_sites_top_ranked   = all_sites_top_ranked,
                    top_rank_model_is_true = top_rank_model_is_true,
                    bf_combined_vs_single  = bf_combined_vs_single,
                    bf_true_vs_single      = bf_true_vs_single,
                    bf_true_vs_combined    = bf_true_vs_combined,
                    one_model_in_set       = length(contained_models) == 1
                    )
  
  return(res)
  
}))

print(dim(summaries))

######################################
# frequency included in credible set #
######################################

# colors <- brewer.pal(4, "Set1")
colors <- gsub("FF", "", plasma(6, begin = 0.1, end = 0.9))
col_theoretical <- "black"

layout_mat <- matrix(1:(length(size) * length(factors)), ncol = length(factors), nrow = length(size), byrow = TRUE)

points <- c(15, 3, 4, 19)
width  <- c(1, 1.5, 1.5, 1)

pdf(paste0(figdir, "multisite_coverage.pdf"), height = 10, width = 12)

layout(layout_mat)
par(mar=c(0,0,0,0), oma = c(4,6.5,2,0) + 0.1, lend = 2)

# loop over rows
for(i in 1:length(size)) {
  
  this_n <- size[i]
  
  # loop over columns
  for(j in 1:length(factors)) {
    
    this_f <- factors[j]
    
    # get the relevant samples
    these_summaries <- summaries[summaries$size == this_n & summaries$factor == this_f,]
    
    if ( nrow(these_summaries) == 0 ) {
      plot(1, col = "black", cex = w, pch = NA, xlab = NA, ylab = NA, xaxt = "n", yaxt = "n", ylim = c(0,1), type = "b")
    } else {
      
      # is neutral model in set
      these_neu <- these_summaries$neutral_in_set
      neu_freq  <- sapply(split(these_neu, these_summaries$tips), mean)
      
      # is any site true?
      these_any_true   <- these_summaries$any_site_true
      any_true_freq    <- sapply(split(these_any_true, these_summaries$tips), mean)
      
      # are all sites true?
      these_all_true   <- these_summaries$all_sites_true
      all_true_freq    <- sapply(split(these_all_true, these_summaries$tips), mean)
      
      # are all sites top ranked?
      these_top_rank   <- these_summaries$all_sites_top_ranked
      top_rank_freq    <- sapply(split(these_top_rank, these_summaries$tips), mean)
      
      # the points
      x <- size
      y <- any_true_freq
      w <- 1.2
      
      # plot
      plot(1:length(tips), pch = NA, xlab = NA, ylab = NA, xaxt = "n", yaxt = "n", ylim = c(0,1), type = "p")
      abline(h = 0.95, lty = 2)
      
      points(which(tips %in% names(neu_freq)), neu_freq, col = "black", cex = w, pch = NA, xlab = NA, ylab = NA, xaxt = "n", yaxt = "n", ylim = c(0,1), type = "b")
      points(which(tips %in% names(neu_freq)), neu_freq, col = colors, cex = w, pch = points[1], xlab = NA, ylab = NA, xaxt = "n", yaxt = "n", ylim = c(0,1), type = "p", lwd = width[1])
      
      points(which(tips %in% names(any_true_freq)), any_true_freq, col = "black", cex = w, pch = NA, xlab = NA, ylab = NA, xaxt = "n", yaxt = "n", ylim = c(0,1), type = "b")
      points(which(tips %in% names(any_true_freq)), any_true_freq, col = colors, cex = w, pch = points[2], xlab = NA, ylab = NA, xaxt = "n", yaxt = "n", ylim = c(0,1), type = "p", lwd = width[2])
      
      points(which(tips %in% names(all_true_freq)), all_true_freq, col = "black", cex = w, pch = NA, xlab = NA, ylab = NA, xaxt = "n", yaxt = "n", ylim = c(0,1), type = "b")
      points(which(tips %in% names(all_true_freq)), all_true_freq, col = colors, cex = w, pch = points[3], xlab = NA, ylab = NA, xaxt = "n", yaxt = "n", ylim = c(0,1), type = "p", lwd = width[3])
      
      points(which(tips %in% names(top_rank_freq)), top_rank_freq, col = "black", cex = w, pch = NA, xlab = NA, ylab = NA, xaxt = "n", yaxt = "n", ylim = c(0,1), type = "b")
      points(which(tips %in% names(top_rank_freq)), top_rank_freq, col = colors, cex = w, pch = points[4], xlab = NA, ylab = NA, xaxt = "n", yaxt = "n", ylim = c(0,1), type = "p", lwd = width[4])
      
    }
    
    if (i == 1) {
      mtext(paste0("f = ", this_f), side = 3, line = 0.5)
    }
    
    if (i == length(size)) {
      axis(1, lwd = 0, lwd.tick = 1, at = 1:length(tips), labels = tips, las = 2)
      mtext("number of samples", side = 1, line = 2.75)
    }
    
    if (j == 1) {
      axis(2, lwd = 0, lwd.tick = 1, las = 2)
      mtext("frequency", side = 2, line = 3)
      mtext(paste0("l = ", this_n), side = 2, line = 5)
    }
    
    if (i == 1 & j == 2) {
      legend("right", legend = tips, col = colors, pch = 19, pt.cex = 1, bty = "n", title = "# samples", ncol = 2, title.adj = 0.5)
    }
    
    if (i == 1 & j == 3) {
      legend("right", legend = c("neutral in set", "at least one site in set", "all sites in set", "all sites top ranked"), title = "event", pch = points, pt.cex = 1, bty = "n", ncol = 1, lwd = width, lty = NA, seg.len = 0)
    }
    
  }
  
}
dev.off()

############################################
# frequency included in credible set (alt) #
############################################

# color determines the type of event
# colors <- gsub("FF", "", plasma(4, begin = 0.1, end = 0.9))
# colors <- gsub("FF", "", viridis(5, begin = 0.1, end = 0.95))
# colors <- gsub("FF", "", turbo(5, begin = 0.1, end = 0.95))
colors <- gsub("FF", "", turbo(6, begin = 0.1, end = 0.95))

# points represent nothing in particular
points <- c(19, 19, 19, 19, 19, 19)
width  <- c(1, 1, 1, 1, 1, 1)
w      <- 1 # size of point

layout_mat <- matrix(1:(length(size) * length(factors)), ncol = length(factors), nrow = length(size), byrow = TRUE)

pdf(paste0(figdir, "multisite_coverage_alt.pdf"), height = 10, width = 12)

layout(layout_mat)
par(mar=c(0,0,0,0), oma = c(4,6.5,2,0) + 0.1, lend = 2)

# loop over rows
for(i in 1:length(size)) {
  
  this_n <- size[i]
  
  # loop over columns
  for(j in 1:length(factors)) {
    
    this_f <- factors[j]
    
    # get the relevant samples
    these_summaries <- summaries[summaries$size == this_n & summaries$factor == this_f,]
    
    if ( nrow(these_summaries) == 0 ) {
      plot(1, col = "black", cex = w, pch = NA, xlab = NA, ylab = NA, xaxt = "n", yaxt = "n", ylim = c(0,1), type = "b")
    } else {
      
      # is neutral model in set
      these_neu <- these_summaries$neutral_in_set
      neu_freq  <- sapply(split(these_neu, these_summaries$tips), mean)
      neu_num   <- sapply(split(these_neu, these_summaries$tips), length)
      neu_q_l   <- numeric(length(neu_num))
      neu_q_u   <- numeric(length(neu_num))
      for(k in 1:length(neu_num)) {
        neu_q_l[k] <- qbinom(0.025, neu_num[k], neu_freq[k]) / neu_num[k]
        neu_q_u[k] <- qbinom(0.975, neu_num[k], neu_freq[k]) / neu_num[k]
      }

      # is any site true?
      these_any_true <- these_summaries$any_site_true
      any_true_freq  <- sapply(split(these_any_true, these_summaries$tips), mean)
      any_true_num   <- sapply(split(these_any_true, these_summaries$tips), length)
      any_true_q_l   <- numeric(length(any_true_num))
      any_true_q_u   <- numeric(length(any_true_num))
      for(k in 1:length(any_true_num)) {
        any_true_q_l[k] <- qbinom(0.025, any_true_num[k], any_true_freq[k]) / any_true_num[k]
        any_true_q_u[k] <- qbinom(0.975, any_true_num[k], any_true_freq[k]) / any_true_num[k]
      }
      
      # are all sites true?
      these_all_true <- these_summaries$all_sites_true
      all_true_freq  <- sapply(split(these_all_true, these_summaries$tips), mean)
      all_true_num   <- sapply(split(these_all_true, these_summaries$tips), length)
      all_true_q_l   <- numeric(length(all_true_num))
      all_true_q_u   <- numeric(length(all_true_num))
      for(k in 1:length(all_true_num)) {
        all_true_q_l[k] <- qbinom(0.025, all_true_num[k], all_true_freq[k]) / all_true_num[k]
        all_true_q_u[k] <- qbinom(0.975, all_true_num[k], all_true_freq[k]) / all_true_num[k]
      }

      # are only sites true?
      these_only_true <- these_summaries$only_sites_true
      only_true_freq  <- sapply(split(these_only_true, these_summaries$tips), mean)
      only_true_num   <- sapply(split(these_only_true, these_summaries$tips), length)
      only_true_q_l   <- numeric(length(only_true_num))
      only_true_q_u   <- numeric(length(only_true_num))
      for(k in 1:length(only_true_num)) {
        only_true_q_l[k] <- qbinom(0.025, only_true_num[k], only_true_freq[k]) / only_true_num[k]
        only_true_q_u[k] <- qbinom(0.975, only_true_num[k], only_true_freq[k]) / only_true_num[k]
      }
      
      # are all sites top ranked?
      these_top_rank <- these_summaries$all_sites_top_ranked
      top_rank_freq  <- sapply(split(these_top_rank, these_summaries$tips), mean)
      top_rank_num   <- sapply(split(these_top_rank, these_summaries$tips), length)
      top_rank_q_l   <- numeric(length(top_rank_num))
      top_rank_q_u   <- numeric(length(top_rank_num))
      for(k in 1:length(top_rank_num)) {
        top_rank_q_l[k] <- qbinom(0.025, top_rank_num[k], top_rank_freq[k]) / top_rank_num[k]
        top_rank_q_u[k] <- qbinom(0.975, top_rank_num[k], top_rank_freq[k]) / top_rank_num[k]
      }     
    
      # are all sites top ranked?
      these_true_top <- these_summaries$top_rank_model_is_true
      true_top_freq  <- sapply(split(these_true_top, these_summaries$tips), mean)
      true_top_num   <- sapply(split(these_true_top, these_summaries$tips), length)
      true_top_q_l   <- numeric(length(true_top_num))
      true_top_q_u   <- numeric(length(true_top_num))
      for(k in 1:length(true_top_num)) {
        true_top_q_l[k] <- qbinom(0.025, true_top_num[k], true_top_freq[k]) / true_top_num[k]
        true_top_q_u[k] <- qbinom(0.975, true_top_num[k], true_top_freq[k]) / true_top_num[k]
      }       
      
      # is there one model in the set?
      these_one_model <- these_summaries$one_model_in_set
      one_model_freq  <- sapply(split(these_one_model, these_summaries$tips), mean)
      one_model_num   <- sapply(split(these_one_model, these_summaries$tips), length)
      one_model_q_l   <- numeric(length(one_model_num))
      one_model_q_u   <- numeric(length(one_model_num))
      for(k in 1:length(one_model_num)) {
        one_model_q_l[k] <- qbinom(0.025, one_model_num[k], one_model_freq[k]) / one_model_num[k]
        one_model_q_u[k] <- qbinom(0.975, one_model_num[k], one_model_freq[k]) / one_model_num[k]
      }       
      
      # plot
      plot(1:length(tips), pch = NA, xlab = NA, ylab = NA, xaxt = "n", yaxt = "n", ylim = c(0,1), type = "p")
      abline(h = 0.95, lty = 2)
      
      points(which(tips %in% names(neu_freq)),      neu_freq,      col = colors[1], cex = w * neu_num / 200, pch = points[1], xlab = NA, ylab = NA, xaxt = "n", yaxt = "n", ylim = c(0,1), type = "b")
      # segments(x0 = which(tips %in% names(neu_freq)), y0 = neu_q_l, y1 = neu_q_u, col = colors[1])

      points(which(tips %in% names(any_true_freq)), any_true_freq, col = colors[2], cex = w * neu_num / 200, pch = points[2], xlab = NA, ylab = NA, xaxt = "n", yaxt = "n", ylim = c(0,1), type = "b")
      # segments(x0 = which(tips %in% names(any_true_freq)), y0 = any_true_q_l, y1 = any_true_q_u, col = colors[2])
  
      if ( this_n != 1 ) {
        points(which(tips %in% names(all_true_freq)), all_true_freq, col = colors[3], cex = w * neu_num / 200, pch = points[3], xlab = NA, ylab = NA, xaxt = "n", yaxt = "n", ylim = c(0,1), type = "b")
        # segments(x0 = which(tips %in% names(all_true_freq)), y0 = all_true_q_l, y1 = all_true_q_u, col = colors[3])
      }
      
      points(which(tips %in% names(only_true_freq)), only_true_freq, col = colors[4], cex = w * neu_num / 200, pch = points[4], xlab = NA, ylab = NA, xaxt = "n", yaxt = "n", ylim = c(0,1), type = "b")
      # segments(x0 = which(tips %in% names(only_true_freq)), y0 = only_true_q_l, y1 = only_true_q_u, col = colors[4])

      points(which(tips %in% names(true_top_freq)), true_top_freq, col = colors[5], cex = w * neu_num / 200, pch = points[4], xlab = NA, ylab = NA, xaxt = "n", yaxt = "n", ylim = c(0,1), type = "b")
      # segments(x0 = which(tips %in% names(true_top_freq)), y0 = top_rank_q_l, y1 = top_rank_q_u, col = colors[4])
      
      # if ( this_n != 1 ) {
      #   points(which(tips %in% names(top_rank_freq)), top_rank_freq, col = colors[6], cex = w * neu_num / 200, pch = points[4], xlab = NA, ylab = NA, xaxt = "n", yaxt = "n", ylim = c(0,1), type = "b")
      #   # segments(x0 = which(tips %in% names(top_rank_freq)), y0 = top_rank_q_l, y1 = top_rank_q_u, col = colors[4])
      # }

      points(which(tips %in% names(one_model_freq)), one_model_freq, col = colors[6], cex = w * neu_num / 200, pch = points[4], xlab = NA, ylab = NA, xaxt = "n", yaxt = "n", ylim = c(0,1), type = "b")
      # segments(x0 = which(tips %in% names(one_model_freq)), y0 = one_model_q_l, y1 = one_model_q_u, col = colors[4])
        
    }
    
    if (i == 1) {
      mtext(paste0("f = ", this_f), side = 3, line = 0.5)
    }
    
    if (i == length(size)) {
      axis(1, lwd = 0, lwd.tick = 1, at = 1:length(tips), labels = tips, las = 2)
      mtext("c", side = 1, line = 2.75)
    }
    
    if (j == 1) {
      axis(2, lwd = 0, lwd.tick = 1, las = 2)
      mtext("frequency", side = 2, line = 3)
      mtext(paste0("l = ", this_n), side = 2, line = 5)
    }
    
    # if (i == 1 & j == 2) {
    #   legend("right", legend = tips, col = colors, pch = 19, pt.cex = 1, bty = "n", title = "# samples", ncol = 2, title.adj = 0.5)
    # }
    
    if (i == 1 & j == 1) {
      # legend("right", legend = c("neutral in set", "at least one site in set", "all sites in set", "all sites top ranked"), title = "event", col = colors, pch = points, pt.cex = 1, bty = "n", ncol = 1, lwd = width, lty = NA, seg.len = 0)
      # legend("right", legend = c("neutral in set", "at least one site in set", "all sites in set"), title = "event", col = colors, pch = points, pt.cex = 1, bty = "n", ncol = 1, lwd = width, lty = NA, seg.len = 0)
      # legend(x = 1.15, y = 0.65, legend = c("neutral in set", "at least one site in set", "all sites in set", "all sites top ranked", "only sites in set"), title = "event", col = colors, pch = points, pt.cex = 1, bty = "n", ncol = 1, lwd = width, lty = NA, seg.len = 0)
      # legend(x = 1.25, y = 0.5, legend = c("neutral in set", "at least one site in set", "all sites in set", "all sites top ranked"), title = "event", col = colors, pch = points, pt.cex = 1, bty = "n", ncol = 1, lwd = width, lty = NA, seg.len = 0)
      # legend(x = 1, y = 0.6, legend = c("neutral in set", "at least one true site in set", "all true sites in set", "only true sites in set"), title = "event", col = colors, pch = points, pt.cex = 1, bty = "n", ncol = 1, lwd = width, lty = NA, seg.len = 0)
      # legend(x = 0.95, y = 0.63, legend = c("neutral in set", "at least one true site in set", "all true sites in set", "only true sites in set", "true sites top ranked"), title = "event", col = colors, pch = points, pt.cex = 1, bty = "n", ncol = 1, lwd = width, lty = NA, seg.len = 0)
      # legend(x = 0.95, y = 0.67, legend = c("neutral in set", "at least one true site in set", "all true sites in set", "only true sites in set", "top rank is true site", "true sites top ranked"), title = "event", col = colors, pch = points, pt.cex = 1, bty = "n", ncol = 1, lwd = width, lty = NA, seg.len = 0)
      legend(x = 0.95, y = 0.67, legend = c("neutral in set", "at least one true site in set", "all true sites in set", "only true sites in set", "top rank is true site", "one credible model"), title = "event", col = colors, pch = points, pt.cex = 1, bty = "n", ncol = 1, lwd = width, lty = NA, seg.len = 0)
    }
    
  }
  
}
dev.off()


#############################################
# model fit between credible and true model #
#############################################

colors <- gsub("FF", "", plasma(6, begin = 0.1, end = 0.9))

pdf(paste0(figdir, "multisite_credible_vs_true_bf.pdf"), height = 10, width = 12)

layout(layout_mat)
par(mar=c(0,0,0,0), oma = c(4,6.5,2,0) + 0.1, lend = 2)

# loop over rows
for(i in 1:length(size)) {
  
  this_n <- size[i]
  
  # loop over columns
  for(j in 1:length(factors)) {
    
    this_f <- factors[j]
    
    # get the relevant samples
    these_summaries <- summaries[summaries$size == this_n & summaries$factor == this_f,]
    
    # get the posterior of the true model
    these_sizes <- these_summaries$tips
    these_BFs   <- these_summaries$bf_true_vs_combined
    df          <- data.frame(n = these_sizes, p = these_BFs)
    
    max <- 20
    df$p[df$p > max] <- max
    df$p[df$p < -max] <- -max
    
    if ( nrow(df) == 0  ) {
      plot(1, col = "black", cex = w, pch = NA, xlab = NA, ylab = NA, xaxt = "n", yaxt = "n", ylim = c(0,1), type = "b")
    } else {
     
      # the vioplot
      v <- vioplot(formula = p ~ n, 
                   data    = df, 
                   xlim    = c(0.5, 6.5),
                   ylim    = c(-max, max),
                   col     = paste0(colors,"50"),
                   rectCol = NA, lineCol = NA, pchMed = NA, border = NA,
                   names   = size, areaEqual = FALSE,
                   xlab    = NA, ylab = NA, xaxt = "n", yaxt = "n")
      
      abline(h = 0, lty = 2, lend = 2)
      
      # the points
      for(k in 1:length(v$base)) {
        
        # get base and height
        if ( any(tips[k] %in% df$n) == FALSE ) {
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
        y <- df$p[df$n == tips[k]]
        
        # get jitter factor per coordinate
        jitter_factor <- fun(y)
        if ( any(is.infinite(jitter_factor))  ) {
          next
        }
        x <- k + runif(length(y), -jitter_factor, jitter_factor)
        
        c <- colors[k]
        w <- 0.3
        
        points(x, y, col = c, cex = w, pch = 19)
        
      }
      
    }
    
    if (i == 1) {
      mtext(paste0("f = ", this_f), side = 3, line = 0.5)
    }
    
    if (i == length(size)) {
      axis(1, lwd = 0, lwd.tick = 1, at = 1:length(tips), labels = tips, las = 2)
      mtext("c", side = 1, line = 2.75)
    }
    
    if (j == 1) {
      axis(2, lwd = 0, lwd.tick = 1, las = 2)
      mtext("2 ln BF", side = 2, line = 3)
      mtext(paste0("l = ", this_n), side = 2, line = 5)
    }
    
    if (i == 1 & j == 1) {
      legend("topleft", legend = tips, col = colors, pch = 19, pt.cex = 1, bty = "n", title = "c", ncol = 2, title.adj = 0.1)
    }
    
  }
  
}

dev.off()







