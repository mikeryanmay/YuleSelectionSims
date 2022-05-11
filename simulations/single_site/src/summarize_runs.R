# RUN FROM simulations/single_site

library(RColorBrewer)

# enumerate the analyses
sims <- c("factor_1", "factor_2", "factor_3", "factor_4", "scenario_1", "scenario_2", "scenario_3")
size <- c(10, 100, 1000)
reps <- 1:100

# make all combinations
grid <- expand.grid(sim = sims, size = size, rep = reps, stringsAsFactors = FALSE)

# compute all the summaries
summaries <- do.call(rbind, lapply(1:nrow(grid), function(i) {
  
  # get the analysis
  this_grid <- grid[i,]
  this_sim  <- this_grid$sim
  this_size <- this_grid$size
  this_rep  <- this_grid$rep
  
  # check if the output file exists
  this_tsv <- paste0(this_sim, "_size_", this_size, "/output/rep_", this_rep,"/fits.tsv")
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
  
  # reject the constant-rate model
  posterior_constant <- tail(posterior_over_models, 1)
  posterior_selected <- 1 - posterior_constant
  BF_selected        <- 2 * log((posterior_selected / (1 - posterior_selected)) / (prior_selected / (1 - prior_selected)))
  
  # select the correct site, given that we reject the constant model
  posterior_over_selected_models <- posterior_over_models[-length(posterior_over_models)]
  posterior_over_selected_models <- posterior_over_selected_models / sum(posterior_over_selected_models)
  prior_over_selected_models     <- rep(1 / num_models, num_models)

  prior_site     <- prior_over_selected_models[1]
  posterior_site <- posterior_over_selected_models[1]
  BF_site        <- 2 * log((posterior_site / (1 - posterior_site)) / (prior_site / (1 - prior_site)))
  
  # is the true site the maximum posterior probability?
  posterior_site_max <- max(posterior_over_selected_models)
  BF_site_max        <- 2 * log((posterior_site_max / (1 - posterior_site_max)) / (prior_site / (1 - prior_site)))
  
  # return
  res <- data.frame(sim = this_sim, size = this_size, rep = this_rep,
                    BF_selected = BF_selected,
                    BF_site     = BF_site,
                    BF_site_max = BF_site_max)
  
  return(res)
  
}))

##############################
# reject constant-rate model #
##############################

# get the constant-rate simulations
constant_summaries <- summaries[summaries$sim == "factor_1",]

# create the BF cutoffs
BF_range   <- range(pretty(constant_summaries$BF_selected))
BF_cutoffs <- seq(BF_range[1], BF_range[2], length.out=1001)

# compute rejection rates for constant-rate simulations
constant_grid <- expand.grid(sim = sims[sims == "factor_1"], size = size, stringsAsFactors = FALSE)
constant_FPR <- do.call(rbind, lapply(1:nrow(constant_grid), function(i) {
  
  # get the analysis
  this_grid <- constant_grid[i,]
  this_sim  <- this_grid$sim
  this_size <- this_grid$size
  
  # get the corresponding simulations
  these_summaries    <- summaries[summaries$sim == this_sim & summaries$size == this_size,]
  these_selected_BFs <- sort(these_summaries$BF_selected)
  
  # compute the false positive rate per BF cutoff
  this_FPR <- 1.0 - findInterval(BF_cutoffs, these_selected_BFs) / length(these_selected_BFs)
  
  # return
  res <- data.frame(sim = this_sim, size = this_size, BFs = I(list(this_FPR)))
  return(res)
  
}))

# compute rejection rates for variable-rate simulations
variable_grid <- expand.grid(sim = sims[sims != "factor_1"], size = size, stringsAsFactors = FALSE)
variable_TPR <- do.call(rbind, lapply(1:nrow(variable_grid), function(i) {
  
  # get the analysis
  this_grid <- variable_grid[i,]
  this_sim  <- this_grid$sim
  this_size <- this_grid$size
  
  # get the corresponding simulations
  these_summaries    <- summaries[summaries$sim == this_sim & summaries$size == this_size,]
  these_selected_BFs <- sort(these_summaries$BF_selected)
  
  # compute the false positive rate per BF cutoff
  this_FPR <- 1.0 - findInterval(BF_cutoffs, these_selected_BFs) / length(these_selected_BFs)
  
  # return
  res <- data.frame(sim = this_sim, size = this_size, BFs = I(list(this_FPR)))
  return(res)
  
}))

# plot ROC curves for the factor analyses
variable_factors <- sims[sims != "factor_1" & grepl("factor", sims)]

cols <- brewer.pal(3, "Set1")

pdf("figures/factor_reject_constant.pdf", width = 12, height = 5)
par(oma = c(4.5,4.5,3,0) + 0.1, mar = c(0,0,0,0), mfrow = c(1,3))
for(i in 1:length(variable_factors)) {
  
  # get the factor
  this_factor <- variable_factors[i]
  f <- as.numeric(strsplit(this_factor, "_")[[1]][2])
  these_results <- variable_TPR[variable_TPR$sim == this_factor,]
  
  # empty plot
  plot(NA, xlim = c(0,1), ylim = c(0,1), xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
  if (i == 1) {
    axis(2, lwd = 0, lwd.tick = 1, las = 1)
    mtext("true positive rate", line = 3, side = 2)
  }
  axis(1, lwd = 0, lwd.tick = 1, las = 1)
  mtext("false positive rate", line = 3, side = 1)
  mtext(paste0("lambda1 = ", f, " x lambda0 "), line = 1, cex = 1.2)
  
  # loop over sizes
  for(j in 1:length(size)) {
    
    # get the size
    this_size <- size[j]
    
    # get the false positive rate
    this_FPR <- constant_FPR$BFs[constant_FPR$size == this_size][[1]]
    this_TPR <- these_results$BFs[these_results$size == this_size][[1]]
    
    # add the zero
    this_FPR <- c(this_FPR, 0.0)
    this_TPR <- c(this_TPR, 0.0)
    
    # plot the points
    points(x = this_FPR, y = this_TPR, type = "l", col = cols[j])
    
  }
  
  # add a legend
  legend("bottomright", legend = size, col = cols, title = "# sites", bty = "n", lty = 1)
  
}
dev.off()

# plot ROC curves for the scenario analyses
variable_scenarios <- sims[grepl("scenario", sims)]

pdf("figures/scenario_reject_constant.pdf", width = 12, height = 5)
par(oma = c(4.5,4.5,3,0) + 0.1, mar = c(0,0,0,0), mfrow = c(1,3))
for(i in 1:length(variable_scenarios)) {
  
  # get the scenario
  this_scenario <- variable_scenarios[i]
  these_results <- variable_TPR[variable_TPR$sim == this_scenario,]
  
  # empty plot
  plot(NA, xlim = c(0,1), ylim = c(0,1), xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
  if (i == 1) {
    axis(2, lwd = 0, lwd.tick = 1, las = 1)
    mtext("true positive rate", line = 3, side = 2)
  }
  axis(1, lwd = 0, lwd.tick = 1, las = 1)
  mtext("false positive rate", line = 3, side = 1)
  mtext(this_scenario, line = 1, cex = 1.2)
  
  # loop over sizes
  for(j in 1:length(size)) {
    
    # get the size
    this_size <- size[j]
    
    # get the false positive rate
    this_FPR <- constant_FPR$BFs[constant_FPR$size == this_size][[1]]
    this_TPR <- these_results$BFs[these_results$size == this_size][[1]]
    
    # add the zero
    this_FPR <- c(this_FPR, 0.0)
    this_TPR <- c(this_TPR, 0.0)
    
    # plot the points
    points(x = this_FPR, y = this_TPR, type = "l", col = cols[j])
    
  }
  
  # add a legend
  legend("bottomright", legend = size, col = cols, title = "# sites", bty = "n", lty = 1)
  
}
dev.off()


#################
# identify site #
#################

# get the constant-rate simulations
constant_summaries <- summaries[summaries$sim == "factor_1",]

# create the BF cutoffs
BF_range   <- range(pretty(constant_summaries$BF_site_max))
BF_cutoffs <- seq(BF_range[1], BF_range[2], length.out=1001)

# compute the rate at which we falsely choose a selected site with a given BF
constant_site_grid <- expand.grid(sim = sims[sims == "factor_1"], size = size, stringsAsFactors = FALSE)
constant_site_FPR  <- do.call(rbind, lapply(1:nrow(constant_site_grid), function(i) {
  
  # get the analysis
  this_grid <- constant_site_grid[i,]
  this_sim  <- this_grid$sim
  this_size <- this_grid$size
  
  # get the corresponding simulations
  these_summaries    <- summaries[summaries$sim == this_sim & summaries$size == this_size,]
  these_selected_BFs <- sort(these_summaries$BF_site_max)
  
  # compute the false positive rate per BF cutoff
  this_FPR <- 1.0 - findInterval(BF_cutoffs, these_selected_BFs) / length(these_selected_BFs)
  
  # return
  res <- data.frame(sim = this_sim, size = this_size, BFs = I(list(this_FPR)))
  return(res)
  
}))

# compute the rate at which we correctly choose the selected site with a given BF
variable_site_grid <- expand.grid(sim = sims[sims != "factor_1"], size = size, stringsAsFactors = FALSE)
variable_site_TPR <- do.call(rbind, lapply(1:nrow(variable_site_grid), function(i) {
  
  # get the analysis
  this_grid <- variable_site_grid[i,]
  this_sim  <- this_grid$sim
  this_size <- this_grid$size
  
  # get the corresponding simulations
  these_summaries    <- summaries[summaries$sim == this_sim & summaries$size == this_size,]
  these_selected_BFs <- sort(these_summaries$BF_site)
  
  # compute the false positive rate per BF cutoff
  this_FPR <- 1.0 - findInterval(BF_cutoffs, these_selected_BFs) / length(these_selected_BFs)
  
  # return
  res <- data.frame(sim = this_sim, size = this_size, BFs = I(list(this_FPR)))
  return(res)
  
}))

variable_site_cond_TPR <- do.call(rbind, lapply(1:nrow(variable_site_grid), function(i) {
  
  # get the analysis
  this_grid <- variable_site_grid[i,]
  this_sim  <- this_grid$sim
  this_size <- this_grid$size
  
  # get the corresponding simulations
  these_summaries    <- summaries[summaries$sim == this_sim & summaries$size == this_size,]
  these_selected_BFs <- these_summaries$BF_site
  these_selected_BFs[these_selected_BFs < these_summaries$BF_site_max] <- -Inf
  these_selected_BFs <- sort(these_selected_BFs)
  
  # compute the false positive rate per BF cutoff
  this_FPR <- 1.0 - findInterval(BF_cutoffs, these_selected_BFs) / length(these_selected_BFs)
  
  # return
  res <- data.frame(sim = this_sim, size = this_size, BFs = I(list(this_FPR)))
  return(res)
  
}))

# plot ROC curves for the factor analyses
variable_factors <- sims[sims != "factor_1" & grepl("factor", sims)]

cols <- brewer.pal(3, "Set1")

pdf("figures/factor_select_site.pdf", width = 12, height = 5)
par(oma = c(4.5,4.5,3,0) + 0.1, mar = c(0,0,0,0), mfrow = c(1,3))
for(i in 1:length(variable_factors)) {
  
  # get the factor
  this_factor <- variable_factors[i]
  f <- as.numeric(strsplit(this_factor, "_")[[1]][2])
  these_results <- variable_site_TPR[variable_site_TPR$sim == this_factor,]
  
  # empty plot
  plot(NA, xlim = c(0,1), ylim = c(0,1), xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
  if (i == 1) {
    axis(2, lwd = 0, lwd.tick = 1, las = 1)
    mtext("true positive rate", line = 3, side = 2)
  }
  axis(1, lwd = 0, lwd.tick = 1, las = 1)
  mtext("false positive rate", line = 3, side = 1)
  mtext(paste0("lambda1 = ", f, " x lambda0 "), line = 1, cex = 1.2)
  
  # loop over sizes
  for(j in 1:length(size)) {
    
    # get the size
    this_size <- size[j]
    
    # get the false positive rate
    this_FPR <- constant_site_FPR$BFs[constant_FPR$size == this_size][[1]]
    this_TPR <- these_results$BFs[these_results$size == this_size][[1]]
    
    # add the zero
    this_FPR <- c(this_FPR, 0.0)
    this_TPR <- c(this_TPR, 0.0)
    
    # plot the points
    points(x = this_FPR, y = this_TPR, type = "l", col = cols[j])
    
  }
  
  # add a legend
  legend("bottomright", legend = size, col = cols, title = "# sites", bty = "n", lty = 1)
  
}
dev.off()

# plot ROC curves for the scenario analyses
variable_scenarios <- sims[grepl("scenario", sims)]

pdf("figures/scenario_select_site.pdf", width = 12, height = 5)
par(oma = c(4.5,4.5,3,0) + 0.1, mar = c(0,0,0,0), mfrow = c(1,3))
for(i in 1:length(variable_scenarios)) {
  
  # get the scenario
  this_scenario <- variable_scenarios[i]
  these_results <- variable_site_TPR[variable_site_TPR$sim == this_scenario,]
  
  # empty plot
  plot(NA, xlim = c(0,1), ylim = c(0,1), xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
  if (i == 1) {
    axis(2, lwd = 0, lwd.tick = 1, las = 1)
    mtext("true positive rate", line = 3, side = 2)
  }
  axis(1, lwd = 0, lwd.tick = 1, las = 1)
  mtext("false positive rate", line = 3, side = 1)
  mtext(this_scenario, line = 1, cex = 1.2)
  
  # loop over sizes
  for(j in 1:length(size)) {
    
    # get the size
    this_size <- size[j]
    
    # get the false positive rate
    this_FPR <- constant_site_FPR$BFs[constant_FPR$size == this_size][[1]]
    this_TPR <- these_results$BFs[these_results$size == this_size][[1]]
    
    # add the zero
    this_FPR <- c(this_FPR, 0.0)
    this_TPR <- c(this_TPR, 0.0)
    
    # plot the points
    points(x = this_FPR, y = this_TPR, type = "l", col = cols[j])
    
  }
  
  # add a legend
  legend("bottomright", legend = size, col = cols, title = "# sites", bty = "n", lty = 1)
  
}
dev.off()




pdf("figures/factor_select_site_cond.pdf", width = 12, height = 5)
par(oma = c(4.5,4.5,3,0) + 0.1, mar = c(0,0,0,0), mfrow = c(1,3))
for(i in 1:length(variable_factors)) {
  
  # get the factor
  this_factor <- variable_factors[i]
  f <- as.numeric(strsplit(this_factor, "_")[[1]][2])
  these_results <- variable_site_cond_TPR[variable_site_cond_TPR$sim == this_factor,]
  
  # empty plot
  plot(NA, xlim = c(0,1), ylim = c(0,1), xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
  if (i == 1) {
    axis(2, lwd = 0, lwd.tick = 1, las = 1)
    mtext("true positive rate", line = 3, side = 2)
  }
  axis(1, lwd = 0, lwd.tick = 1, las = 1)
  mtext("false positive rate", line = 3, side = 1)
  mtext(paste0("lambda1 = ", f, " x lambda0 "), line = 1, cex = 1.2)
  
  # loop over sizes
  for(j in 1:length(size)) {
    
    # get the size
    this_size <- size[j]
    
    # get the false positive rate
    this_FPR <- constant_site_FPR$BFs[constant_FPR$size == this_size][[1]]
    this_TPR <- these_results$BFs[these_results$size == this_size][[1]]
    
    # add the zero
    this_FPR <- c(this_FPR, 0.0)
    this_TPR <- c(this_TPR, 0.0)
    
    # plot the points
    points(x = this_FPR, y = this_TPR, type = "l", col = cols[j])
    
  }
  
  # add a legend
  legend("bottomright", legend = size, col = cols, title = "# sites", bty = "n", lty = 1)
  
}
dev.off()



pdf("figures/scenario_select_site_cond.pdf", width = 12, height = 5)
par(oma = c(4.5,4.5,3,0) + 0.1, mar = c(0,0,0,0), mfrow = c(1,3))
for(i in 1:length(variable_scenarios)) {
  
  # get the scenario
  this_scenario <- variable_scenarios[i]
  these_results <- variable_site_cond_TPR[variable_site_cond_TPR$sim == this_scenario,]
  
  # empty plot
  plot(NA, xlim = c(0,1), ylim = c(0,1), xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
  if (i == 1) {
    axis(2, lwd = 0, lwd.tick = 1, las = 1)
    mtext("true positive rate", line = 3, side = 2)
  }
  axis(1, lwd = 0, lwd.tick = 1, las = 1)
  mtext("false positive rate", line = 3, side = 1)
  mtext(this_scenario, line = 1, cex = 1.2)
  
  # loop over sizes
  for(j in 1:length(size)) {
    
    # get the size
    this_size <- size[j]
    
    # get the false positive rate
    this_FPR <- constant_site_FPR$BFs[constant_FPR$size == this_size][[1]]
    this_TPR <- these_results$BFs[these_results$size == this_size][[1]]
    
    # add the zero
    this_FPR <- c(this_FPR, 0.0)
    this_TPR <- c(this_TPR, 0.0)
    
    # plot the points
    points(x = this_FPR, y = this_TPR, type = "l", col = cols[j])
    
  }
  
  # add a legend
  legend("bottomright", legend = size, col = cols, title = "# sites", bty = "n", lty = 1)
    
}
dev.off()







##########################################################
# an alternative FPR calculation for site identification #
##########################################################

variable_site_grid <- expand.grid(sim = sims[sims != "factor_1"], size = size, stringsAsFactors = FALSE)
variable_site_FPR_alt <- do.call(rbind, lapply(1:nrow(variable_site_grid), function(i) {
  
  # get the analysis
  this_grid <- variable_site_grid[i,]
  this_sim  <- this_grid$sim
  this_size <- this_grid$size
  
  # get the corresponding simulations
  these_summaries    <- summaries[summaries$sim == this_sim & summaries$size == this_size,]
  
  # compute the BF for the true site
  these_selected_BFs <- these_summaries$BF_site
  these_selected_BFs[these_selected_BFs < these_summaries$BF_site_max] <- 0
  these_selected_BFs <- sort(these_selected_BFs)

  # compute the true positive rate per BF cutoff
  this_TPR <- 1.0 - findInterval(BF_cutoffs, these_selected_BFs) / length(these_selected_BFs)
  
  # compute the false positive rate per BF cutoff
  these_selected_BFs <- these_summaries$BF_site_max
  these_selected_BFs[these_selected_BFs == these_summaries$BF_site] <- 0
  these_selected_BFs <- sort(these_selected_BFs)
  this_FPR <- 1.0 - findInterval(BF_cutoffs, these_selected_BFs) / length(these_selected_BFs)
  
  # return
  res <- data.frame(sim = this_sim, size = this_size, BFs = I(list(this_TPR)),
                    FPR = I(list(this_FPR)))
  return(res)
  
}))


pdf("figures/factor_select_site_alt.pdf", width = 12, height = 5)
par(oma = c(4.5,4.5,3,0) + 0.1, mar = c(0,0,0,0), mfrow = c(1,3))
for(i in 1:length(variable_factors)) {
  
  # get the factor
  this_factor <- variable_factors[i]
  f <- as.numeric(strsplit(this_factor, "_")[[1]][2])
  these_results <- variable_site_FPR_alt[variable_site_FPR_alt$sim == this_factor,]
  
  # empty plot
  plot(NA, xlim = c(0,1), ylim = c(0,1), xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
  if (i == 1) {
    axis(2, lwd = 0, lwd.tick = 1, las = 1)
    mtext("true positive rate", line = 3, side = 2)
  }
  axis(1, lwd = 0, lwd.tick = 1, las = 1)
  mtext("false positive rate", line = 3, side = 1)
  mtext(paste0("lambda1 = ", f, " x lambda0 "), line = 1, cex = 1.2)
  
  # loop over sizes
  for(j in 1:length(size)) {
    
    # get the size
    this_size <- size[j]
    
    # get the false positive rate
    this_FPR <- these_results$FPR[these_results$size == this_size][[1]]
    this_TPR <- these_results$BFs[these_results$size == this_size][[1]]
    
    # add the zero
    this_FPR <- c(this_FPR, 0.0)
    this_TPR <- c(this_TPR, 0.0)
    
    # plot the points
    points(x = this_FPR, y = this_TPR, type = "l", col = cols[j])
    
  }
  
  # add a legend
  legend("bottomright", legend = size, col = cols, title = "# sites", bty = "n", lty = 1)
  
  
  abline(a = 1, b = -1, lty = 2)
  
}
dev.off()










