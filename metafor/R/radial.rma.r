radial.rma <-
function (x, center = FALSE, xlim = NULL, zlim, xlab, zlab, atz, 
    aty, steps = 7, level = x$level, digits = 2, back = "lightgray", 
    transf, targs, pch = 19, arc.res = 100, cex, ...) 
{
    if (!is.element("rma", class(x))) 
        stop("Argument 'x' must be an object of class \"rma\".")
    if (is.element("robust.rma", class(x))) 
        stop("Function not applicable to objects of class \"robust.rma\".")
    if (missing(transf)) 
        transf <- FALSE
    if (missing(targs)) 
        targs <- NULL
    if (missing(atz)) 
        atz <- NULL
    if (missing(aty)) 
        aty <- NULL
    if (x$int.only) {
        yi <- x$yi
        yi.c <- yi
        vi <- x$vi
        b <- c(x$b)
        ci.lb <- x$ci.lb
        ci.ub <- x$ci.ub
        tau2 <- 1/mean(1/x$tau2)
        if (is.null(aty)) {
            atyis <- range(yi)
        }
        else {
            atyis <- range(aty)
            aty.c <- aty
        }
    }
    else {
        stop("Radial plots only applicable for models without moderators.")
    }
    if (center) {
        yi <- yi - x$b
        b <- 0
        ci.lb <- ci.lb - x$b
        ci.ub <- ci.ub - x$b
        atyis <- atyis - x$b
        if (!is.null(aty)) 
            aty <- aty - x$b
    }
    alpha <- ifelse(level > 1, (100 - level)/100, 1 - level)
    zcrit <- qnorm(alpha/2, lower.tail = FALSE)
    zi <- yi/sqrt(vi + tau2)
    xi <- 1/sqrt(vi + tau2)
    if (missing(xlim)) {
        xlims <- c(0, (1.3 * max(xi)))
    }
    else {
        xlims <- sort(xlim)
    }
    ci.xpos <- xlims[2] + 0.12 * (xlims[2] - xlims[1])
    ya.xpos <- xlims[2] + 0.14 * (xlims[2] - xlims[1])
    xaxismax <- xlims[2]
    if (missing(zlim)) {
        zlims <- c(min(-5, 1.1 * min(zi), 1.1 * ci.lb * ci.xpos, 
            1.1 * min(atyis) * ya.xpos, 1.1 * min(yi) * ya.xpos, 
            -1.1 * zcrit + xaxismax * b), max(5, 1.1 * max(zi), 
            1.1 * ci.ub * ci.xpos, 1.1 * max(atyis) * ya.xpos, 
            1.1 * max(yi) * ya.xpos, 1.1 * zcrit + xaxismax * 
                b))
    }
    else {
        zlims <- sort(zlim)
    }
    par.mar <- par("mar")
    par.mar.adj <- par.mar - c(0, -3, 0, -5)
    par.mar.adj[par.mar.adj < 1] <- 1
    par(mar = par.mar.adj)
    on.exit(par(mar = par.mar))
    if (missing(xlab)) {
        if (x$method == "FE") {
            xlab <- expression(x[i] == 1/sqrt(v[i]), ...)
        }
        else {
            xlab <- expression(x[i] == 1/sqrt(v[i] + tau^2), 
                ...)
        }
    }
    par.pty <- par("pty")
    par(pty = "s")
    on.exit(par(pty = par.pty), add = TRUE)
    plot(NA, NA, ylim = zlims, xlim = xlims, bty = "n", xaxt = "n", 
        yaxt = "n", xlab = xlab, ylab = "", xaxs = "i", yaxs = "i", 
        ...)
    if (missing(cex)) 
        cex <- par("cex")
    polygon(c(0, xaxismax, xaxismax, 0), c(zcrit, zcrit + xaxismax * 
        b, -zcrit + xaxismax * b, -zcrit), border = NA, col = back, 
        ...)
    segments(0, 0, xaxismax, xaxismax * b, lty = "solid", ...)
    segments(0, -zcrit, xaxismax, -zcrit + xaxismax * b, lty = "dotted", 
        ...)
    segments(0, zcrit, xaxismax, zcrit + xaxismax * b, lty = "dotted", 
        ...)
    axis(side = 1, ...)
    if (is.null(atz)) {
        axis(side = 2, at = seq(-4, 4, length = 9), labels = NA, 
            las = 1, tcl = par("tcl")/2, ...)
        axis(side = 2, at = seq(-2, 2, length = 3), las = 1, 
            ...)
    }
    else {
        axis(side = 2, at = atz, labels = atz, las = 1, ...)
    }
    if (missing(zlab)) {
        if (center) {
            if (x$method == "FE") {
                mtext(expression(z[i] == frac(y[i] - hat(theta), 
                  sqrt(v[i]))), side = 2, line = par.mar.adj[2] - 
                  1, at = 0, adj = 0, las = 1, cex = cex, ...)
            }
            else {
                mtext(expression(z[i] == frac(y[i] - hat(mu), 
                  sqrt(v[i] + tau^2))), side = 2, line = par.mar.adj[2] - 
                  1, adj = 0, at = 0, las = 1, cex = cex, ...)
            }
        }
        else {
            if (x$method == "FE") {
                mtext(expression(z[i] == frac(y[i], sqrt(v[i]))), 
                  side = 2, line = par.mar.adj[2] - 2, at = 0, 
                  adj = 0, las = 1, cex = cex, ...)
            }
            else {
                mtext(expression(z[i] == frac(y[i], sqrt(v[i] + 
                  tau^2))), side = 2, line = par.mar.adj[2] - 
                  1, at = 0, adj = 0, las = 1, cex = cex, ...)
            }
        }
    }
    else {
        mtext(zlab, side = 2, line = par.mar.adj[2] - 4, at = 0, 
            cex = cex, ...)
    }
    par.xpd <- par("xpd")
    par(xpd = TRUE)
    par.usr <- par("usr")
    asp.rat <- (par.usr[4] - par.usr[3])/(par.usr[2] - par.usr[1])
    if (length(arc.res) == 1L) 
        arc.res <- c(arc.res, arc.res/4)
    if (is.null(aty)) {
        atyis <- seq(min(yi), max(yi), length = arc.res[1])
    }
    else {
        atyis <- seq(min(aty), max(aty), length = arc.res[1])
    }
    len <- ya.xpos
    xis <- rep(NA_real_, length(atyis))
    zis <- rep(NA_real_, length(atyis))
    for (i in seq_len(length(atyis))) {
        xis[i] <- sqrt(len^2/(1 + (atyis[i]/asp.rat)^2))
        zis[i] <- xis[i] * atyis[i]
    }
    valid <- zis > zlims[1] & zis < zlims[2]
    lines(xis[valid], zis[valid], ...)
    if (is.null(aty)) {
        atyis <- seq(min(yi), max(yi), length = steps)
    }
    else {
        atyis <- aty
    }
    len.l <- ya.xpos
    len.u <- ya.xpos + 0.015 * (xlims[2] - xlims[1])
    xis.l <- rep(NA_real_, length(atyis))
    zis.l <- rep(NA_real_, length(atyis))
    xis.u <- rep(NA_real_, length(atyis))
    zis.u <- rep(NA_real_, length(atyis))
    for (i in seq_len(length(atyis))) {
        xis.l[i] <- sqrt(len.l^2/(1 + (atyis[i]/asp.rat)^2))
        zis.l[i] <- xis.l[i] * atyis[i]
        xis.u[i] <- sqrt(len.u^2/(1 + (atyis[i]/asp.rat)^2))
        zis.u[i] <- xis.u[i] * atyis[i]
    }
    valid <- zis.l > zlims[1] & zis.u > zlims[1] & zis.l < zlims[2] & 
        zis.u < zlims[2]
    if (any(valid)) 
        segments(xis.l[valid], zis.l[valid], xis.u[valid], (xis.u * 
            atyis)[valid], ...)
    if (is.null(aty)) {
        atyis <- seq(min(yi), max(yi), length = steps)
        atyis.lab <- seq(min(yi.c), max(yi.c), length = steps)
    }
    else {
        atyis <- aty
        atyis.lab <- aty.c
    }
    len <- ya.xpos + 0.02 * (xlims[2] - xlims[1])
    xis <- rep(NA_real_, length(atyis))
    zis <- rep(NA_real_, length(atyis))
    for (i in seq_len(length(atyis))) {
        xis[i] <- sqrt(len^2/(1 + (atyis[i]/asp.rat)^2))
        zis[i] <- xis[i] * atyis[i]
    }
    if (is.function(transf)) {
        if (is.null(targs)) {
            atyis.lab <- sapply(atyis.lab, transf)
        }
        else {
            atyis.lab <- sapply(atyis.lab, transf, targs)
        }
    }
    valid <- zis > zlims[1] & zis < zlims[2]
    if (any(valid)) 
        text(xis[valid], zis[valid], formatC(atyis.lab[valid], 
            digits = digits, format = "f"), pos = 4, cex = cex, 
            ...)
    atyis <- seq(ci.lb, ci.ub, length = arc.res[2])
    len <- ci.xpos
    xis <- rep(NA_real_, length(atyis))
    zis <- rep(NA_real_, length(atyis))
    for (i in seq_len(length(atyis))) {
        xis[i] <- sqrt(len^2/(1 + (atyis[i]/asp.rat)^2))
        zis[i] <- xis[i] * atyis[i]
    }
    valid <- zis > zlims[1] & zis < zlims[2]
    if (any(valid)) 
        lines(xis[valid], zis[valid], ...)
    atyis <- c(ci.lb, b, ci.ub)
    len.l <- ci.xpos - 0.007 * (xlims[2] - xlims[1])
    len.u <- ci.xpos + 0.007 * (xlims[2] - xlims[1])
    xis.l <- rep(NA_real_, 3)
    zis.l <- rep(NA_real_, 3)
    xis.u <- rep(NA_real_, 3)
    zis.u <- rep(NA_real_, 3)
    for (i in seq_len(length(atyis))) {
        xis.l[i] <- sqrt(len.l^2/(1 + (atyis[i]/asp.rat)^2))
        zis.l[i] <- xis.l[i] * atyis[i]
        xis.u[i] <- sqrt(len.u^2/(1 + (atyis[i]/asp.rat)^2))
        zis.u[i] <- xis.u[i] * atyis[i]
    }
    valid <- zis.l > zlims[1] & zis.u > zlims[1] & zis.l < zlims[2] & 
        zis.u < zlims[2]
    if (any(valid)) 
        segments(xis.l[valid], zis.l[valid], xis.u[valid], (xis.u * 
            atyis)[valid], ...)
    par(xpd = par.xpd)
    points(xi, zi, pch = pch, cex = cex, ...)
    invisible(data.frame(x = xi, y = zi, slab = x$slab[x$not.na]))
}
