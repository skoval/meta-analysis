cumul.rma.mh <-
function (x, order, digits, transf, targs, ...) 
{
    if (!is.element("rma.mh", class(x))) 
        stop("Argument 'x' must be an object of class \"rma.mh\".")
    na.act <- getOption("na.action")
    if (!is.element(na.act, c("na.omit", "na.exclude", "na.fail", 
        "na.pass"))) 
        stop("Unknown 'na.action' specified under options().")
    if (missing(order)) 
        order <- NULL
    if (missing(digits)) 
        digits <- x$digits
    if (missing(transf)) 
        transf <- FALSE
    if (missing(targs)) 
        targs <- NULL
    if (is.null(order)) 
        order <- seq_len(x$k.f)
    ai.f <- x$ai.f[order]
    bi.f <- x$bi.f[order]
    ci.f <- x$ci.f[order]
    di.f <- x$di.f[order]
    x1i.f <- x$x1i.f[order]
    x2i.f <- x$x2i.f[order]
    t1i.f <- x$t1i.f[order]
    t2i.f <- x$t2i.f[order]
    yi.f <- x$yi.f[order]
    vi.f <- x$vi.f[order]
    not.na <- x$not.na[order]
    slab <- x$slab[order]
    o.warn <- getOption("warn")
    on.exit(options(warn = o.warn))
    options(warn = -1)
    b <- rep(NA_real_, x$k.f)
    se <- rep(NA_real_, x$k.f)
    zval <- rep(NA_real_, x$k.f)
    pval <- rep(NA_real_, x$k.f)
    ci.lb <- rep(NA_real_, x$k.f)
    ci.ub <- rep(NA_real_, x$k.f)
    QE <- rep(NA_real_, x$k.f)
    QEp <- rep(NA_real_, x$k.f)
    for (i in seq_len(x$k.f)[not.na]) {
        if (is.element(x$measure, c("RR", "OR", "RD"))) {
            res <- try(suppressWarnings(rma.mh(ai = ai.f[seq_len(i)], 
                bi = bi.f[seq_len(i)], ci = ci.f[seq_len(i)], 
                di = di.f[seq_len(i)], measure = x$measure, add = x$add, 
                to = x$to, drop00 = x$drop00, correct = x$correct)), 
                silent = TRUE)
        }
        else {
            res <- try(suppressWarnings(rma.mh(x1i = x1i.f[seq_len(i)], 
                x2i = x2i.f[seq_len(i)], t1i = t1i.f[seq_len(i)], 
                t2i = t2i.f[seq_len(i)], measure = x$measure, 
                add = x$add, to = x$to, drop00 = x$drop00, correct = x$correct)), 
                silent = TRUE)
        }
        if (inherits(res, "try-error")) 
            next
        b[i] <- res$b
        se[i] <- res$se
        zval[i] <- res$zval
        pval[i] <- res$pval
        ci.lb[i] <- res$ci.lb
        ci.ub[i] <- res$ci.ub
        QE[i] <- res$QE
        QEp[i] <- res$QEp
    }
    alpha <- ifelse(x$level > 1, (100 - x$level)/100, 1 - x$level)
    crit <- qnorm(alpha/2, lower.tail = FALSE)
    b[1] <- yi.f[1]
    se[1] <- sqrt(vi.f[1])
    zval[1] <- yi.f[1]/se[1]
    pval[1] <- 2 * pnorm(abs(zval[1]), lower.tail = FALSE)
    ci.lb[1] <- yi.f[1] - crit * se[1]
    ci.ub[1] <- yi.f[1] + crit * se[1]
    QE[1] <- 0
    QEp[1] <- 1
    if (is.logical(transf) && transf && is.element(x$measure, 
        c("OR", "RR", "IRR"))) 
        transf <- exp
    if (is.function(transf)) {
        if (is.null(targs)) {
            b <- sapply(b, transf)
            se <- rep(NA, x$k.f)
            ci.lb <- sapply(ci.lb, transf)
            ci.ub <- sapply(ci.ub, transf)
        }
        else {
            b <- sapply(b, transf, targs)
            se <- rep(NA, x$k.f)
            ci.lb <- sapply(ci.lb, transf, targs)
            ci.ub <- sapply(ci.ub, transf, targs)
        }
        transf <- TRUE
    }
    if (na.act == "na.omit") {
        out <- list(estimate = b[not.na], se = se[not.na], zval = zval[not.na], 
            pval = pval[not.na], ci.lb = ci.lb[not.na], ci.ub = ci.ub[not.na], 
            QE = QE[not.na], QEp = QEp[not.na])
        out$slab <- slab[not.na]
    }
    if (na.act == "na.exclude" || na.act == "na.pass") {
        out <- list(estimate = b, se = se, zval = zval, pval = pval, 
            ci.lb = ci.lb, ci.ub = ci.ub, QE = QE, QEp = QEp)
        out$slab <- slab
    }
    if (na.act == "na.fail" && any(!x$not.na)) 
        stop("Missing values in results.")
    out$digits <- digits
    out$transf <- transf
    out$slab.null <- x$slab.null
    out$level <- x$level
    out$measure <- x$measure
    out$knha <- x$knha
    if (x$measure == "GEN") {
        attr(out$estimate, "measure") <- "GEN"
    }
    else {
        attr(out$estimate, "measure") <- x$measure
    }
    class(out) <- c("list.rma", "cumul.rma")
    return(out)
}
