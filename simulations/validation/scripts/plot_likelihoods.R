library(viridis)

# read values
likelihoods_2_samples <- read.table("results/compare_likelihoods_2_samples.tsv", header = TRUE, sep = " ")
likelihoods_3_samples <- read.table("results/compare_likelihoods_3_samples.tsv", header = TRUE, sep = " ")
likelihoods_4_samples <- read.table("results/compare_likelihoods_4_samples.tsv", header = TRUE, sep = " ")

# plot
# cols <- c("red","blue")
figdir <- "~/repos/yuleselectionMS/figures/"
cols <- rev(turbo(2, begin = 0.1, end = 0.8))

pdf(paste0(figdir, "validate_likelihood.pdf"), height = 8, width = 10)
par(oma=c(4,4,0,0)+0.1, mar = c(0,0,0,0), mfrow = c(3,1), lend = 2)
matplot(likelihoods_2_samples$lambda1, likelihoods_2_samples[,2:3], pch = c(3,4), type = "p", col = cols, xaxt = "n", yaxt = "n", ylab = "log likelihood", xlab = NA, lwd = 1.5)
axis(2, lwd = 0, lwd.tick = 1, las = 1)
mtext(side = 2, text = "log likelihood", line = 3, outer = TRUE)
legend("topleft", legend = "2 samples", bty = "n", cex = 1.5)
legend("center", legend = c("count", "tree (integrated)"), title = "method", pch = c(3,4), col = cols, bty = "n")

matplot(likelihoods_3_samples$lambda1, likelihoods_3_samples[,2:3], pch = c(3,4), type = "p", col = cols, xaxt = "n", yaxt = "n", ylab = "log likelihood", xlab = NA, lwd = 1.5)
axis(2, lwd = 0, lwd.tick = 1, las = 1)
mtext(side = 2, text = "log likelihood", line = 3, outer = TRUE)
legend("topleft", legend = "3 samples", bty = "n", cex = 1.5)

matplot(likelihoods_4_samples$lambda1, likelihoods_4_samples[,2:3], pch = c(3,4), type = "p", col = cols, xaxt = "n", yaxt = "n", ylab = "log likelihood", xlab = NA, lwd = 1.5)
axis(2, lwd = 0, lwd.tick = 1, las = 1)
axis(1, at = pretty(c(0,2), 10), lwd = 0, lwd.tick = 1, las = 1)
mtext(side = 1, text = bquote(lambda[1]), line = 3, outer = TRUE)
mtext(side = 2, text = "log likelihood", line = 3, outer = TRUE)
legend("topleft", legend = "4 samples", bty = "n", cex = 1.5)
dev.off()
