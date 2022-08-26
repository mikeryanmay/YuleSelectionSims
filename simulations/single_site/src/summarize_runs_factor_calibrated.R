# RUN FROM simulations/single_site
# setwd("simulations/single_site/")

library(matrixStats)
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
  this_tsv <- paste0("factor/tips_", this_tips, "_size_", this_size, "_factor_", this_factor, "/rep_", this_rep, "/fits.tsv")
  if ( file.exists(this_tsv) == FALSE ) {
    return(NULL)
  }
  
  # read output file
  results <- read.table(this_tsv, header = TRUE, sep = "\t", stringsAsFactors = FALSE)
  
  # normalize the likelihoods for numerical purposes
  results$lik <- results$lik - max(results$lik)
  
  # number of models
  num_models <- nrow(results) - 1
  
  # compute priors and posteriors
  prior_constant        <- 0.5
  prior_selected        <- 1 - prior_constant
  prior_site_selected   <- prior_selected / num_models
  prior_over_models     <- c(rep(prior_site_selected, num_models), prior_constant)
  posterior_over_models <- exp(results$lik) * prior_over_models
  posterior_over_models <- posterior_over_models / sum(posterior_over_models)
  
  # BF per site
  BF_per_site <- 2 * log((posterior_over_models / (1 - posterior_over_models)) / (prior_over_models / (1 - prior_over_models)))
  
  # return
  res <- data.frame(tips        = this_tips,
                    size        = this_size, 
                    factor      = this_factor, 
                    rep         = this_rep,
                    BF_per_site = I(list(BF_per_site)))
  
  return(res)
  
}))

##################################
# reject the constant-rate model #
##################################

# first, calibrate per l and m
calibrate_grid <- expand.grid(tips = tips, size = size)

BF_crits <- do.call(rbind, lapply(1:nrow(calibrate_grid), function(i) {
  
  # get the analysis
  this_grid   <- calibrate_grid[i,]
  this_tips   <- this_grid$tips
  this_size   <- this_grid$size
  
  # get the simulations
  these_sims <- summaries[summaries$tips == this_tips & summaries$size == this_size & summaries$factor == 1,]
  
  # get the constant-rate BFs
  these_BFs <- do.call(rbind, these_sims$BF_per_site)
  these_BFs_against_neutral <- -these_BFs[,ncol(these_BFs)]
  these_BFs_against_neutral <- sort(these_BFs_against_neutral)
  
  # compute the false positive rate per BF cutoff
  FPR_per_cutoff <- 1.0 - findInterval(these_BFs_against_neutral, these_BFs_against_neutral) / length(these_BFs_against_neutral)
  
  # compute the BF cutoff
  BF_crit <- these_BFs_against_neutral[max(which(FPR_per_cutoff > 0.05))]
  
  # return
  res <- data.frame(tips        = this_tips,
                    size        = this_size,
                    BF_crit     = BF_crit)
  return(res)
  
}))

# compute the TPR
TPR_grid <- expand.grid(tips = tips, size = size, factor = factors[factors > 1])

TPR_results <- do.call(rbind, lapply(1:nrow(TPR_grid), function(i) {
  
  # get the analysis
  this_grid   <- TPR_grid[i,]
  this_tips   <- this_grid$tips
  this_size   <- this_grid$size
  this_factor <- this_grid$factor
  
  # get the BF cutoff
  BF_crit <- BF_crits[BF_crits$tips == this_tips & BF_crits$size == this_size,]$BF_crit
  
  # get the simulations
  these_sims <- summaries[summaries$tips == this_tips & summaries$size == this_size & summaries$factor == this_factor,]
  
  # get the constant-rate BFs
  these_BFs <- do.call(rbind, these_sims$BF_per_site)
  these_BFs_against_neutral <- -these_BFs[,ncol(these_BFs)]
  these_BFs_against_neutral <- sort(these_BFs_against_neutral)
  
  # compute the TPR
  TPR <- mean(these_BFs_against_neutral > BF_crit)
  
  # return
  res <- data.frame(tips        = this_tips,
                    size        = this_size,
                    factor      = this_factor,
                    TPR         = TPR)
  return(res)
  
}))

# plot one panel per size
colors <- brewer.pal(5, "Set1")
names(colors) <- factors[factors > 1]

layout_mat <- matrix(1:length(size), nrow = 1)

pdf("figures/power_calibrated_reject_neutral.pdf", width = 12, height = 4)
layout(layout_mat)
par(mar = c(0,0,0,0), oma = c(5, 5, 3, 0) + 0.1)

for(i in 1:length(size)) {
  
  # get this size
  this_size <- size[i]
  
  # get these TRPs
  these_results <- TPR_results[TPR_results$size == this_size,]
  
  # split by factor
  this_mat <- do.call(cbind, lapply(split(these_results, list(these_results$factor)), function(x) x[,4]))
  
  # plot
  matplot(this_mat, type = "l", lty = 1, ylim = c(0,1), xaxt="n", yaxt="n", col = colors[colnames(this_mat)])
  axis(1, lwd = 0, lwd.tick = 1, labels = tips, at = 1:length(tips), las = 2)
  mtext("number of tips", side = 1, line = 3.5)
  mtext(paste0("number of sites = ", this_size), side = 3, line = 1)
  if (i == 1) {
    axis(2, lwd = 0, lwd.tick = 1, las = 2)
    mtext("power", side = 2, line = 3)
    legend("bottomright", legend = factors[factors > 1], lty = 1, col = colors, bty = "n", title = "f", cex = 1.2)
  }
  
}
dev.off()

#################
# identify site #
#################

# first, calibrate per l, m, and f
calibrate_grid <- expand.grid(tips = tips, size = size[size > 1], factor = factors[factors > 1])

BF_crits <- do.call(rbind, lapply(1:nrow(calibrate_grid), function(i) {
  
  # get the analysis
  this_grid   <- calibrate_grid[i,]
  this_tips   <- this_grid$tips
  this_size   <- this_grid$size
  this_factor <- this_grid$factor
  
  # get the simulations
  these_sims <- summaries[summaries$tips == this_tips & summaries$size == this_size & summaries$factor == this_factor,]
  these_sims <- these_sims[these_sims$rep %in% 1:100,]
  
  # get the per-site BFs
  these_BFs <- do.call(rbind, these_sims$BF_per_site)
  
  # get the neutral BF
  these_BFs_neutral <- these_BFs[,ncol(these_BFs)]
  
  # get the BFs for the wrong model
  these_BFs_wrong <- rowMaxs(these_BFs[,-c(1, ncol(these_BFs))])
  
  # only a positive if we are better than the neutral model
  these_BFs_wrong[these_BFs_wrong < these_BFs_neutral] <- -Inf
  these_BFs_wrong <- sort(these_BFs_wrong)
  
  # compute the false positive rate per BF cutoff
  FPR_per_cutoff <- 1.0 - findInterval(these_BFs_wrong, these_BFs_wrong) / length(these_BFs_wrong)
  
  # compute the BF cutoff
  BF_crit <- these_BFs_wrong[max(which(FPR_per_cutoff > 0.05))]
  
  # return
  res <- data.frame(tips        = this_tips,
                    size        = this_size,
                    factor      = this_factor,
                    BF_crit     = BF_crit)
  return(res)
  
}))


# compute the TPR
TPR_grid <- expand.grid(tips = tips, size = size[size > 1], factor = factors[factors > 1])

TPR_results <- do.call(rbind, lapply(1:nrow(TPR_grid), function(i) {
  
  # get the analysis
  this_grid   <- TPR_grid[i,]
  this_tips   <- this_grid$tips
  this_size   <- this_grid$size
  this_factor <- this_grid$factor

  # get the BF cutoff
  BF_crit <- BF_crits[BF_crits$tips == this_tips & BF_crits$size == this_size & BF_crits$factor == this_factor,]$BF_crit
  
  # get the simulations
  these_sims <- summaries[summaries$tips == this_tips & summaries$size == this_size & summaries$factor == this_factor,]
  these_sims <- these_sims[these_sims$rep %in% 1:100 == FALSE,]
  
  # get the per-site BFs
  these_BFs <- do.call(rbind, these_sims$BF_per_site)
  
  # get the neutral BF
  these_BFs_neutral <- these_BFs[,ncol(these_BFs)]
  
  # get the BFs for the true model
  these_BFs_true <- these_BFs[,1]
  
  # get the BFs for the wrong model
  these_BFs_wrong <- these_BFs[,-c(1, ncol(these_BFs))]
  
  # drop one model at random (not for the true site)
  these_BFs_wrong <- these_BFs_wrong[,-4]
  
  # only positive if the true model is at better than neutral model
  these_BFs_true[these_BFs_true < these_BFs_neutral] <- -Inf
  
  # also needs to be better than other models
  these_BFs_true[these_BFs_true < rowMaxs(these_BFs_wrong)] <- -Inf
  num_equal <- numeric(length(these_BFs_true))
  for(i in 1:length(these_BFs_true)) {
    num_equal[i] <- sum(these_BFs_true[i] == these_BFs_wrong[i,])
  }

  # compute the TPR
  TPR <- mean((these_BFs_true > BF_crit) * (1 / (1 + num_equal)))
  
  # return
  res <- data.frame(tips        = this_tips,
                    size        = this_size,
                    factor      = this_factor,
                    TPR         = TPR)
  return(res)
  
}))

# plot one panel per factor
colors <- brewer.pal(3, "Set1")
names(colors) <- size[size > 1]

layout_mat <- matrix(1:length(factors[-1]), nrow = 1)

pdf("figures/power_calibrated_identify_site.pdf", width = 12, height = 4)
layout(layout_mat)
par(mar = c(0,0,0,0), oma = c(5, 5, 3, 0) + 0.1)

for(i in 1:length(factors[-1])) {
  
  # get this size
  this_factor <- factors[i+1]
  
  # get these TRPs
  these_results <- TPR_results[TPR_results$factor == this_factor,]
  
  # split by factor
  this_mat <- do.call(cbind, lapply(split(these_results, list(these_results$size)), function(x) x[,4]))
  
  # plot
  matplot(this_mat, type = "l", lty = 1, ylim = c(0,1), xaxt="n", yaxt="n", col = colors[colnames(this_mat)])
  axis(1, lwd = 0, lwd.tick = 1, labels = tips, at = 1:length(tips), las = 2)
  mtext("number of tips", side = 1, line = 3.5)
  mtext(paste0("factor = ", this_factor), side = 3, line = 1)
  if (i == 1) {
    axis(2, lwd = 0, lwd.tick = 1, las = 2)
    mtext("power", side = 2, line = 3)
    legend("topleft", legend = size[size > 1], lty = 1, col = colors, bty = "n", title = "n", cex = 1.2)
  }
  
}
dev.off()

###############################
# identify site by highest BF #
###############################

MAP_rate <- do.call(rbind, lapply(1:nrow(TPR_grid), function(i) {
  
  # get the analysis
  this_grid   <- TPR_grid[i,]
  this_tips   <- this_grid$tips
  this_size   <- this_grid$size
  this_factor <- this_grid$factor
  
  # get the simulations
  these_sims <- summaries[summaries$tips == this_tips & summaries$size == this_size & summaries$factor == this_factor,]
  
  # get the per-site BFs
  these_BFs <- do.call(rbind, these_sims$BF_per_site)
  
  # get the BF of the true model
  true_model_BFs <- these_BFs[,1]
  
  # get the maximal BF
  TPR <- mean(true_model_BFs == rowMaxs(these_BFs))
  
  # return
  res <- data.frame(tips        = this_tips,
                    size        = this_size,
                    factor      = this_factor,
                    TPR         = TPR)
  return(res)
  
}))

# plot one panel per factor
colors <- brewer.pal(3, "Set1")
names(colors) <- size[size > 1]

layout_mat <- matrix(1:length(factors[-1]), nrow = 1)

pdf("figures/power_uncalibrated_identify_site.pdf", width = 12, height = 4)
layout(layout_mat)
par(mar = c(0,0,0,0), oma = c(5, 5, 3, 0) + 0.1)

for(i in 1:length(factors[-1])) {
  
  # get this size
  this_factor <- factors[i+1]
  
  # get these TRPs
  these_results <- MAP_rate[MAP_rate$factor == this_factor,]
  
  # split by factor
  this_mat <- do.call(cbind, lapply(split(these_results, list(these_results$size)), function(x) x[,4]))
  
  # plot
  matplot(this_mat, type = "l", lty = 1, ylim = c(0,1), xaxt="n", yaxt="n", col = colors[colnames(this_mat)])
  axis(1, lwd = 0, lwd.tick = 1, labels = tips, at = 1:length(tips), las = 2)
  mtext("number of tips", side = 1, line = 3.5)
  mtext(paste0("factor = ", this_factor), side = 3, line = 1)
  if (i == 1) {
    axis(2, lwd = 0, lwd.tick = 1, las = 2)
    mtext("power", side = 2, line = 3)
    legend("topleft", legend = size[size > 1], lty = 1, col = colors, bty = "n", title = "n", cex = 1.2)
  }
  
}
dev.off()



