library(ks)
library(vioplot)

vioplot.default <-
  function (x, ..., data = NULL, range = 1.5, h = NULL, xlim = NULL, ylim = NULL, names = NULL,
            horizontal = FALSE, col = "grey50", border = par()$fg, lty = 1,
            lwd = 1, rectCol = par()$fg, lineCol = par()$fg, pchMed = 19, colMed = "white", colMed2 = "grey 75",
            at, add = FALSE, wex = 1, drawRect = TRUE, areaEqual=FALSE,
            axes = TRUE, frame.plot = axes, panel.first = NULL, panel.last = NULL, asp = NA,
            main="", sub="", xlab=NA, ylab=NA, line = NA, outer = FALSE,
            xlog = NA, ylog=NA, adj=NA, ann = NA, ask=NA, bg=NA, bty=NA,
            cex=NA, cex.axis=NA, cex.lab=NA, cex.main=NA, cex.names=NULL, cex.sub=NA,
            cin=NA, col.axis=NA, col.lab=NA, col.main=NA, col.sub=NA,
            cra=NA, crt=NA, csi=NA,cxy=NA, din=NA, err=NA, family=NA, fg=NA,
            fig=NA, fin=NA, font=NA, font.axis=NA, font.lab=NA, font.main=NA, font.sub=NA,
            lab=NA, las=NA, lend=NA, lheight=NA, ljoin=NA, lmitre=NA, mai=NA, mar=NA, mex=NA,
            mfcol=NA, mfg=NA, mfrow=NA, mgp=NA, mkh=NA, new=NA, oma=NA, omd=NA, omi=NA,
            page=NA, pch=NA, pin=NA, plt=NA, ps=NA, pty=NA, smo=NA, srt=NA, tck=NA, tcl=NA,
            usr=NA, xaxp=NA, xaxs=NA, xaxt=NA, xpd=NA, yaxp=NA, yaxs=NA, yaxt=NA, ylbias=NA,
            log="", logLab=c(1,2,5),
            na.action = NULL, na.rm = T, side = "both", plotCentre = "point")
  {
    #assign graphical parameters if not given
    for(ii in 1:length(names(par()))){
      if(is.na(get(names(par())[ii])[1])) assign(names(par()[ii]), unlist(par()[[ii]]))
    }
    if(add && side != "both"){
      if(!is.null(names)) warning("Warning: names can only be changed on first call of vioplot (when add = FALSE)
")
      if(!is.na(xlab)) warning("Warning: x-axis labels can only be changed on first call of vioplot (when add = FALSE)
")
      if(!is.na(ylab)) warning("vy-axis labels can only be changed on first call of vioplot (when add = FALSE)
")
      if(!missing(main)) warning("Warning: main title can only be changed on first call of vioplot (when add = FALSE)
")
      if(!missing(sub)) warning("Warning: subtitle can only be changed on first call of vioplot (when add = FALSE)
 ")
    }
    
    
    
    if(!is.list(x)){
      datas <- list(x, ...)
    } else{
      datas <- lapply(x, unlist)
      if(is.null(names)){
        names <- names(datas)
      }
    }
    datas <- lapply(datas, function(x){
      if(all(x == unique(x)[1]) & length(x) > 100){
        unique(x)[1]
      } else {
        x
      }
    })
    if(is.character(log)) if("y" %in% unlist(strsplit(log, ""))) log <- TRUE
    if(is.na(xlog) | (horizontal == TRUE & (log == FALSE | log == ""))) xlog <- FALSE
    log <- ifelse(log == TRUE, "y", "")
    if(log == 'x' | log == 'xy' | xlog == TRUE){
      if(horizontal | log == "xy"){
        log <- TRUE
      } else {
        log <- FALSE
        ylog <- FALSE
      }
      xlog <- FALSE
    }
    if(log == TRUE | ylog == TRUE){
      ylog <- TRUE
      log <- "y"
    } else {
      log <- ""
    }
    if(ylog){
      #check data is compatible with log scale
      if(all(unlist(datas) <= 0)){
        ylog <- FALSE
        warning("log scale cannot be used with non-positive data")
      } else {
        #log-scale data
        datas <- datas #lapply(datas, function(x) log(unlist(x)))
      }
    }
    if(is.null(na.action)) na.action <- na.omit
    lapply(datas, function(data) data <- data[!sapply(data, is.infinite)])
    if(na.rm) datas <- lapply(datas, na.action)
    n <- length(datas)
    #if(is.list(datas)) datas <- as.data.frame(datas)
    if (missing(at))
      at <- 1:n
    upper <- vector(mode = "numeric", length = n)
    lower <- vector(mode = "numeric", length = n)
    q1 <- vector(mode = "numeric", length = n)
    q2 <- vector(mode = "numeric", length = n)
    q3 <- vector(mode = "numeric", length = n)
    med <- vector(mode = "numeric", length = n)
    base <- vector(mode = "list", length = n)
    height <- vector(mode = "list", length = n)
    area_check <- vector(mode = "list", length = n)
    baserange <- c(Inf, -Inf)
    args <- list(display = "none")
    if ( "w" %in% names(list(...)) == FALSE ) {
      has_weights <- FALSE
    } else {
      has_weights <- TRUE
      weights <- list(...)$w
    }
    radj <- ifelse(side == "right", 0, 1)
    ladj <- ifelse(side == "left", 0, 1)
    boxwex <- wex
    if (!(is.null(h)))
      args <- c(args, h = h)
    if(plotCentre == "line") med.dens <- rep(NA, n)
    if(areaEqual){
      for (i in 1:n) {
        data <- unlist(datas[[i]])
        # if ( is.null(ylim) ) {
          data.min <- min(data, na.rm = na.rm)
          data.max <- max(data, na.rm = na.rm)
        # } else {
        #   data.min <- min(ylim)
        #   data.max <- max(ylim)
        # }
        q1[i] <- quantile(data, 0.25)
        q2[i] <- quantile(data, 0.5)
        q3[i] <- quantile(data, 0.75)
        med[i] <- median(data)
        iqd <- q3[i] - q1[i]
        upper[i] <- min(q3[i] + range * iqd, data.max)
        lower[i] <- max(q1[i] - range * iqd, data.min)
        est.xlim <- c(min(lower[i], data.min), max(upper[i],
                                                   data.max))
        # print("A")
        # smout <- do.call("sm.density", c(list(data, xlim = est.xlim), args))
        smout <- do.call("sm.density", c(list(data, xlim = est.xlim), args))
        if ( length(unique(data)) > 1 ) {
          if ( has_weights ) {
            smout <- kde(data, h = smout$h, xmin = est.xlim[1], xmax = est.xlim[2], w = weights[[i]])
          } else {
            smout <- kde(data, h = smout$h, xmin = est.xlim[1], xmax = est.xlim[2])  
          }
        }
        
        if(plotCentre == "line"){
          print("B")
          med.dat <- do.call("sm.density",
                             c(list(data, xlim=est.xlim,
                                    eval.points=med[i], display = "none")))
          med.dens[i] <- med.dat$estimate
        }

        area_check[[i]] <- sum(smout$estimate * (smout$eval.points[2] - smout$eval.points[1]))
        
        # Avg.pos <- mean(smout$eval.points)
        # xt <- diff(smout$eval.points[smout$eval.points<Avg.pos])
        # yt <- rollmean(smout$eval.points[smout$eval.points<Avg.pos],2)
        # area_check[[i]] <- sum(xt*yt)
        
      }
      if(length(wex)>1){
        warning("wex may not be a vector if areaEqual is TRUE")
        print("using first element of wex")
        wex<-wex[i]
      }
      # wex <- 0.5 / unlist(area_check)
      wex <-unlist(area_check)/max(unlist(area_check))*wex
    }
    for (i in 1:n) {
      data <- unlist(datas[[i]])
      # if ( is.null(ylim) ) {
        data.min <- min(data, na.rm = na.rm)
        data.max <- max(data, na.rm = na.rm)
      # } else {
      #   data.min <- min(ylim)
      #   data.max <- max(ylim)
      # }
      q1[i] <- quantile(data, 0.25)
      q2[i] <- quantile(data, 0.5)
      q3[i] <- quantile(data, 0.75)
      med[i] <- median(data)
      iqd <- q3[i] - q1[i]
      upper[i] <- min(q3[i] + range * iqd, data.max)
      lower[i] <- max(q1[i] - range * iqd, data.min)
      est.xlim <- c(min(lower[i], data.min), max(upper[i],
                                                 data.max))
      
      smout <- do.call("sm.density", c(list(data, xlim = est.xlim), args))
      if ( length(unique(data)) > 1 ) {
        if ( has_weights ) {
          smout <- kde(data, h = smout$h, xmin = est.xlim[1], xmax = est.xlim[2], w = weights[[i]])
        } else {
          smout <- kde(data, h = smout$h, xmin = est.xlim[1], xmax = est.xlim[2])  
        }
      }
      
      hscale <- 0.4/max(smout$estimate) * ifelse(length(wex)>1, wex[i], wex)
      base[[i]] <- smout$eval.points
      height[[i]] <- smout$estimate * hscale
      t <- range(base[[i]])
      baserange[1] <- min(baserange[1], t[1])
      baserange[2] <- max(baserange[2], t[2])
      if(plotCentre == "line"){
        recover()
        med.dat <- do.call("sm.density",
                           c(list(data, xlim=est.xlim,
                                  eval.points=med[i], display = "none")))
        med.dens[i] <- med.dat$estimate *hscale
      }
    }
    if (!add) {
      if (is.null(xlim)) {
        xlim <- if (n == 1){
          at + c(-0.5, 0.5)
        } else {
          range(at) + min(diff(at))/2 * c(-1, 1)
        }
      } else {
        xlim.default <- if (n == 1){
          at + c(-0.5, 0.5)
        } else {
          range(at) + min(diff(at))/2 * c(-1, 1)
        }
        print(paste0("Using c(", xlim[1],",", xlim[2], ") as input for xlim, note that default values for these dimensions are c(", xlim.default[1],",", xlim.default[2], ")"))
      }
      if (is.null(ylim)) {
        ylim <- baserange
      }
    }
    if (is.null(names)) {
      label <- 1:n
    }
    else {
      label <- names
    }
    boxwidth <- 0.05 * ifelse(length(boxwex)>1, boxwex[i], boxwex)
    if (!add){
      plot.new()
      if(!horizontal){
        plot.window(xlim, ylim, log = log, asp = asp, bty = bty, cex = cex, xaxs = xaxs, yaxs = yaxs, lab = lab, mai = mai, mar = mar, mex = mex, mfcol = mfcol, mfrow = mfrow, mfg = mfg, xlog = xlog, ylog = ylog)
      } else {
        plot.window(ylim, xlim, log = ifelse(log == "y", "x", ""), asp = asp, bty = bty, cex = cex, xaxs = xaxs, yaxs = yaxs, lab = lab, mai = mai, mar = mar, mex = mex, mfcol = mfcol, mfrow = mfrow, mfg = mfg, xlog = ylog, ylog = xlog)
      }
    }
    panel.first
    if (!horizontal) {
      if (!add) {
        plot.window(xlim, ylim, log = log, asp = asp, bty = bty, cex = cex, xaxs = xaxs, yaxs = yaxs, lab = lab, mai = mai, mar = mar, mex = mex, mfcol = mfcol, mfrow = mfrow, mfg = mfg, xlog = xlog, ylog = ylog)
        xaxp <- par()$xaxp
        yaxp <- par()$yaxp
        if(yaxt !="n"){
          if(ylog){
            #log_axis_label <- log_axis_label[log_axis >= exp(par("usr")[3])]
            #log_axis <- log_axis[log_axis >= exp(par("usr")[3])]
            #log_axis_label <- log_axis_label[log_axis <= exp(par("usr")[4])]
            #log_axis <- log_axis[log_axis <= exp(par("usr")[4])]
            Axis(unlist(datas), side = 2, cex.axis = cex.axis, col.axis = col.axis, font.axis = font.axis, mgp = mgp, tck = tck, tcl = tcl, las = las) # xaxp = xaxp, yaxp = yaxp disabled for log
            if(is.null(cex.names)) cex.names <- cex.axis
            if(xaxt !="n"){
              Axis(1:length(datas), at = at, labels = label, side = 1, cex.axis = cex.names, col.axis = col.axis, font.axis = font.axis, mgp = mgp, tck = tck, tcl = tcl, las = las) # xaxp = xaxp, yaxp = yaxp disabled for log
            }
          } else {
            Axis(unlist(datas), side = 2, cex.axis = cex.axis, col.axis = col.axis, font.axis = font.axis, mgp = mgp, yaxp = yaxp, tck = tck, tcl = tcl, las = las)
            if(is.null(cex.names)) cex.names <- cex.axis
            if(xaxt !="n"){
              Axis(1:length(datas), at = at, labels = label, side = 1, cex.axis = cex.names, col.axis = col.axis, font.axis = font.axis, mgp = mgp, xaxp = xaxp, tck = tck, tcl = tcl, las = las)
            }
          }
        }
      }
      if (frame.plot) {
        box(lty = lty, lwd = lwd)
      }
      for (i in 1:n) {
        polygon(c(at[i] - radj*height[[i]], rev(at[i] + ladj*height[[i]])),
                c(base[[i]], rev(base[[i]])), col = ifelse(length(col)>1,col[1+(i-1)%%length(col)], col), border = ifelse(length(border)>1, border[1+(i-1)%%length(border)], border),
                lty = lty, lwd = lwd, xpd = xpd, lend = lend, ljoin = ljoin, lmitre = lmitre)
        if (drawRect) {
          lines(at[c(i, i)], c(lower[i], upper[i]), lwd = lwd,
                lty = lty, col = ifelse(length(lineCol)>1, lineCol[1+(i-1)%%length(lineCol)], lineCol), lend = lend, ljoin = ljoin, lmitre = lmitre)
          rect(at[i] - radj*ifelse(length(boxwidth)>1, boxwidth[i], boxwidth)/2, q1[i], at[i] + ladj*ifelse(length(boxwidth)>1, boxwidth[i], boxwidth)/2,
               q3[i], col = ifelse(length(rectCol)>1, rectCol[1+(i-1)%%length(rectCol)], rectCol), border = ifelse(length(lineCol)>1, lineCol[1+(i-1)%%length(lineCol)], lineCol), xpd = xpd, lend = lend, ljoin = ljoin, lmitre = lmitre)
          if(plotCentre == "line"){
            lines(x = c(at[i] - radj*med.dens[i],
                        at[i],
                        at[i] + ladj*med.dens[i]),
                  y = rep(med[i],3))
          } else {
            points(at[i], med[i], pch = ifelse(length(pchMed)>1, pchMed[1+(i-1)%%length(pchMed)], pchMed), col = ifelse(length(colMed)>1, colMed[1+(i-1)%%length(colMed)], colMed), bg = ifelse(length(colMed2)>1, colMed2[1+(i-1)%%length(colMed2)], colMed2), cex = cex, lwd = lwd, lty = lty)
          }
        }
      }
    }
    else {
      if(log == "y" || ylog == TRUE){
        log <- "x"
        xlog <- TRUE
        ylog <- FALSE
      }
      if (!add) {
        plot.window(ylim, xlim, log = log, asp = asp, bty = bty, cex = cex, xaxs = xaxs, yaxs = yaxs, lab = lab, mai = mai, mar = mar, mex = mex, mfcol = mfcol, mfrow = mfrow, mfg = mfg, xlog = xlog, ylog = ylog)
        xaxp <- par()$xaxp
        yaxp <- par()$yaxp
        if(yaxt !="n"){
          if(xlog){
            #log_axis_label <- log_axis_label[log_axis >= exp(par("usr")[3])]
            #log_axis <- log_axis[log_axis >= exp(par("usr")[3])]
            #log_axis_label <- log_axis_label[log_axis <= exp(par("usr")[4])]
            #log_axis <- log_axis[log_axis <= exp(par("usr")[4])]
            Axis(unlist(datas), side = 1, cex.axis = cex.names, col.axis = col.axis, font.axis = font.axis, mgp = mgp, tck = tck, tcl = tcl, las = las) # xaxp = xaxp, yaxp = yaxp disabled for log
            if(is.null(cex.names)) cex.names <- cex.axis
            if(xaxt !="n"){
              Axis(1:length(datas), at = at, labels = label, side = 2, cex.axis = cex.axis, col.axis = col.axis, font.axis = font.axis, mgp = mgp, tck = tck, tcl = tcl, las = las) # xaxp = xaxp, yaxp = yaxp disabled for log
            }
          } else {
            Axis(unlist(datas), side = 1, cex.axis = cex.names, col.axis = col.axis, font.axis = font.axis, mgp = mgp, xaxp = xaxp, tck = tck, tcl = tcl, las = las)
            if(is.null(cex.names)) cex.names <- cex.axis
            if(xaxt !="n"){
              Axis(1:length(datas), at = at, labels = label, side = 2, cex.axis = cex.axis, col.axis = col.axis, font.axis = font.axis, mgp = mgp, yaxp = yaxp, tck = tck, tcl = tcl, las = las)
            }
          }
        }
      }
      if (frame.plot) {
        box(lty = lty, lwd = lwd)
      }
      for (i in 1:n) {
        polygon(c(base[[i]], rev(base[[i]])), c(at[i] - radj*height[[i]],
                                                rev(at[i] + ladj*height[[i]])), col = ifelse(length(col)>1,col[1+(i-1)%%length(col)], col), border = ifelse(length(border)>1, border[1+(i-1)%%length(border)], border),
                lty = lty, lwd = lwd, xpd = xpd, lend = lend, ljoin = ljoin, lmitre = lmitre)
        if (drawRect) {
          lines(c(lower[i], upper[i]), at[c(i, i)], lwd = lwd,
                lty = lty, col = ifelse(length(lineCol)>1, lineCol[1+(i-1)%%length(lineCol)], lineCol), lend = lend, ljoin = ljoin, lmitre = lmitre)
          rect(q1[i], at[i] - radj*ifelse(length(boxwidth)>1, boxwidth[i], boxwidth)/2, q3[i], at[i] +
                 ladj*ifelse(length(boxwidth)>1, boxwidth[i], boxwidth)/2, col = ifelse(length(rectCol)>1, rectCol[1+(i-1)%%length(rectCol)], rectCol), border = ifelse(length(lineCol)>1, lineCol[1+(i-1)%%length(lineCol)], lineCol), xpd = xpd, lend = lend, ljoin = ljoin, lmitre = lmitre)
          if(plotCentre == "line"){
            lines(y = c(at[i] - radj*med.dens[i],
                        at[i],
                        at[i] + ladj*med.dens[i]),
                  x = rep(med[i],3))
          } else {
            points(med[i], at[i], pch = ifelse(length(pchMed)>1, pchMed[1+(i-1)%%length(pchMed)], pchMed), col = ifelse(length(colMed)>1, colMed[1+(i-1)%%length(colMed)], colMed), , bg = ifelse(length(colMed2)>1, colMed2[1+(i-1)%%length(colMed2)], colMed2), cex = cex, lwd = lwd, lty = lty)
          }
        }
      }
    }
    panel.last
    if (ann) {
      title(main = main, sub = sub, xlab = xlab, ylab = ylab, line = line, outer = outer, xpd = xpd, cex.main = cex.main, col.main = col.main, font.main = font.main)
    }
    invisible(list(upper = upper, lower = lower, median = med,
                   q1 = q1, q3 = q3, height = height, base = base))
  }


assignInNamespace("vioplot.default", vioplot.default, ns = environment(vioplot))


