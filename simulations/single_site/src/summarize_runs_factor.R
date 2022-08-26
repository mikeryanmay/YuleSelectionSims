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
  this_tsv <- paste0("factor/tips_", this_tips, "_size_", this_size, "_factor_", this_factor, "/rep_", this_rep, "/fits.tsv")
  if ( file.exists(this_tsv) == FALSE ) {
    return(NULL)
  }
  
  # read the data file
  # seq_fn <- paste0("factor/tips_", this_tips, "_size_", this_size, "_factor_", this_factor, "/rep_", this_rep, "/seq.nex")
  # seq    <- ReadCharacters(seq_fn)
  # frac   <- mean(seq[,1] == "a")
  frac <- 1
  
  # read output file
  results <- read.table(this_tsv, header = TRUE, sep = "\t", stringsAsFactors = FALSE)
  results <- results[-nrow(results),]
  
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
  
  # reject the constant-rate model against the true model
  posterior_constant <- exp(tail(results$lik, 1)) * prior_constant
  posterior_selected <- exp(results$lik[1]) * prior_selected
  sum                <- posterior_constant + posterior_selected
  posterior_constant <- posterior_constant / sum
  posterior_selected <- posterior_selected / sum
  BF_selected_site   <- 2 * log((posterior_selected / (1 - posterior_selected)) / (prior_selected / (1 - prior_selected)))
  
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
  res <- data.frame(tips        = this_tips,
                    size        = this_size, 
                    factor      = this_factor, 
                    rep         = this_rep,
                    frac_sel    = frac,
                    BF_selected = BF_selected,
                    BF_selected_site = BF_selected_site,
                    BF_site     = BF_site,
                    BF_site_max = BF_site_max)
  
  return(res)
  
}))

##############################
# reject constant-rate model #
##############################

# get the constant-rate simulations
constant_summaries <- summaries[summaries$factor == 1 & summaries$rep > 100,]

# create the BF cutoffs
BF_range   <- range(pretty(constant_summaries$BF_selected))
BF_cutoffs <- sort(c(constant_summaries$BF_selected, BF_range))

# compute rejection rates for constant-rate simulations
constant_grid <- expand.grid(tips = tips, size = size, factor = 1, stringsAsFactors = FALSE)
constant_FPR  <- do.call(rbind, lapply(1:nrow(constant_grid), function(i) {

  # get the analysis
  this_grid   <- constant_grid[i,]
  this_tips   <- this_grid$tips
  this_size   <- this_grid$size
  this_factor <- this_grid$factor
  
  # get the corresponding simulations
  these_summaries    <- summaries[summaries$tips == this_tips & summaries$size == this_size & summaries$factor == this_factor & summaries$rep > 100,]
  # these_summaries    <- summaries[summaries$tips == this_tips & summaries$size == this_size & summaries$factor == this_factor,]
  these_selected_BFs <- sort(these_summaries$BF_selected)
  
  # compute the false positive rate per BF cutoff
  this_FPR <- 1.0 - findInterval(BF_cutoffs, these_selected_BFs) / length(these_selected_BFs)
  
  # return
  res <- data.frame(tips   = this_tips, 
                    size   = this_size, 
                    factor = this_factor,
                    BFs    = I(list(this_FPR)))
  return(res)
  
}))

variable_grid <- expand.grid(tips = tips, size = size, factor = factors, stringsAsFactors = FALSE)
variable_FPR  <- do.call(rbind, lapply(1:nrow(variable_grid), function(i) {
  
  # get the analysis
  this_grid   <- variable_grid[i,]
  this_tips   <- this_grid$tips
  this_size   <- this_grid$size
  this_factor <- this_grid$factor
  
  # get the corresponding simulations
  these_summaries    <- summaries[summaries$tips == this_tips & summaries$size == this_size & summaries$factor == this_factor & summaries$rep <= 100,]
  # these_summaries    <- summaries[summaries$tips == this_tips & summaries$size == this_size & summaries$factor == this_factor,]
  these_selected_BFs <- sort(these_summaries$BF_selected)
  
  # compute the false positive rate per BF cutoff
  this_FPR <- 1.0 - findInterval(BF_cutoffs, these_selected_BFs) / length(these_selected_BFs)
  
  # return
  res <- data.frame(tips   = this_tips, 
                    size   = this_size, 
                    factor = this_factor,
                    n      = length(these_selected_BFs),
                    BFs    = I(list(this_FPR)))
  return(res)
  
}))

# matrix plot: y-axis is number of tips, x-axis is factor
cols <- brewer.pal(4, "Set1")

pdf("figures/factor_reject_constant.pdf", height = 10, width = 15)
layout_mat <- matrix(1:(length(tips) * length(factors)), nrow = length(tips), ncol = length(factors), byrow = TRUE)
layout(layout_mat)
par(mar=c(0,0,0,0), oma = c(4,7,2,0)+0.1)

for(i in 1:length(tips)) {
  
  # get the number of tips
  this_ntips <- tips[i]
  
  for(j in 1:length(factors)) {
    
    # get the factor
    this_factor <- factors[j]
    
    # get correspond results
    these_results          <- variable_FPR[variable_FPR$tips == this_ntips & variable_FPR$factor == this_factor,]
    these_constant_results <- constant_FPR[constant_FPR$tips == this_ntips,]
    
    plot(NA, xlim = c(0,1), ylim = c(0,1), xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
    if (j == 1) {
      mtext("true positive rate", line = 3, side = 2)
      axis(2, lwd = 0, lwd.tick = 1, las = 1)
      mtext(paste0("N = ", this_ntips), line = 5, side = 2)
    }
    if (i == length(tips)) {
      axis(1, lwd = 0, lwd.tick = 1, las = 1)
      mtext("false positive rate", line = 3, side = 1)
    }
    abline(a = 0, b = 1, lty = 2)
    if (i == 1) {
      mtext(paste0("lambda1 = ", this_factor, " x lambda0 "), line = 0.5)
    }
    if (i == 1 & j == 1) {
      legend("topleft", legend = size, col = cols, title = "# sites", bty = "n", lty = 1)
    }
    
    # iterate over alignment sizes
    ns  <- numeric(length(size))
    pw  <- numeric(length(size))
    auc <- numeric(length(size))
    for(k in 1:length(size)) {
      
      # this size
      this_size = size[k]
      
      # get the false positive rate
      this_FPR <- these_constant_results$BFs[these_constant_results$size == this_size][[1]]
      this_TPR <- these_results$BFs[these_results$size == this_size][[1]]
      
      # add the zero
      this_FPR <- c(this_FPR, 0.0)
      this_TPR <- c(this_TPR, 0.0)
      
      # plot the points
      points(x = this_FPR, y = this_TPR, type = "s", col = cols[k])

      # store number of sims
      ns[k]  <- these_results$n[these_results$size == this_size]
      
      if ( ns[k] > 0 ) {

        # flip
        this_FPR <- rev(this_FPR)
        this_TPR <- rev(this_TPR)
        
        # compute area under curve
        fx <- function(x) {
          this_TPR[findInterval(x, this_FPR, all.inside = TRUE) + 1]
        }
        this_auc <- integrate(fx, lower = 0, upper = 1, stop.on.error = FALSE)$value
        
        # compute the power at a 5% FPR
        this_five_percent_power <- fx(0.05)
        
        # store the power/AUC
        pw[k]  <- this_five_percent_power
        auc[k] <- this_auc
        
      }
      
    }
    
    # legend("bottomright", legend = ns, title = "# sims", bty = "n", text.col = cols, title.col = "black")
    # legend("bottom", legend = sprintf("%.3f", pw), title = "power", bty = "n", text.col = cols, title.col = "black")
    legend("bottomright", legend = sprintf("%.3f", auc), title = "AUC", bty = "n", text.col = cols, title.col = "black")
    # abline(v = 0.05, lty = 2)
    # abline(h = pw, col = cols, lty = 2)
    
  }
  
}
dev.off()

#######################################
# prefer true model to constant model #
#######################################

# get the constant-rate simulations
constant_summaries <- summaries[summaries$factor == 1 & summaries$rep > 100,]

# create the BF cutoffs
BF_range   <- range(pretty(constant_summaries$BF_site))
BF_cutoffs <- sort(c(constant_summaries$BF_site, BF_range))

# compute rejection rates for constant-rate simulations
constant_grid <- expand.grid(tips = tips, size = size, factor = 1, stringsAsFactors = FALSE)
constant_FPR  <- do.call(rbind, lapply(1:nrow(constant_grid), function(i) {
  
  # get the analysis
  this_grid   <- constant_grid[i,]
  this_tips   <- this_grid$tips
  this_size   <- this_grid$size
  this_factor <- this_grid$factor
  
  # get the corresponding simulations
  these_summaries    <- summaries[summaries$tips == this_tips & summaries$size == this_size & summaries$factor == this_factor & summaries$rep > 100,]
  # these_summaries    <- summaries[summaries$tips == this_tips & summaries$size == this_size & summaries$factor == this_factor,]
  these_selected_BFs <- sort(these_summaries$BF_selected_site)
  
  # compute the false positive rate per BF cutoff
  this_FPR <- 1.0 - findInterval(BF_cutoffs, these_selected_BFs) / length(these_selected_BFs)
  
  # return
  res <- data.frame(tips   = this_tips, 
                    size   = this_size, 
                    factor = this_factor,
                    BFs    = I(list(this_FPR)))
  return(res)
  
}))

variable_grid <- expand.grid(tips = tips, size = size, factor = factors, stringsAsFactors = FALSE)
variable_FPR  <- do.call(rbind, lapply(1:nrow(variable_grid), function(i) {
  
  # get the analysis
  this_grid   <- variable_grid[i,]
  this_tips   <- this_grid$tips
  this_size   <- this_grid$size
  this_factor <- this_grid$factor
  
  # get the corresponding simulations
  these_summaries    <- summaries[summaries$tips == this_tips & summaries$size == this_size & summaries$factor == this_factor & summaries$rep <= 100,]
  # these_summaries    <- summaries[summaries$tips == this_tips & summaries$size == this_size & summaries$factor == this_factor,]
  these_selected_BFs <- sort(these_summaries$BF_selected_site)
  
  # compute the false positive rate per BF cutoff
  this_FPR <- 1.0 - findInterval(BF_cutoffs, these_selected_BFs) / length(these_selected_BFs)
  
  # return
  res <- data.frame(tips   = this_tips, 
                    size   = this_size, 
                    factor = this_factor,
                    n      = length(these_selected_BFs),
                    BFs    = I(list(this_FPR)))
  return(res)
  
}))

# matrix plot: y-axis is number of tips, x-axis is factor
pdf("figures/factor_prefer_true.pdf", height = 10, width = 15)
layout_mat <- matrix(1:(length(tips) * length(factors)), nrow = length(tips), ncol = length(factors), byrow = TRUE)
layout(layout_mat)
par(mar=c(0,0,0,0), oma = c(4,7,2,0)+0.1)

for(i in 1:length(tips)) {
  
  # get the number of tips
  this_ntips <- tips[i]
  
  for(j in 1:length(factors)) {
    
    # get the factor
    this_factor <- factors[j]
    
    # get correspond results
    these_results          <- variable_FPR[variable_FPR$tips == this_ntips & variable_FPR$factor == this_factor,]
    these_constant_results <- constant_FPR[constant_FPR$tips == this_ntips,]
    
    plot(NA, xlim = c(0,1), ylim = c(0,1), xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
    if (j == 1) {
      mtext("true positive rate", line = 3, side = 2)
      axis(2, lwd = 0, lwd.tick = 1, las = 1)
      mtext(paste0("N = ", this_ntips), line = 5, side = 2)
    }
    if (i == length(tips)) {
      axis(1, lwd = 0, lwd.tick = 1, las = 1)
      mtext("false positive rate", line = 3, side = 1)
    }
    abline(a = 0, b = 1, lty = 2)
    if (i == 1) {
      mtext(paste0("lambda1 = ", this_factor, " x lambda0 "), line = 0.5)
    }
    if (i == 1 & j == 1) {
      legend("topleft", legend = size, col = cols, title = "# sites", bty = "n", lty = 1)
    }
    
    # iterate over alignment sizes
    ns  <- numeric(length(size))
    pw  <- numeric(length(size))
    auc <- numeric(length(size))
    for(k in 1:length(size)) {
      
      # this size
      this_size = size[k]
      
      # get the false positive rate
      this_FPR <- these_constant_results$BFs[these_constant_results$size == this_size][[1]]
      this_TPR <- these_results$BFs[these_results$size == this_size][[1]]
      
      # add the zero
      this_FPR <- c(this_FPR, 0.0)
      this_TPR <- c(this_TPR, 0.0)
      
      # plot the points
      points(x = this_FPR, y = this_TPR, type = "s", col = cols[k])
      
      # store number of sims
      ns[k]  <- these_results$n[these_results$size == this_size]
      
      if ( ns[k] > 0 ) {
        
        # flip
        this_FPR <- rev(this_FPR)
        this_TPR <- rev(this_TPR)
        
        # compute area under curve
        fx <- function(x) {
          this_TPR[findInterval(x, this_FPR, all.inside = TRUE) + 1]
        }
        this_auc <- integrate(fx, lower = 0, upper = 1, stop.on.error = FALSE)$value
        
        # compute the power at a 5% FPR
        this_five_percent_power <- fx(0.05)
        
        # store the power/AUC
        pw[k]  <- this_five_percent_power
        auc[k] <- this_auc
        
      }
      
    }
    
    # legend("bottomright", legend = ns, title = "# sims", bty = "n", text.col = cols, title.col = "black")
    # legend("bottom", legend = sprintf("%.3f", pw), title = "power", bty = "n", text.col = cols, title.col = "black")
    legend("bottomright", legend = sprintf("%.3f", auc), title = "AUC", bty = "n", text.col = cols, title.col = "black")
    # abline(v = 0.05, lty = 2)
    # abline(h = pw, col = cols, lty = 2)
    
  }
  
}
dev.off()


##################################################################
# prefer true model among all models, against the constant model #
##################################################################

# get the constant-rate simulations
constant_summaries <- summaries[summaries$factor == 1 & summaries$rep > 100,]

# create the BF cutoffs
BF_range   <- range(pretty(constant_summaries$BF_site))
BF_cutoffs <- sort(c(constant_summaries$BF_site, BF_range))

# compute rejection rates for constant-rate simulations
constant_grid <- expand.grid(tips = tips, size = size, factor = 1, stringsAsFactors = FALSE)
constant_FPR  <- do.call(rbind, lapply(1:nrow(constant_grid), function(i) {
  
  # get the analysis
  this_grid   <- constant_grid[i,]
  this_tips   <- this_grid$tips
  this_size   <- this_grid$size
  this_factor <- this_grid$factor
  
  # get the corresponding simulations
  these_summaries    <- summaries[summaries$tips == this_tips & summaries$size == this_size & summaries$factor == this_factor & summaries$rep > 100,]
  # these_summaries    <- summaries[summaries$tips == this_tips & summaries$size == this_size & summaries$factor == this_factor,]
  these_selected_BFs <- sort(these_summaries$BF_site)
  
  # compute the false positive rate per BF cutoff
  this_FPR <- 1.0 - findInterval(BF_cutoffs, these_selected_BFs) / length(these_selected_BFs)
  
  # return
  res <- data.frame(tips   = this_tips, 
                    size   = this_size, 
                    factor = this_factor,
                    BFs    = I(list(this_FPR)))
  return(res)
  
}))

variable_grid <- expand.grid(tips = tips, size = size, factor = factors, stringsAsFactors = FALSE)
variable_FPR  <- do.call(rbind, lapply(1:nrow(variable_grid), function(i) {
  
  # get the analysis
  this_grid   <- variable_grid[i,]
  this_tips   <- this_grid$tips
  this_size   <- this_grid$size
  this_factor <- this_grid$factor
  
  # get the corresponding simulations
  these_summaries    <- summaries[summaries$tips == this_tips & summaries$size == this_size & summaries$factor == this_factor & summaries$rep <= 100,]
  # these_summaries    <- summaries[summaries$tips == this_tips & summaries$size == this_size & summaries$factor == this_factor,]
  these_selected_BFs <- sort(these_summaries$BF_site)
  
  # compute the false positive rate per BF cutoff
  this_FPR <- 1.0 - findInterval(BF_cutoffs, these_selected_BFs) / length(these_selected_BFs)
  
  # return
  res <- data.frame(tips   = this_tips, 
                    size   = this_size, 
                    factor = this_factor,
                    n      = length(these_selected_BFs),
                    BFs    = I(list(this_FPR)))
  return(res)
  
}))

# matrix plot: y-axis is number of tips, x-axis is factor
pdf("figures/factor_prefer_true_against_all.pdf", height = 10, width = 15)
layout_mat <- matrix(1:(length(tips) * length(factors)), nrow = length(tips), ncol = length(factors), byrow = TRUE)
layout(layout_mat)
par(mar=c(0,0,0,0), oma = c(4,7,2,0)+0.1)

for(i in 1:length(tips)) {
  
  # get the number of tips
  this_ntips <- tips[i]
  
  for(j in 1:length(factors)) {
    
    # get the factor
    this_factor <- factors[j]
    
    # get correspond results
    these_results          <- variable_FPR[variable_FPR$tips == this_ntips & variable_FPR$factor == this_factor,]
    these_constant_results <- constant_FPR[constant_FPR$tips == this_ntips,]
    
    plot(NA, xlim = c(0,1), ylim = c(0,1), xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
    if (j == 1) {
      mtext("true positive rate", line = 3, side = 2)
      axis(2, lwd = 0, lwd.tick = 1, las = 1)
      mtext(paste0("N = ", this_ntips), line = 5, side = 2)
    }
    if (i == length(tips)) {
      axis(1, lwd = 0, lwd.tick = 1, las = 1)
      mtext("false positive rate", line = 3, side = 1)
    }
    abline(a = 0, b = 1, lty = 2)
    if (i == 1) {
      mtext(paste0("lambda1 = ", this_factor, " x lambda0 "), line = 0.5)
    }
    if (i == 1 & j == 1) {
      legend("topleft", legend = size, col = cols, title = "# sites", bty = "n", lty = 1)
    }
    
    # iterate over alignment sizes
    ns  <- numeric(length(size))
    pw  <- numeric(length(size))
    auc <- numeric(length(size))
    for(k in 1:length(size)) {
      
      # this size
      this_size = size[k]
      
      # get the false positive rate
      this_FPR <- these_constant_results$BFs[these_constant_results$size == this_size][[1]]
      this_TPR <- these_results$BFs[these_results$size == this_size][[1]]
      
      # add the zero
      this_FPR <- c(this_FPR, 0.0)
      this_TPR <- c(this_TPR, 0.0)
      
      # plot the points
      points(x = this_FPR, y = this_TPR, type = "s", col = cols[k])
      
      # store number of sims
      ns[k]  <- these_results$n[these_results$size == this_size]
      
      if ( ns[k] > 0 ) {
        
        # flip
        this_FPR <- rev(this_FPR)
        this_TPR <- rev(this_TPR)
        
        # compute area under curve
        fx <- function(x) {
          this_TPR[findInterval(x, this_FPR, all.inside = TRUE) + 1]
        }
        this_auc <- integrate(fx, lower = 0, upper = 1, stop.on.error = FALSE)$value
        
        # compute the power at a 5% FPR
        this_five_percent_power <- fx(0.05)
        
        # store the power/AUC
        pw[k]  <- this_five_percent_power
        auc[k] <- this_auc
        
      }
      
    }
    
    # legend("bottomright", legend = ns, title = "# sims", bty = "n", text.col = cols, title.col = "black")
    # legend("bottom", legend = sprintf("%.3f", pw), title = "power", bty = "n", text.col = cols, title.col = "black")
    legend("bottomright", legend = sprintf("%.3f", auc), title = "AUC", bty = "n", text.col = cols, title.col = "black")
    # abline(v = 0.05, lty = 2)
    # abline(h = pw, col = cols, lty = 2)
    
  }
  
}
dev.off()


#########################
# identify correct site #
#########################

cols <- cols[size != 1]

# create the BF cutoffs
BF_range   <- range(pretty(summaries$BF_selected))
BF_cutoffs <- sort(c(summaries$BF_site_max, BF_range))

subsize <- size[size != 1]
variable_grid <- expand.grid(tips = tips, size = subsize, factor = factors, stringsAsFactors = FALSE)
variable_FPR  <- do.call(rbind, lapply(1:nrow(variable_grid), function(i) {
  
  # get the analysis
  this_grid   <- variable_grid[i,]
  this_tips   <- this_grid$tips
  this_size   <- this_grid$size
  this_factor <- this_grid$factor
  
  # get the corresponding simulations
  # these_summaries    <- summaries[summaries$tips == this_tips & summaries$size == this_size & summaries$factor == this_factor & summaries$rep <= 100,]
  these_summaries    <- summaries[summaries$tips == this_tips & summaries$size == this_size & summaries$factor == this_factor,]
  these_selected_BFs <- these_summaries$BF_site_max
  these_selected_BFs[these_selected_BFs == these_summaries$BF_site] <- -Inf
  these_selected_BFs <- sort(these_selected_BFs)
  
  # compute the false positive rate per BF cutoff
  this_FPR <- 1.0 - findInterval(BF_cutoffs, these_selected_BFs) / length(these_selected_BFs)
  
  # return
  res <- data.frame(tips   = this_tips, 
                    size   = this_size, 
                    factor = this_factor,
                    n      = length(these_selected_BFs),
                    BFs    = I(list(this_FPR)))
  return(res)
  
}))

variable_TPR  <- do.call(rbind, lapply(1:nrow(variable_grid), function(i) {
  
  # get the analysis
  this_grid   <- variable_grid[i,]
  this_tips   <- this_grid$tips
  this_size   <- this_grid$size
  this_factor <- this_grid$factor
  
  # get the corresponding simulations
  # these_summaries    <- summaries[summaries$tips == this_tips & summaries$size == this_size & summaries$factor == this_factor & summaries$rep > 100,]
  these_summaries    <- summaries[summaries$tips == this_tips & summaries$size == this_size & summaries$factor == this_factor,]
  these_selected_BFs <- these_summaries$BF_site_max
  these_selected_BFs[these_selected_BFs != these_summaries$BF_site] <- -Inf
  these_selected_BFs <- sort(these_selected_BFs)
  
  # compute the false positive rate per BF cutoff
  this_FPR <- 1.0 - findInterval(BF_cutoffs, these_selected_BFs) / length(these_selected_BFs)
  
  # return
  res <- data.frame(tips   = this_tips, 
                    size   = this_size, 
                    factor = this_factor,
                    n      = length(these_selected_BFs),
                    BFs    = I(list(this_FPR)))
  return(res)
  
}))

# matrix plot: y-axis is number of tips, x-axis is factor
pdf("figures/factor_select_site.pdf", height = 10, width = 15)
layout_mat <- matrix(1:(length(tips) * length(factors)), nrow = length(tips), ncol = length(factors), byrow = TRUE)
layout(layout_mat)
par(mar=c(0,0,0,0), oma = c(4,7,2,0)+0.1)

for(i in 1:length(tips)) {
  
  # get the number of tips
  this_ntips <- tips[i]
  
  for(j in 1:length(factors)) {
    
    # get the factor
    this_factor <- factors[j]
    
    # get correspond results
    these_FPRs <- variable_FPR[variable_FPR$tips == this_ntips & variable_FPR$factor == this_factor,]
    these_TPRs <- variable_TPR[variable_TPR$tips == this_ntips & variable_TPR$factor == this_factor,]
    
    plot(NA, xlim = c(0,1), ylim = c(0,1), xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
    if (j == 1) {
      mtext("true positive rate", line = 3, side = 2)
      axis(2, lwd = 0, lwd.tick = 1, las = 1)
      mtext(paste0("N = ", this_ntips), line = 5, side = 2)
    }
    if (i == length(tips)) {
      axis(1, lwd = 0, lwd.tick = 1, las = 1)
      mtext("false positive rate", line = 3, side = 1)
    }
    abline(a = 0, b = 1, lty = 2)
    # abline(a = 1, b = -1, lty = 2)
    if (i == 1) {
      mtext(paste0("lambda1 = ", this_factor, " x lambda0 "), line = 0.5)
    }
    if (i == 1 & j == 1) {
      legend("topleft", legend = subsize, col = cols, title = "# sites", bty = "n", lty = 1)
    }
    
    # iterate over alignment sizes
    ns  <- numeric(length(subsize))
    pw  <- numeric(length(subsize))
    auc <- numeric(length(subsize))
    for(k in 1:length(subsize)) {
      
      # this size
      this_size <- subsize[k]
      
      # get the false positive rate
      this_FPR <- these_FPRs$BFs[these_FPRs$size == this_size][[1]]
      this_TPR <- these_TPRs$BFs[these_TPRs$size == this_size][[1]]
      
      # add the zero
      this_FPR <- c(this_FPR, 0.0)
      this_TPR <- c(this_TPR, 0.0)
      
      # plot the points
      points(x = this_FPR, y = this_TPR, type = "s", col = cols[k])
      
      # store number of sims
      ns[k]  <- these_FPRs$n[k] + these_TPRs$n[k]
      
      if ( these_FPRs$n[k] > 0 &  these_TPRs$n[k] > 0 ) {
        
        # flip
        this_FPR <- rev(this_FPR)
        this_TPR <- rev(this_TPR)
        
        # compute area under curve
        fx <- function(x) {
          this_TPR[findInterval(x, this_FPR, all.inside = TRUE) + 1]
        }
        this_auc <- integrate(fx, lower = 0, upper = 1, stop.on.error = FALSE)$value
        
        # compute the power at a 5% FPR
        this_five_percent_power <- fx(0.05)
        
        # store the power/AUC
        pw[k]  <- this_five_percent_power
        auc[k] <- this_auc
        
      }
      
    }
    
    # legend("bottomright", legend = ns, title = "# sims", bty = "n", text.col = cols, title.col = "black")
    # legend("bottom", legend = sprintf("%.3f", pw), title = "power", bty = "n", text.col = cols, title.col = "black")
    # legend("right", legend = sprintf("%.3f", auc), title = "AUC", bty = "n", text.col = cols, title.col = "black")
    # abline(v = 0.05, lty = 2)
    # abline(h = pw, col = cols, lty = 2)
    
  }
  
}
dev.off()



# # Bayes factors as a function of fraction of alleles in selected state
# 
# pdf("figures/factor_reject_constant_bf_by_frac.pdf", width = 10)
# layout_mat <- matrix(1:(length(tips) * length(factors)), nrow = length(tips), ncol = length(factors), byrow = TRUE)
# layout(layout_mat)
# par(mar=c(0,0,0,0), oma = c(4,7,2,0)+0.1)
# 
# for(i in 1:length(tips)) {
#   
#   # get the number of tips
#   this_ntips <- tips[i]
#   
#   for(j in 1:length(factors)) {
#     
#     # get the factor
#     this_factor <- factors[j]
# 
#     # get correspond results
#     these_results <- summaries[summaries$tips == this_ntips & summaries$factor == this_factor,]
#     
#     plot(NA, xlim = c(0,1), ylim = BF_range, xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
#     if (j == 1) {
#       mtext("2lnBF against neutral", line = 3, side = 2)
#       axis(2, lwd = 0, lwd.tick = 1, las = 1)
#       mtext(paste0("N = ", this_ntips), line = 5, side = 2)
#     }
#     if (i == length(tips)) {
#       axis(1, lwd = 0, lwd.tick = 1, las = 1)
#       mtext("fraction beneficial alleles", line = 3, side = 1)
#     }
#     if (i == 1) {
#       mtext(paste0("lambda1 = ", this_factor, " x lambda0 "), line = 0.5)
#     }
#     if (i == 1 & j == 1) {
#       legend("topleft", legend = size, col = cols, title = "# sites", bty = "n", pch = 1)
#     }
#     
#     # iterate over alignment sizes
#     for(k in 1:length(size)) {
#       
#       # this size
#       this_size = size[k]
#       
#       # get the results
#       these_site_results <- these_results[these_results$size == this_size,]
# 
#       # fit a model
#       model     <- lm(BF_selected ~ frac_sel, data = these_site_results)
#       intercept <- coef(model)[1]
#       slope     <- coef(model)[2]
#       
#       # plot the points
#       points(x = these_site_results$frac_sel, y = these_site_results$BF_selected, type = "p", col = cols[k], pch = 3, cex = 0.5)
#       
#       # plot the model
#       abline(a = intercept, b = slope, col = cols[k])
#       
#     }
#     
#   }
#   
# }
# dev.off()




##############################
# reject constant-rate model #
##############################
# 
# # get the constant-rate simulations
# constant_summaries <- summaries[summaries$factor == 1 & summaries$rep > 100,]
# 
# # create the BF cutoffs
# BF_range   <- range(pretty(constant_summaries$BF_selected))
# BF_cutoffs <- seq(BF_range[1], BF_range[2], length.out=1001)
# 
# # compute rejection rates for constant-rate simulations
# constant_grid <- expand.grid(tips = tips, size = size, factor = 1, stringsAsFactors = FALSE)
# constant_FPR  <- do.call(rbind, lapply(1:nrow(constant_grid), function(i) {
#   
#   # get the analysis
#   this_grid   <- constant_grid[i,]
#   this_tips   <- this_grid$tips
#   this_size   <- this_grid$size
#   this_factor <- this_grid$factor
#   
#   # get the corresponding simulations
#   these_summaries    <- summaries[summaries$tips == this_tips & summaries$size == this_size & summaries$factor == this_factor & summaries$rep > 100,]
#   these_selected_BFs <- sort(these_summaries$BF_selected_site)
#   
#   # compute the false positive rate per BF cutoff
#   this_FPR <- 1.0 - findInterval(BF_cutoffs, these_selected_BFs) / length(these_selected_BFs)
#   
#   # return
#   res <- data.frame(tips   = this_tips, 
#                     size   = this_size, 
#                     factor = this_factor,
#                     BFs    = I(list(this_FPR)))
#   return(res)
#   
# }))
# 
# variable_grid <- expand.grid(tips = tips, size = size, factor = factors, stringsAsFactors = FALSE)
# variable_FPR  <- do.call(rbind, lapply(1:nrow(variable_grid), function(i) {
#   
#   # get the analysis
#   this_grid   <- variable_grid[i,]
#   this_tips   <- this_grid$tips
#   this_size   <- this_grid$size
#   this_factor <- this_grid$factor
#   
#   # get the corresponding simulations
#   these_summaries    <- summaries[summaries$tips == this_tips & summaries$size == this_size & summaries$factor == this_factor & summaries$rep <= 100,]
#   these_selected_BFs <- sort(these_summaries$BF_selected_site)
#   
#   # compute the false positive rate per BF cutoff
#   this_FPR <- 1.0 - findInterval(BF_cutoffs, these_selected_BFs) / length(these_selected_BFs)
#   
#   # return
#   res <- data.frame(tips   = this_tips, 
#                     size   = this_size, 
#                     factor = this_factor,
#                     n      = length(these_selected_BFs),
#                     BFs    = I(list(this_FPR)))
#   return(res)
#   
# }))
# 
# # matrix plot: y-axis is number of tips, x-axis is factor
# cols <- brewer.pal(3, "Set1")
# 
# pdf("figures/factor_reject_constant_vs_true.pdf", width = 10)
# layout_mat <- matrix(1:(length(tips) * length(factors)), nrow = length(tips), ncol = length(factors), byrow = TRUE)
# layout(layout_mat)
# par(mar=c(0,0,0,0), oma = c(4,7,2,0)+0.1)
# 
# for(i in 1:length(tips)) {
#   
#   # get the number of tips
#   this_ntips <- tips[i]
#   
#   for(j in 1:length(factors)) {
#     
#     # get the factor
#     this_factor <- factors[j]
#     
#     # get correspond results
#     these_results          <- variable_FPR[variable_FPR$tips == this_ntips & variable_FPR$factor == this_factor,]
#     these_constant_results <- constant_FPR[constant_FPR$tips == this_ntips,]
#     
#     plot(NA, xlim = c(0,1), ylim = c(0,1), xlab = NA, ylab = NA, xaxt = "n", yaxt = "n")
#     if (j == 1) {
#       mtext("true positive rate", line = 3, side = 2)
#       axis(2, lwd = 0, lwd.tick = 1, las = 1)
#       mtext(paste0("N = ", this_ntips), line = 5, side = 2)
#     }
#     if (i == length(tips)) {
#       axis(1, lwd = 0, lwd.tick = 1, las = 1)
#       mtext("false positive rate", line = 3, side = 1)
#     }
#     abline(a = 0, b = 1, lty = 2)
#     if (i == 1) {
#       mtext(paste0("lambda1 = ", this_factor, " x lambda0 "), line = 0.5)
#     }
#     if (i == 1 & j == 1) {
#       legend("topleft", legend = size, col = cols, title = "# sites", bty = "n", lty = 1)
#     }
#     
#     # iterate over alignment sizes
#     ns <- numeric(length(size))
#     for(k in 1:length(size)) {
#       
#       # this size
#       this_size = size[k]
#       
#       # get the false positive rate
#       this_FPR <- these_constant_results$BFs[these_constant_results$size == this_size][[1]]
#       this_TPR <- these_results$BFs[these_results$size == this_size][[1]]
#       
#       # add the zero
#       this_FPR <- c(this_FPR, 0.0)
#       this_TPR <- c(this_TPR, 0.0)
#       
#       # plot the points
#       points(x = this_FPR, y = this_TPR, type = "l", col = cols[k])
#       
#       # store number of sims
#       ns[k] <- these_results$n[these_results$size == this_size]
#       
#     }
#     
#     legend("bottomright", legend = ns, title = "# sims", bty = "n", text.col = cols, title.col = "black")
#     
#   }
#   
# }
# dev.off()
# 
# 


