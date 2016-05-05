labbe.rma <-
function (x, xlim, ylim, xlab, ylab, add = x$add, to = x$to, 
    transf, targs, pch = 21, psize, bg = "gray", ...) 
{
    if (!is.element("rma", class(x))) 
        stop("Argument 'x' must be an object of class \"rma\".")
    if (is.element("robust.rma", class(x))) 
        stop("Function not applicable to objects of class \"robust.rma\".")
    if (!x$int.only) 
        stop("L'Abbe plot only applicable for models without moderators.")
    if (!is.element(x$measure, c("RR", "OR", "RD", "AS", "IRR", 
        "IRD", "IRSD"))) 
        stop("Argument 'measure' must be one of the following: 'RR','OR','RD','AS','IRR','IRD','IRSD'.")
    na.act <- getOption("na.action")
    if (!is.element(na.act, c("na.omit", "na.exclude", "na.fail", 
        "na.pass"))) 
        stop("Unknown 'na.action' specified under options().")
    if (length(add) == 2) 
        add <- add[1]
    if (length(to) == 2) 
        to <- to[1]
    if (!is.element(to, c("all", "only0", "if0all", "none"))) 
        stop("Unknown 'to' argument specified.")
    if (missing(transf)) 
        transf <- FALSE
    transf.char <- deparse(substitute(transf))
    if (missing(targs)) 
        targs <- NULL
    if (missing(psize)) 
        psize <- NULL
    k <- x$k.f
    if (length(pch) == 1L) 
        pch <- rep(pch, k)
    if (length(pch) != k) 
        stop("Number of tables does not correspond to the length of the 'pch' argument.")
    if (!is.null(psize)) {
        if (length(psize) == 1L) 
            psize <- rep(psize, k)
        if (length(psize) != k) 
            stop("Number of tables does not correspond to the length of the 'psize' argument.")
    }
    if (length(bg) == 1L) 
        bg <- rep(bg, k)
    if (length(bg) != k) 
        stop("Number of tables does not correspond to the length of the 'bg' argument.")
    ai <- x$ai.f
    bi <- x$bi.f
    ci <- x$ci.f
    di <- x$di.f
    x1i <- x$x1i.f
    x2i <- x$x2i.f
    t1i <- x$t1i.f
    t2i <- x$t2i.f
    yi.is.na <- is.na(x$yi.f)
    ai[yi.is.na] <- NA
    bi[yi.is.na] <- NA
    ci[yi.is.na] <- NA
    di[yi.is.na] <- NA
    x1i[yi.is.na] <- NA
    x2i[yi.is.na] <- NA
    t1i[yi.is.na] <- NA
    t2i[yi.is.na] <- NA
    options(na.action = "na.pass")
    if (x$measure == "RR") {
        measure <- "PLN"
        dat.t <- escalc(measure = measure, xi = ai, mi = bi, 
            add = add, to = to)
        dat.c <- escalc(measure = measure, xi = ci, mi = di, 
            add = add, to = to)
    }
    if (x$measure == "OR") {
        measure <- "PLO"
        dat.t <- escalc(measure = measure, xi = ai, mi = bi, 
            add = add, to = to)
        dat.c <- escalc(measure = measure, xi = ci, mi = di, 
            add = add, to = to)
    }
    if (x$measure == "RD") {
        measure <- "PR"
        dat.t <- escalc(measure = measure, xi = ai, mi = bi, 
            add = add, to = to)
        dat.c <- escalc(measure = measure, xi = ci, mi = di, 
            add = add, to = to)
    }
    if (x$measure == "AS") {
        measure <- "PAS"
        dat.t <- escalc(measure = measure, xi = ai, mi = bi, 
            add = add, to = to)
        dat.c <- escalc(measure = measure, xi = ci, mi = di, 
            add = add, to = to)
    }
    if (x$measure == "IRR") {
        measure <- "IRLN"
        dat.t <- escalc(measure = measure, xi = x1i, ti = t1i, 
            add = add, to = to)
        dat.c <- escalc(measure = measure, xi = x2i, ti = t2i, 
            add = add, to = to)
    }
    if (x$measure == "IRD") {
        measure <- "IR"
        dat.t <- escalc(measure = measure, xi = x1i, ti = t1i, 
            add = add, to = to)
        dat.c <- escalc(measure = measure, xi = x2i, ti = t2i, 
            add = add, to = to)
    }
    if (x$measure == "IRSD") {
        measure <- dat.t <- escalc(measure = measure, xi = x1i, 
            ti = t1i, add = add, to = to)
        dat.c <- escalc(measure = measure, xi = x2i, ti = t2i, 
            add = add, to = to)
    }
    options(na.action = na.act)
    dat.t.dat.c.na <- apply(is.na(dat.t), 1, any) | apply(is.na(dat.c), 
        1, any)
    if (any(dat.t.dat.c.na)) {
        not.na <- !dat.t.dat.c.na
        dat.t <- dat.t[not.na, ]
        dat.c <- dat.c[not.na, ]
    }
    if (length(dat.t$yi) == 0 || length(dat.c$yi) == 0) 
        stop("No information in object to compute arm-level outcomes.")
    if (is.null(psize)) {
        vi <- dat.t$vi + dat.c$vi
        wi <- 1/sqrt(vi)
        psize <- 0.5 + 3 * (wi - min(wi))/(max(wi) - min(wi))
    }
    min.yi <- min(c(dat.t$yi, dat.c$yi))
    max.yi <- max(c(dat.t$yi, dat.c$yi))
    rng.yi <- max.yi - min.yi
    len <- 1000
    if (x$measure == "RD") 
        c.vals <- seq(ifelse(x$b > 0, 0, -x$b), ifelse(x$b > 
            0, 1 - x$b, 1), length.out = len)
    if (x$measure == "RR") 
        c.vals <- seq(min.yi - rng.yi, ifelse(x$b > 0, 0 - x$b, 
            0), length.out = len)
    if (x$measure == "OR") 
        c.vals <- seq(min.yi - rng.yi, max.yi + rng.yi, length.out = len)
    if (x$measure == "AS") 
        c.vals <- seq(ifelse(x$b > 0, 0, -x$b), ifelse(x$b > 
            0, asin(sqrt(1)) - x$b, asin(sqrt(1))), length.out = len)
    if (x$measure == "IRR") 
        c.vals <- seq(min.yi - rng.yi, ifelse(x$b > 0, 0 - x$b, 
            0), length.out = len)
    if (x$measure == "IRD") 
        c.vals <- seq(ifelse(x$b > 0, 0, -x$b), ifelse(x$b > 
            0, 1 - x$b, 1), length.out = len)
    if (x$measure == "IRSD") 
        c.vals <- seq(ifelse(x$b > 0, 0, -x$b), ifelse(x$b > 
            0, 1 - x$b, 1), length.out = len)
    t.vals <- x$b + 1 * c.vals
    if (is.function(transf)) {
        if (is.null(targs)) {
            dat.t$yi <- sapply(dat.t$yi, transf)
            dat.c$yi <- sapply(dat.c$yi, transf)
            c.vals <- sapply(c.vals, transf)
            t.vals <- sapply(t.vals, transf)
        }
        else {
            dat.t$yi <- sapply(dat.t$yi, transf, targs)
            dat.c$yi <- sapply(dat.c$yi, transf, targs)
            c.vals <- sapply(c.vals, transf, targs)
            t.vals <- sapply(t.vals, transf, targs)
        }
    }
    min.yi <- min(c(dat.t$yi, dat.c$yi))
    max.yi <- max(c(dat.t$yi, dat.c$yi))
    if (missing(xlim)) 
        xlim <- c(min.yi, max.yi)
    if (missing(ylim)) 
        ylim <- c(min.yi, max.yi)
    order.vec <- order(psize, decreasing = TRUE)
    dat.t$yi <- dat.t$yi[order.vec]
    dat.c$yi <- dat.c$yi[order.vec]
    psize <- psize[order.vec]
    pch <- pch[order.vec]
    if (missing(xlab)) {
        xlab <- .setlab(measure, transf.char, atransf.char = "FALSE", 
            gentype = 1)
        xlab <- paste(xlab, "(Group 1)")
    }
    if (missing(ylab)) {
        ylab <- .setlab(measure, transf.char, atransf.char = "FALSE", 
            gentype = 1)
        ylab <- paste(ylab, "(Group 2)")
    }
    plot(NA, NA, xlim = xlim, ylim = ylim, xlab = xlab, ylab = ylab, 
        cex = psize, pch = pch, bg = bg, ...)
    abline(a = 0, b = 1, ...)
    lines(c.vals, t.vals, lty = "dashed", ...)
    points(dat.c$yi, dat.t$yi, cex = psize, pch = pch, bg = bg, 
        ...)
    invisible()
}
