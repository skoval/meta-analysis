rma.mh <-
function (ai, bi, ci, di, n1i, n2i, x1i, x2i, t1i, t2i, measure = "OR", 
    data, slab, subset, add = 1/2, to = "only0", drop00 = TRUE, 
    correct = TRUE, level = 95, digits = 4, verbose = FALSE) 
{
    if (!is.element(measure, c("OR", "RR", "RD", "IRR", "IRD"))) 
        stop("Mantel-Haenszel method can only be used with measures OR, RR, RD, IRR, and IRD.")
    if (length(add) == 1) 
        add <- c(add, 0)
    if (length(add) != 2) 
        stop("Argument 'add' should specify one or two values (see 'help(rma.mh)').")
    if (length(to) == 1) 
        to <- c(to, "none")
    if (length(to) != 2) 
        stop("Argument 'to' should specify one or two values (see 'help(rma.mh)').")
    if (length(drop00) == 1) 
        drop00 <- c(drop00, FALSE)
    if (length(drop00) != 2) 
        stop("Argument 'drop00' should specify one or two values (see 'help(rma.mh)').")
    na.act <- getOption("na.action")
    if (!is.element(na.act, c("na.omit", "na.exclude", "na.fail", 
        "na.pass"))) 
        stop("Unknown 'na.action' specified under options().")
    if (!is.element(to[1], c("all", "only0", "if0all", "none"))) 
        stop("Unknown 'to' argument specified.")
    if (!is.element(to[2], c("all", "only0", "if0all", "none"))) 
        stop("Unknown 'to' argument specified.")
    if (verbose) 
        message("Extracting data and computing yi/vi values ...")
    if (missing(data)) 
        data <- NULL
    if (is.null(data)) {
        data <- sys.frame(sys.parent())
    }
    else {
        if (!is.data.frame(data)) {
            data <- data.frame(data)
        }
    }
    mf <- match.call()
    mf.slab <- mf[[match("slab", names(mf))]]
    mf.subset <- mf[[match("subset", names(mf))]]
    slab <- eval(mf.slab, data, enclos = sys.frame(sys.parent()))
    subset <- eval(mf.subset, data, enclos = sys.frame(sys.parent()))
    if (is.element(measure, c("RR", "OR", "RD"))) {
        x1i <- x2i <- t1i <- t2i <- x1i.f <- x2i.f <- t1i.f <- t2i.f <- NA
        mf.ai <- mf[[match("ai", names(mf))]]
        mf.bi <- mf[[match("bi", names(mf))]]
        mf.ci <- mf[[match("ci", names(mf))]]
        mf.di <- mf[[match("di", names(mf))]]
        mf.n1i <- mf[[match("n1i", names(mf))]]
        mf.n2i <- mf[[match("n2i", names(mf))]]
        ai <- eval(mf.ai, data, enclos = sys.frame(sys.parent()))
        bi <- eval(mf.bi, data, enclos = sys.frame(sys.parent()))
        ci <- eval(mf.ci, data, enclos = sys.frame(sys.parent()))
        di <- eval(mf.di, data, enclos = sys.frame(sys.parent()))
        n1i <- eval(mf.n1i, data, enclos = sys.frame(sys.parent()))
        n2i <- eval(mf.n2i, data, enclos = sys.frame(sys.parent()))
        if (is.null(bi)) 
            bi <- n1i - ai
        if (is.null(di)) 
            di <- n2i - ci
        ni <- ai + bi + ci + di
        k <- length(ai)
        ids <- seq_len(k)
        if (verbose) 
            message("Generating/extracting study labels ...")
        if (is.null(slab)) {
            slab.null <- TRUE
            slab <- ids
        }
        else {
            if (anyNA(slab)) 
                stop("NAs in study labels.")
            if (length(slab) != k) 
                stop("Study labels not of same length as data.")
            slab.null <- FALSE
        }
        if (!is.null(subset)) {
            if (verbose) 
                message("Subsetting ...")
            ai <- ai[subset]
            bi <- bi[subset]
            ci <- ci[subset]
            di <- di[subset]
            ni <- ni[subset]
            slab <- slab[subset]
            ids <- ids[subset]
            k <- length(ai)
        }
        if (anyDuplicated(slab)) 
            slab <- make.unique(as.character(slab))
        dat <- escalc(measure = measure, ai = ai, bi = bi, ci = ci, 
            di = di, add = add[1], to = to[1], drop00 = drop00[1])
        yi <- dat$yi
        vi <- dat$vi
        if (drop00[2]) {
            id00 <- c(ai == 0L & ci == 0L) | c(bi == 0L & di == 
                0L)
            id00[is.na(id00)] <- FALSE
            ai[id00] <- NA
            bi[id00] <- NA
            ci[id00] <- NA
            di[id00] <- NA
        }
        ai.f <- ai
        bi.f <- bi
        ci.f <- ci
        di.f <- di
        yi.f <- yi
        vi.f <- vi
        ni.f <- ni
        k.f <- k
        aibicidi.na <- is.na(ai) | is.na(bi) | is.na(ci) | is.na(di)
        if (any(aibicidi.na)) {
            if (verbose) 
                message("Handling NAs in table data ...")
            not.na <- !aibicidi.na
            if (na.act == "na.omit" || na.act == "na.exclude" || 
                na.act == "na.pass") {
                ai <- ai[not.na]
                bi <- bi[not.na]
                ci <- ci[not.na]
                di <- di[not.na]
                k <- length(ai)
                warning("Tables with NAs omitted from model fitting.")
            }
            if (na.act == "na.fail") 
                stop("Missing values in tables.")
        }
        else {
            not.na <- rep(TRUE, k)
        }
        if (k < 1) 
            stop("Processing terminated since k = 0.")
        yivi.na <- is.na(yi) | is.na(vi)
        if (any(yivi.na)) {
            if (verbose) 
                message("Handling NAs in yi/vi ...")
            not.na.yivi <- !yivi.na
            if (na.act == "na.omit" || na.act == "na.exclude" || 
                na.act == "na.pass") {
                yi <- yi[not.na.yivi]
                vi <- vi[not.na.yivi]
                ni <- ni[not.na.yivi]
                warning("Some yi/vi values are NA.")
                attr(yi, "measure") <- measure
                attr(yi, "ni") <- ni
            }
            if (na.act == "na.fail") 
                stop("Missing yi/vi values.")
        }
        else {
            not.na.yivi <- rep(TRUE, k)
        }
        k.yi <- length(yi)
        if (to[2] == "all") {
            ai <- ai + add[2]
            bi <- bi + add[2]
            ci <- ci + add[2]
            di <- di + add[2]
        }
        if (to[2] == "only0") {
            id0 <- c(ai == 0L | bi == 0L | ci == 0L | di == 0L)
            ai[id0] <- ai[id0] + add[2]
            bi[id0] <- bi[id0] + add[2]
            ci[id0] <- ci[id0] + add[2]
            di[id0] <- di[id0] + add[2]
        }
        if (to[2] == "if0all") {
            id0 <- c(ai == 0L | bi == 0L | ci == 0L | di == 0L)
            if (any(id0)) {
                ai <- ai + add[2]
                bi <- bi + add[2]
                ci <- ci + add[2]
                di <- di + add[2]
            }
        }
        n1i <- ai + bi
        n2i <- ci + di
        Ni <- ai + bi + ci + di
    }
    if (is.element(measure, c("IRR", "IRD"))) {
        ai <- bi <- ci <- di <- ai.f <- bi.f <- ci.f <- di.f <- NA
        mf.x1i <- mf[[match("x1i", names(mf))]]
        mf.x2i <- mf[[match("x2i", names(mf))]]
        mf.t1i <- mf[[match("t1i", names(mf))]]
        mf.t2i <- mf[[match("t2i", names(mf))]]
        x1i <- eval(mf.x1i, data, enclos = sys.frame(sys.parent()))
        x2i <- eval(mf.x2i, data, enclos = sys.frame(sys.parent()))
        t1i <- eval(mf.t1i, data, enclos = sys.frame(sys.parent()))
        t2i <- eval(mf.t2i, data, enclos = sys.frame(sys.parent()))
        ni <- t1i + t2i
        k <- length(x1i)
        ids <- seq_len(k)
        if (verbose) 
            message("Generating/extracting study labels ...")
        if (is.null(slab)) {
            slab.null <- TRUE
            slab <- ids
        }
        else {
            if (anyNA(slab)) 
                stop("NAs in study labels.")
            if (length(slab) != k) 
                stop("Study labels not of same length as data.")
            slab.null <- FALSE
        }
        if (!is.null(subset)) {
            if (verbose) 
                message("Subsetting ...")
            x1i <- x1i[subset]
            x2i <- x2i[subset]
            t1i <- t1i[subset]
            t2i <- t2i[subset]
            ni <- ni[subset]
            slab <- slab[subset]
            ids <- ids[subset]
            k <- length(x1i)
        }
        if (anyDuplicated(slab)) 
            slab <- make.unique(as.character(slab))
        dat <- escalc(measure = measure, x1i = x1i, x2i = x2i, 
            t1i = t1i, t2i = t2i, add = add[1], to = to[1], drop00 = drop00[1])
        yi <- dat$yi
        vi <- dat$vi
        if (drop00[2]) {
            id00 <- c(x1i == 0L & x2i == 0L)
            id00[is.na(id00)] <- FALSE
            x1i[id00] <- NA
            x2i[id00] <- NA
        }
        x1i.f <- x1i
        x2i.f <- x2i
        t1i.f <- t1i
        t2i.f <- t2i
        yi.f <- yi
        vi.f <- vi
        ni.f <- ni
        k.f <- k
        x1ix2it1it2i.na <- is.na(x1i) | is.na(x2i) | is.na(t1i) | 
            is.na(t2i)
        if (any(x1ix2it1it2i.na)) {
            if (verbose) 
                message("Handling NAs in table data ...")
            not.na <- !x1ix2it1it2i.na
            if (na.act == "na.omit" || na.act == "na.exclude" || 
                na.act == "na.pass") {
                x1i <- x1i[not.na]
                x2i <- x2i[not.na]
                t1i <- t1i[not.na]
                t2i <- t2i[not.na]
                k <- length(x1i)
                warning("Tables with NAs omitted from model fitting.")
            }
            if (na.act == "na.fail") 
                stop("Missing values in tables.")
        }
        else {
            not.na <- rep(TRUE, k)
        }
        if (k < 1) 
            stop("Processing terminated since k = 0.")
        yivi.na <- is.na(yi) | is.na(vi)
        if (any(yivi.na)) {
            if (verbose) 
                message("Handling NAs in yi/vi ...")
            not.na.yivi <- !yivi.na
            if (na.act == "na.omit" || na.act == "na.exclude" || 
                na.act == "na.pass") {
                yi <- yi[not.na.yivi]
                vi <- vi[not.na.yivi]
                ni <- ni[not.na.yivi]
                warning("Some yi/vi values are NA.")
                attr(yi, "measure") <- measure
                attr(yi, "ni") <- ni
            }
            if (na.act == "na.fail") 
                stop("Missing yi/vi values.")
        }
        else {
            not.na.yivi <- rep(TRUE, k)
        }
        k.yi <- length(yi)
        if (to[2] == "all") {
            x1i <- x1i + add[2]
            x2i <- x2i + add[2]
        }
        if (to[2] == "only0") {
            id0 <- c(x1i == 0L | x2i == 0L)
            x1i[id0] <- x1i[id0] + add[2]
            x2i[id0] <- x2i[id0] + add[2]
        }
        if (to[2] == "if0all") {
            id0 <- c(x1i == 0L | x2i == 0L)
            if (any(id0)) {
                x1i <- x1i + add[2]
                x2i <- x2i + add[2]
            }
        }
        Ti <- t1i + t2i
    }
    alpha <- ifelse(level > 1, (100 - level)/100, 1 - level)
    CO <- COp <- MH <- MHp <- BD <- BDp <- TA <- TAp <- k.pos <- NA
    if (verbose) 
        message("Model fitting ...")
    if (measure == "OR") {
        Pi <- ai/Ni + di/Ni
        Qi <- bi/Ni + ci/Ni
        Ri <- (ai/Ni) * di
        Si <- (bi/Ni) * ci
        R <- sum(Ri)
        S <- sum(Si)
        if (identical(R, 0) || identical(S, 0)) {
            b.exp <- NA
            b <- NA
            se <- NA
            zval <- NA
            pval <- NA
            ci.lb <- NA
            ci.ub <- NA
        }
        else {
            b.exp <- R/S
            b <- log(b.exp)
            se <- sqrt(1/2 * (sum(Pi * Ri)/R^2 + sum(Pi * Si + 
                Qi * Ri)/(R * S) + sum(Qi * Si)/S^2))
            zval <- b/se
            pval <- 2 * pnorm(abs(zval), lower.tail = FALSE)
            ci.lb <- b - qnorm(alpha/2, lower.tail = FALSE) * 
                se
            ci.ub <- b + qnorm(alpha/2, lower.tail = FALSE) * 
                se
        }
        names(b) <- "intrcpt"
        vb <- matrix(se^2, dimnames = list("intrcpt", "intrcpt"))
        xt <- ai + ci
        yt <- bi + di
        if (identical(sum(xt), 0) || identical(sum(yt), 0)) {
            CO <- NA
            COp <- NA
            MH <- NA
            MHp <- NA
        }
        else {
            CO <- sum(ai - (n1i/Ni) * xt)^2/sum((n1i/Ni) * (n2i/Ni) * 
                (xt * (yt/Ni)))
            COp <- pchisq(CO, df = 1, lower.tail = FALSE)
            MH <- (abs(sum(ai - (n1i/Ni) * xt)) - ifelse(correct, 
                0.5, 0))^2/sum((n1i/Ni) * (n2i/Ni) * (xt * (yt/(Ni - 
                1))))
            MHp <- pchisq(MH, df = 1, lower.tail = FALSE)
        }
        if (is.na(b)) {
            BD <- NA
            TA <- NA
            BDp <- NA
            TAp <- NA
            k.pos <- 0
        }
        else {
            if (identical(b.exp, 1)) {
                N11 <- (n1i/Ni) * xt
            }
            else {
                A <- b.exp * (n1i + xt) + (n2i - xt)
                B <- sqrt(A^2 - 4 * n1i * xt * b.exp * (b.exp - 
                  1))
                N11 <- (A - B)/(2 * (b.exp - 1))
            }
            pos <- (N11 > 0) & (xt > 0) & (yt > 0)
            k.pos <- sum(pos)
            N11 <- N11[pos]
            N12 <- n1i[pos] - N11
            N21 <- xt[pos] - N11
            N22 <- N11 - n1i[pos] - xt[pos] + Ni[pos]
            BD <- sum((ai[pos] - N11)^2/(1/N11 + 1/N12 + 1/N21 + 
                1/N22)^(-1))
            TA <- BD - sum(ai[pos] - N11)^2/sum((1/N11 + 1/N12 + 
                1/N21 + 1/N22)^(-1))
            if (k.pos > 1) {
                BDp <- pchisq(BD, df = k.pos - 1, lower.tail = FALSE)
                TAp <- pchisq(TA, df = k.pos - 1, lower.tail = FALSE)
            }
            else {
                BDp <- NA
                TAp <- NA
            }
        }
    }
    if (measure == "RR") {
        R <- sum(ai * (n2i/Ni))
        S <- sum(ci * (n1i/Ni))
        if (identical(sum(ai), 0) || identical(sum(ci), 0)) {
            b.exp <- NA
            b <- NA
            se <- NA
            zval <- NA
            pval <- NA
            ci.lb <- NA
            ci.ub <- NA
        }
        else {
            b.exp <- R/S
            b <- log(b.exp)
            se <- sqrt(sum(((n1i/Ni) * (n2i/Ni) * (ai + ci) - 
                (ai/Ni) * ci))/(R * S))
            zval <- b/se
            pval <- 2 * pnorm(abs(zval), lower.tail = FALSE)
            ci.lb <- b - qnorm(alpha/2, lower.tail = FALSE) * 
                se
            ci.ub <- b + qnorm(alpha/2, lower.tail = FALSE) * 
                se
        }
        names(b) <- "intrcpt"
        vb <- matrix(se^2, dimnames = list("intrcpt", "intrcpt"))
    }
    if (measure == "RD") {
        b <- sum(ai * (n2i/Ni) - ci * (n1i/Ni))/sum(n1i * (n2i/Ni))
        se <- sqrt((b * (sum(ci * (n1i/Ni)^2 - ai * (n2i/Ni)^2 + 
            (n1i/Ni) * (n2i/Ni) * (n2i - n1i)/2)) + sum(ai * 
            (n2i - ci)/Ni + ci * (n1i - ai)/Ni)/2)/sum(n1i * 
            (n2i/Ni))^2)
        zval <- b/se
        pval <- 2 * pnorm(abs(zval), lower.tail = FALSE)
        ci.lb <- b - qnorm(alpha/2, lower.tail = FALSE) * se
        ci.ub <- b + qnorm(alpha/2, lower.tail = FALSE) * se
        names(b) <- "intrcpt"
        vb <- matrix(se^2, dimnames = list("intrcpt", "intrcpt"))
    }
    if (measure == "IRR") {
        R <- sum(x1i * (t2i/Ti))
        S <- sum(x2i * (t1i/Ti))
        if (identical(sum(x1i), 0) || identical(sum(x2i), 0)) {
            b.exp <- NA
            b <- NA
            se <- NA
            zval <- NA
            pval <- NA
            ci.lb <- NA
            ci.ub <- NA
        }
        else {
            b.exp <- R/S
            b <- log(b.exp)
            se <- sqrt(sum((t1i/Ti) * (t2i/Ti) * (x1i + x2i))/(R * 
                S))
            zval <- b/se
            pval <- 2 * pnorm(abs(zval), lower.tail = FALSE)
            ci.lb <- b - qnorm(alpha/2, lower.tail = FALSE) * 
                se
            ci.ub <- b + qnorm(alpha/2, lower.tail = FALSE) * 
                se
        }
        names(b) <- "intrcpt"
        vb <- matrix(se^2, dimnames = list("intrcpt", "intrcpt"))
        xt <- x1i + x2i
        if (identical(sum(xt), 0)) {
            MH <- NA
            MHp <- NA
        }
        else {
            MH <- (abs(sum(x1i - xt * (t1i/Ti))) - ifelse(correct, 
                0.5, 0))^2/sum(xt * (t1i/Ti) * (t2i/Ti))
            MHp <- pchisq(MH, df = 1, lower.tail = FALSE)
        }
    }
    if (measure == "IRD") {
        b <- sum((x1i * t2i - x2i * t1i)/Ti)/sum((t1i/Ti) * t2i)
        se <- sqrt(sum(((t1i/Ti) * t2i)^2 * (x1i/t1i^2 + x2i/t2i^2)))/sum((t1i/Ti) * 
            t2i)
        zval <- b/se
        pval <- 2 * pnorm(abs(zval), lower.tail = FALSE)
        ci.lb <- b - qnorm(alpha/2, lower.tail = FALSE) * se
        ci.ub <- b + qnorm(alpha/2, lower.tail = FALSE) * se
        names(b) <- "intrcpt"
        vb <- matrix(se^2, dimnames = list("intrcpt", "intrcpt"))
    }
    if (verbose) 
        message("Heterogeneity testing ...")
    wi <- 1/vi
    QE <- sum(wi * (yi - b)^2)
    if (k.yi - 1 >= 1) {
        QEp <- pchisq(QE, df = k.yi - 1, lower.tail = FALSE)
    }
    else {
        QEp <- 1
    }
    if (verbose) 
        message("Computing fit statistics and log likelihood ...")
    if (k.yi >= 1L) {
        ll.ML <- -1/2 * (k.yi) * log(2 * base::pi) - 1/2 * sum(log(vi)) - 
            1/2 * QE
        ll.REML <- -1/2 * (k.yi - 1) * log(2 * base::pi) + 1/2 * 
            log(k.yi) - 1/2 * sum(log(vi)) - 1/2 * log(sum(wi)) - 
            1/2 * QE
        dev.ML <- -2 * (ll.ML - sum(dnorm(yi, mean = yi, sd = sqrt(vi), 
            log = TRUE)))
        AIC.ML <- -2 * ll.ML + 2
        BIC.ML <- -2 * ll.ML + log(k.yi)
        AICc.ML <- -2 * ll.ML + 2 * max(k.yi, 3)/(max(k.yi, 3) - 
            2)
        dev.REML <- -2 * (ll.REML - 0)
        AIC.REML <- -2 * ll.REML + 2
        BIC.REML <- -2 * ll.REML + log(k.yi - 1)
        AICc.REML <- -2 * ll.REML + 2 * max(k.yi - 1, 3)/(max(k.yi - 
            1, 3) - 2)
        fit.stats <- matrix(c(ll.ML, dev.ML, AIC.ML, BIC.ML, 
            AICc.ML, ll.REML, dev.REML, AIC.REML, BIC.REML, AICc.REML), 
            ncol = 2, byrow = FALSE)
    }
    else {
        fit.stats <- matrix(NA, nrow = 5, ncol = 2, byrow = FALSE)
    }
    dimnames(fit.stats) <- list(c("ll", "dev", "AIC", "BIC", 
        "AICc"), c("ML", "REML"))
    fit.stats <- data.frame(fit.stats)
    if (verbose) 
        message("Preparing output ...")
    parms <- 1
    p <- 1
    p.eff <- 1
    k.eff <- k
    tau2 <- 0
    X.f <- cbind(rep(1, k.f))
    intercept <- TRUE
    int.only <- TRUE
    method <- "FE"
    weighted <- TRUE
    knha <- FALSE
    dfs <- NA
    res <- list(b = b, se = se, zval = zval, pval = pval, ci.lb = ci.lb, 
        ci.ub = ci.ub, vb = vb, tau2 = tau2, k = k, k.f = k.f, 
        k.yi = k.yi, k.pos = k.pos, k.eff = k.eff, p = p, parms = parms, 
        QE = QE, QEp = QEp, CO = CO, COp = COp, MH = MH, MHp = MHp, 
        BD = BD, BDp = BDp, TA = TA, TAp = TAp, int.only = int.only, 
        yi = yi, vi = vi, yi.f = yi.f, vi.f = vi.f, X.f = X.f, 
        ai = ai, bi = bi, ci = ci, di = di, ai.f = ai.f, bi.f = bi.f, 
        ci.f = ci.f, di.f = di.f, x1i = x1i, x2i = x2i, t1i = t1i, 
        t2i = t2i, x1i.f = x1i.f, x2i.f = x2i.f, t1i.f = t1i.f, 
        t2i.f = t2i.f, ni = ni, ni.f = ni.f, ids = ids, not.na = not.na, 
        not.na.yivi = not.na.yivi, slab = slab, slab.null = slab.null, 
        measure = measure, method = method, weighted = weighted, 
        knha = knha, dfs = dfs, intercept = intercept, digits = digits, 
        level = level, add = add, to = to, drop00 = drop00, correct = correct, 
        fit.stats = fit.stats, version = packageVersion("metafor"), 
        call = mf)
    class(res) <- c("rma.mh", "rma")
    return(res)
}
