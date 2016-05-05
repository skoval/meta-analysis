to.table <-
function (measure, ai, bi, ci, di, n1i, n2i, x1i, x2i, t1i, t2i, 
    m1i, m2i, sd1i, sd2i, xi, mi, ri, ti, sdi, ni, data, slab, 
    subset, add = 1/2, to = "none", drop00 = FALSE, rows, cols) 
{
    if (!is.element(measure, c("RR", "OR", "PETO", "RD", "AS", 
        "PHI", "YUQ", "YUY", "RTET", "PBIT", "OR2D", "OR2DN", 
        "OR2DL", "IRR", "IRD", "IRSD", "MD", "SMD", "SMDH", "ROM", 
        "RPB", "RBIS", "D2OR", "D2ORN", "D2ORL", "COR", "UCOR", 
        "ZCOR", "PR", "PLN", "PLO", "PAS", "PFT", "IR", "IRLN", 
        "IRS", "IRFT", "MN", "MC", "SMCC", "SMCR", "SMCRH", "ROMC", 
        "ARAW", "AHW", "ABT"))) 
        stop("Unknown 'measure' specified.")
    na.act <- getOption("na.action")
    if (!is.element(na.act, c("na.omit", "na.exclude", "na.fail", 
        "na.pass"))) 
        stop("Unknown 'na.action' specified under options().")
    if (!is.element(to, c("all", "only0", "if0all", "none"))) 
        stop("Unknown 'to' argument specified.")
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
    if (is.element(measure, c("RR", "OR", "RD", "AS", "PETO", 
        "PHI", "YUQ", "YUY", "RTET", "PBIT", "OR2D", "OR2DN", 
        "OR2DL"))) {
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
        k <- length(ai)
        if (!is.null(subset)) {
            ai <- ai[subset]
            bi <- bi[subset]
            ci <- ci[subset]
            di <- di[subset]
        }
        if (length(ai) == 0L || length(bi) == 0L || length(ci) == 
            0L || length(di) == 0L) 
            stop("Cannot compute outcomes. Check that all of the required \n  information is specified via the appropriate arguments.")
        if (!all(length(ai) == c(length(ai), length(bi), length(ci), 
            length(di)))) 
            stop("Supplied data vectors are not all of the same length.")
        if (any(c(ai, bi, ci, di) < 0, na.rm = TRUE)) 
            stop("One or more counts are negative.")
        ni.u <- ai + bi + ci + di
        if (drop00) {
            id00 <- c(ai == 0L & ci == 0L) | c(bi == 0L & di == 
                0L)
            id00[is.na(id00)] <- FALSE
            ai[id00] <- NA
            bi[id00] <- NA
            ci[id00] <- NA
            di[id00] <- NA
        }
        if (to == "all") {
            ai <- ai + add
            ci <- ci + add
            bi <- bi + add
            di <- di + add
        }
        if (to == "only0") {
            id0 <- c(ai == 0L | ci == 0L | bi == 0L | di == 0L)
            id0[is.na(id0)] <- FALSE
            ai[id0] <- ai[id0] + add
            ci[id0] <- ci[id0] + add
            bi[id0] <- bi[id0] + add
            di[id0] <- di[id0] + add
        }
        if (to == "if0all") {
            id0 <- c(ai == 0L | ci == 0L | bi == 0L | di == 0L)
            id0[is.na(id0)] <- FALSE
            if (any(id0)) {
                ai <- ai + add
                ci <- ci + add
                bi <- bi + add
                di <- di + add
            }
        }
    }
    if (is.element(measure, c("IRR", "IRD", "IRSD"))) {
        mf.x1i <- mf[[match("x1i", names(mf))]]
        mf.x2i <- mf[[match("x2i", names(mf))]]
        mf.t1i <- mf[[match("t1i", names(mf))]]
        mf.t2i <- mf[[match("t2i", names(mf))]]
        x1i <- eval(mf.x1i, data, enclos = sys.frame(sys.parent()))
        x2i <- eval(mf.x2i, data, enclos = sys.frame(sys.parent()))
        t1i <- eval(mf.t1i, data, enclos = sys.frame(sys.parent()))
        t2i <- eval(mf.t2i, data, enclos = sys.frame(sys.parent()))
        k <- length(x1i)
        if (!is.null(subset)) {
            x1i <- x1i[subset]
            x2i <- x2i[subset]
            t1i <- t1i[subset]
            t2i <- t2i[subset]
        }
        if (length(x1i) == 0L || length(x2i) == 0L || length(t1i) == 
            0L || length(t2i) == 0L) 
            stop("Cannot compute outcomes. Check that all of the required \n  information is specified via the appropriate arguments.")
        if (!all(length(x1i) == c(length(x1i), length(x2i), length(t1i), 
            length(t2i)))) 
            stop("Supplied data vectors are not all of the same length.")
        if (any(c(x1i, x2i) < 0, na.rm = TRUE)) 
            stop("One or more counts are negative.")
        if (any(c(t1i, t2i) < 0, na.rm = TRUE)) 
            stop("One or more person-times are negative.")
        ni.u <- t1i + t2i
        if (drop00) {
            id00 <- c(x1i == 0L & x2i == 0L)
            id00[is.na(id00)] <- FALSE
            x1i[id00] <- NA
            x2i[id00] <- NA
        }
        if (to == "all") {
            x1i <- x1i + add
            x2i <- x2i + add
        }
        if (to == "only0") {
            id0 <- c(x1i == 0L | x2i == 0L)
            id0[is.na(id0)] <- FALSE
            x1i[id0] <- x1i[id0] + add
            x2i[id0] <- x2i[id0] + add
        }
        if (to == "if0all") {
            id0 <- c(x1i == 0L | x2i == 0L)
            id0[is.na(id0)] <- FALSE
            if (any(id0)) {
                x1i <- x1i + add
                x2i <- x2i + add
            }
        }
    }
    if (is.element(measure, c("MD", "SMD", "SMDH", "ROM", "RPB", 
        "RBIS", "D2OR", "D2ORN", "D2ORL"))) {
        mf.m1i <- mf[[match("m1i", names(mf))]]
        mf.m2i <- mf[[match("m2i", names(mf))]]
        mf.sd1i <- mf[[match("sd1i", names(mf))]]
        mf.sd2i <- mf[[match("sd2i", names(mf))]]
        mf.n1i <- mf[[match("n1i", names(mf))]]
        mf.n2i <- mf[[match("n2i", names(mf))]]
        m1i <- eval(mf.m1i, data, enclos = sys.frame(sys.parent()))
        m2i <- eval(mf.m2i, data, enclos = sys.frame(sys.parent()))
        sd1i <- eval(mf.sd1i, data, enclos = sys.frame(sys.parent()))
        sd2i <- eval(mf.sd2i, data, enclos = sys.frame(sys.parent()))
        n1i <- eval(mf.n1i, data, enclos = sys.frame(sys.parent()))
        n2i <- eval(mf.n2i, data, enclos = sys.frame(sys.parent()))
        k <- length(m1i)
        if (!is.null(subset)) {
            m1i <- m1i[subset]
            m2i <- m2i[subset]
            sd1i <- sd1i[subset]
            sd2i <- sd2i[subset]
            n1i <- n1i[subset]
            n2i <- n2i[subset]
        }
        if (length(m1i) == 0L || length(m2i) == 0L || length(sd1i) == 
            0L || length(sd2i) == 0L || length(n1i) == 0L || 
            length(n2i) == 0L) 
            stop("Cannot compute outcomes. Check that all of the required \n  information is specified via the appropriate arguments.")
        if (!all(length(m1i) == c(length(m1i), length(m2i), length(sd1i), 
            length(sd2i), length(n1i), length(n2i)))) 
            stop("Supplied data vectors are not all of the same length.")
        if (any(c(sd1i, sd2i) < 0, na.rm = TRUE)) 
            stop("One or more standard deviations are negative.")
        if (any(c(n1i, n2i) < 0, na.rm = TRUE)) 
            stop("One or more sample sizes are negative.")
        ni.u <- n1i + n2i
    }
    if (is.element(measure, c("COR", "UCOR", "ZCOR"))) {
        mf.ri <- mf[[match("ri", names(mf))]]
        mf.ni <- mf[[match("ni", names(mf))]]
        ri <- eval(mf.ri, data, enclos = sys.frame(sys.parent()))
        ni <- eval(mf.ni, data, enclos = sys.frame(sys.parent()))
        k <- length(ri)
        if (!is.null(subset)) {
            ri <- ri[subset]
            ni <- ni[subset]
        }
        if (length(ri) == 0L || length(ni) == 0L) 
            stop("Cannot compute outcomes. Check that all of the required \n  information is specified via the appropriate arguments.")
        if (length(ri) != length(ni)) 
            stop("Supplied data vectors are not of the same length.")
        if (any(abs(ri) > 1, na.rm = TRUE)) 
            stop("One or more correlations are > 1 or < -1.")
        if (any(ni < 0, na.rm = TRUE)) 
            stop("One or more sample sizes are negative.")
        ni.u <- ni
    }
    if (is.element(measure, c("PR", "PLN", "PLO", "PAS", "PFT"))) {
        mf.xi <- mf[[match("xi", names(mf))]]
        mf.mi <- mf[[match("mi", names(mf))]]
        mf.ni <- mf[[match("ni", names(mf))]]
        xi <- eval(mf.xi, data, enclos = sys.frame(sys.parent()))
        mi <- eval(mf.mi, data, enclos = sys.frame(sys.parent()))
        ni <- eval(mf.ni, data, enclos = sys.frame(sys.parent()))
        if (is.null(mi)) 
            mi <- ni - xi
        k <- length(xi)
        if (!is.null(subset)) {
            xi <- xi[subset]
            mi <- mi[subset]
        }
        if (length(xi) == 0L || length(mi) == 0L) 
            stop("Cannot compute outcomes. Check that all of the required \n  information is specified via the appropriate arguments.")
        if (length(xi) != length(mi)) 
            stop("Supplied data vectors are not all of the same length.")
        if (any(c(xi, mi) < 0, na.rm = TRUE)) 
            stop("One or more counts are negative.")
        ni.u <- xi + mi
        if (to == "all") {
            xi <- xi + add
            mi <- mi + add
        }
        if (to == "only0") {
            id0 <- c(xi == 0L | mi == 0L)
            id0[is.na(id0)] <- FALSE
            xi[id0] <- xi[id0] + add
            mi[id0] <- mi[id0] + add
        }
        if (to == "if0all") {
            id0 <- c(xi == 0L | mi == 0L)
            id0[is.na(id0)] <- FALSE
            if (any(id0)) {
                xi <- xi + add
                mi <- mi + add
            }
        }
    }
    if (is.element(measure, c("IR", "IRLN", "IRS", "IRFT"))) {
        mf.xi <- mf[[match("xi", names(mf))]]
        mf.ti <- mf[[match("ti", names(mf))]]
        xi <- eval(mf.xi, data, enclos = sys.frame(sys.parent()))
        ti <- eval(mf.ti, data, enclos = sys.frame(sys.parent()))
        k <- length(xi)
        if (!is.null(subset)) {
            xi <- xi[subset]
            ti <- ti[subset]
        }
        if (length(xi) == 0L || length(ti) == 0L) 
            stop("Cannot compute outcomes. Check that all of the required \n  information is specified via the appropriate arguments.")
        if (length(xi) != length(ti)) 
            stop("Supplied data vectors are not all of the same length.")
        if (any(xi < 0, na.rm = TRUE)) 
            stop("One or more counts are negative.")
        if (any(ti < 0, na.rm = TRUE)) 
            stop("One or more person-times are negative.")
        ni.u <- ti
        if (to == "all") {
            xi <- xi + add
        }
        if (to == "only0") {
            id0 <- c(xi == 0L)
            id0[is.na(id0)] <- FALSE
            xi[id0] <- xi[id0] + add
        }
        if (to == "if0all") {
            id0 <- c(xi == 0L)
            id0[is.na(id0)] <- FALSE
            if (any(id0)) {
                xi <- xi + add
            }
        }
    }
    if (is.element(measure, c("MN"))) {
        mf.mi <- mf[[match("mi", names(mf))]]
        mf.sdi <- mf[[match("sdi", names(mf))]]
        mf.ni <- mf[[match("ni", names(mf))]]
        mi <- eval(mf.mi, data, enclos = sys.frame(sys.parent()))
        sdi <- eval(mf.sdi, data, enclos = sys.frame(sys.parent()))
        ni <- eval(mf.ni, data, enclos = sys.frame(sys.parent()))
        k <- length(mi)
        if (!is.null(subset)) {
            mi <- mi[subset]
            sdi <- sdi[subset]
            ni <- ni[subset]
        }
        if (length(mi) == 0L || length(sdi) == 0L || length(ni) == 
            0L) 
            stop("Cannot compute outcomes. Check that all of the required \n  information is specified via the appropriate arguments.")
        if (!all(length(mi) == c(length(mi), length(sdi), length(ni)))) 
            stop("Supplied data vectors are not all of the same length.")
        if (any(sdi < 0, na.rm = TRUE)) 
            stop("One or more standard deviations are negative.")
        if (any(ni < 0, na.rm = TRUE)) 
            stop("One or more sample sizes are negative.")
        ni.u <- ni
    }
    if (is.element(measure, c("MC", "SMCC", "SMCR", "SMCRH", 
        "ROMC"))) {
        mf.m1i <- mf[[match("m1i", names(mf))]]
        mf.m2i <- mf[[match("m2i", names(mf))]]
        mf.sd1i <- mf[[match("sd1i", names(mf))]]
        mf.sd2i <- mf[[match("sd2i", names(mf))]]
        mf.ni <- mf[[match("ni", names(mf))]]
        mf.ri <- mf[[match("ri", names(mf))]]
        m1i <- eval(mf.m1i, data, enclos = sys.frame(sys.parent()))
        m2i <- eval(mf.m2i, data, enclos = sys.frame(sys.parent()))
        sd1i <- eval(mf.sd1i, data, enclos = sys.frame(sys.parent()))
        sd2i <- eval(mf.sd2i, data, enclos = sys.frame(sys.parent()))
        ni <- eval(mf.ni, data, enclos = sys.frame(sys.parent()))
        ri <- eval(mf.ri, data, enclos = sys.frame(sys.parent()))
        k <- length(m1i)
        if (!is.null(subset)) {
            m1i <- m1i[subset]
            m2i <- m2i[subset]
            sd1i <- sd1i[subset]
            sd2i <- sd2i[subset]
            ni <- ni[subset]
            ri <- ri[subset]
        }
        if (is.element(measure, c("MC", "SMCC", "SMCRH", "ROMC"))) {
            if (length(m1i) == 0L || length(m2i) == 0L || length(sd1i) == 
                0L || length(sd2i) == 0L || length(ni) == 0L || 
                length(ri) == 0L) 
                stop("Cannot compute outcomes. Check that all of the required \n  information is specified via the appropriate arguments.")
            if (!all(length(m1i) == c(length(m1i), length(m2i), 
                length(sd1i), length(sd2i), length(ni), length(ri)))) 
                stop("Supplied data vectors are not all of the same length.")
            if (any(c(sd1i, sd2i) < 0, na.rm = TRUE)) 
                stop("One or more standard deviations are negative.")
        }
        else {
            if (length(m1i) == 0L || length(m2i) == 0L || length(sd1i) == 
                0L || length(ni) == 0L || length(ri) == 0L) 
                stop("Cannot compute outcomes. Check that all of the required \n  information is specified via the appropriate arguments.")
            if (!all(length(m1i) == c(length(m1i), length(m2i), 
                length(sd1i), length(ni), length(ri)))) 
                stop("Supplied data vectors are not all of the same length.")
            if (any(sd1i < 0, na.rm = TRUE)) 
                stop("One or more standard deviations are negative.")
        }
        if (any(abs(ri) > 1, na.rm = TRUE)) 
            stop("One or more correlations are > 1 or < -1.")
        if (any(ni < 0, na.rm = TRUE)) 
            stop("One or more sample sizes are negative.")
        ni.u <- ni
    }
    if (is.element(measure, c("ARAW", "AHW", "ABT"))) {
        mf.ai <- mf[[match("ai", names(mf))]]
        mf.mi <- mf[[match("mi", names(mf))]]
        mf.ni <- mf[[match("ni", names(mf))]]
        ai <- eval(mf.ai, data, enclos = sys.frame(sys.parent()))
        mi <- eval(mf.mi, data, enclos = sys.frame(sys.parent()))
        ni <- eval(mf.ni, data, enclos = sys.frame(sys.parent()))
        k <- length(ai)
        if (!is.null(subset)) {
            ai <- ai[subset]
            mi <- mi[subset]
            ni <- ni[subset]
        }
        if (length(ai) == 0L || length(mi) == 0L || length(ni) == 
            0L) 
            stop("Cannot compute outcomes. Check that all of the required \n  information is specified via the appropriate arguments.")
        if (!all(length(ai) == c(length(ai), length(mi), length(ni)))) 
            stop("Supplied data vectors are not all of the same length.")
        if (any(ai > 1, na.rm = TRUE)) 
            stop("One or more alpha values are > 1.")
        if (any(mi < 2, na.rm = TRUE)) 
            stop("One or more mi values are < 2.")
        if (any(ni < 0, na.rm = TRUE)) 
            stop("One or more sample sizes are negative.")
        ni.u <- ni
    }
    if (is.null(slab)) {
        slab <- seq_len(k)
    }
    else {
        if (anyNA(slab)) 
            stop("NAs in study labels.")
        if (anyDuplicated(slab)) 
            slab <- make.unique(as.character(slab))
        if (length(slab) != k) 
            stop("Study labels not of same length as data.")
    }
    if (!is.null(subset)) 
        slab <- slab[subset]
    if (is.element(measure, c("RR", "OR", "RD", "AS", "PETO", 
        "PHI", "YUQ", "YUY", "RTET", "PBIT", "OR2D", "OR2DN", 
        "OR2DL"))) {
        aibicidi.na <- is.na(ai) | is.na(bi) | is.na(ci) | is.na(di)
        if (any(aibicidi.na)) {
            not.na <- !aibicidi.na
            if (na.act == "na.omit") {
                ai <- ai[not.na]
                bi <- bi[not.na]
                ci <- ci[not.na]
                di <- di[not.na]
                slab <- slab[not.na]
                warning("Tables with NAs omitted.")
            }
            if (na.act == "na.fail") 
                stop("Missing values in tables.")
        }
        k <- length(ai)
        if (k < 1) 
            stop("Processing terminated since k = 0.")
        if (missing(rows)) {
            rows <- c("Grp1", "Grp2")
        }
        else {
            if (length(rows) != 2) 
                stop("Group names not of length 2.")
        }
        if (missing(cols)) {
            cols <- c("Out1", "Out2")
        }
        else {
            if (length(cols) != 2) 
                stop("Outcome names not of length 2.")
        }
        dat <- array(NA, dim = c(2, 2, k), dimnames = list(rows, 
            cols, slab))
        for (i in 1:k) {
            tab.i <- rbind(c(ai[i], bi[i]), c(ci[i], di[i]))
            dat[, , i] <- tab.i
        }
    }
    if (is.element(measure, c("IRR", "IRD", "IRSD"))) {
        x1ix2it1it2i.na <- is.na(x1i) | is.na(x2i) | is.na(t1i) | 
            is.na(t2i)
        if (any(x1ix2it1it2i.na)) {
            not.na <- !x1ix2it1it2i.na
            if (na.act == "na.omit") {
                x1i <- x1i[not.na]
                x2i <- x2i[not.na]
                t1i <- t1i[not.na]
                t2i <- t2i[not.na]
                slab <- slab[not.na]
                warning("Tables with NAs omitted.")
            }
            if (na.act == "na.fail") 
                stop("Missing values in tables.")
        }
        k <- length(x1i)
        if (k < 1) 
            stop("Processing terminated since k = 0.")
        if (missing(rows)) {
            rows <- c("Grp1", "Grp2")
        }
        else {
            if (length(rows) != 2) 
                stop("Group names not of length 2.")
        }
        if (missing(cols)) {
            cols <- c("Events", "Person-Time")
        }
        else {
            if (length(cols) != 2) 
                stop("Outcome names not of length 2.")
        }
        dat <- array(NA, dim = c(2, 2, k), dimnames = list(rows, 
            cols, slab))
        for (i in 1:k) {
            tab.i <- rbind(c(x1i[i], t1i[i]), c(x2i[i], t2i[i]))
            dat[, , i] <- tab.i
        }
    }
    if (is.element(measure, c("MD", "SMD", "SMDH", "ROM", "RPB", 
        "RBIS", "D2OR", "D2ORN", "D2ORL"))) {
        m1im2isd1isd2in1in2i.na <- is.na(m1i) | is.na(m2i) | 
            is.na(sd1i) | is.na(sd2i) | is.na(n1i) | is.na(n2i)
        if (any(m1im2isd1isd2in1in2i.na)) {
            not.na <- !m1im2isd1isd2in1in2i.na
            if (na.act == "na.omit") {
                m1i <- m1i[not.na]
                m2i <- m2i[not.na]
                sd1i <- sd1i[not.na]
                sd2i <- sd2i[not.na]
                n1i <- n1i[not.na]
                n2i <- n2i[not.na]
                slab <- slab[not.na]
                warning("Tables with NAs omitted.")
            }
            if (na.act == "na.fail") 
                stop("Missing values in tables.")
        }
        k <- length(m1i)
        if (k < 1) 
            stop("Processing terminated since k = 0.")
        if (missing(rows)) {
            rows <- c("Grp1", "Grp2")
        }
        else {
            if (length(rows) != 2) 
                stop("Group names not of length 2.")
        }
        if (missing(cols)) {
            cols <- c("Mean", "SD", "n")
        }
        else {
            if (length(cols) != 3) 
                stop("Outcome names not of length 3.")
        }
        dat <- array(NA, dim = c(2, 3, k), dimnames = list(rows, 
            cols, slab))
        for (i in 1:k) {
            tab.i <- rbind(c(m1i[i], sd1i[i], n1i[i]), c(m2i[i], 
                sd2i[i], n2i[i]))
            dat[, , i] <- tab.i
        }
    }
    if (is.element(measure, c("COR", "UCOR", "ZCOR"))) {
        rini.na <- is.na(ri) | is.na(ni)
        if (any(rini.na)) {
            not.na <- !rini.na
            if (na.act == "na.omit") {
                ri <- ri[not.na]
                ni <- ni[not.na]
                slab <- slab[not.na]
                warning("Tables with NAs omitted.")
            }
            if (na.act == "na.fail") 
                stop("Missing values in tables.")
        }
        k <- length(ri)
        if (k < 1) 
            stop("Processing terminated since k = 0.")
        if (missing(rows)) {
            rows <- c("Grp")
        }
        else {
            if (length(rows) != 1) 
                stop("Group names not of length 1.")
        }
        if (missing(cols)) {
            cols <- c("r", "n")
        }
        else {
            if (length(cols) != 2) 
                stop("Outcome names not of length 2.")
        }
        dat <- array(NA, dim = c(1, 2, k), dimnames = list(rows, 
            cols, slab))
        for (i in 1:k) {
            tab.i <- c(ri[i], ni[i])
            dat[, , i] <- tab.i
        }
    }
    if (is.element(measure, c("PR", "PLN", "PLO", "PAS", "PFT"))) {
        ximi.na <- is.na(xi) | is.na(mi)
        if (any(ximi.na)) {
            not.na <- !ximi.na
            if (na.act == "na.omit") {
                xi <- xi[not.na]
                mi <- mi[not.na]
                slab <- slab[not.na]
                warning("Tables with NAs omitted.")
            }
            if (na.act == "na.fail") 
                stop("Missing values in tables.")
        }
        k <- length(xi)
        if (k < 1) 
            stop("Processing terminated since k = 0.")
        if (missing(rows)) {
            rows <- c("Grp")
        }
        else {
            if (length(rows) != 1) 
                stop("Group names not of length 1.")
        }
        if (missing(cols)) {
            cols <- c("Out1", "Out2")
        }
        else {
            if (length(cols) != 2) 
                stop("Outcome names not of length 2.")
        }
        dat <- array(NA, dim = c(1, 2, k), dimnames = list(rows, 
            cols, slab))
        for (i in 1:k) {
            tab.i <- c(xi[i], mi[i])
            dat[, , i] <- tab.i
        }
    }
    if (is.element(measure, c("IR", "IRLN", "IRS", "IRFT"))) {
        xiti.na <- is.na(xi) | is.na(ti)
        if (any(xiti.na)) {
            not.na <- !xiti.na
            if (na.act == "na.omit") {
                xi <- xi[not.na]
                ti <- ti[not.na]
                slab <- slab[not.na]
                warning("Tables with NAs omitted.")
            }
            if (na.act == "na.fail") 
                stop("Missing values in tables.")
        }
        k <- length(xi)
        if (k < 1) 
            stop("Processing terminated since k = 0.")
        if (missing(rows)) {
            rows <- c("Grp")
        }
        else {
            if (length(rows) != 1) 
                stop("Group names not of length 1.")
        }
        if (missing(cols)) {
            cols <- c("Events", "Person-Time")
        }
        else {
            if (length(cols) != 2) 
                stop("Outcome names not of length 2.")
        }
        dat <- array(NA, dim = c(1, 2, k), dimnames = list(rows, 
            cols, slab))
        for (i in 1:k) {
            tab.i <- c(xi[i], ti[i])
            dat[, , i] <- tab.i
        }
    }
    if (is.element(measure, c("MN"))) {
        misdini.na <- is.na(mi) | is.na(sdi) | is.na(ni)
        if (any(misdini.na)) {
            not.na <- !misdini.na
            if (na.act == "na.omit") {
                mi <- mi[not.na]
                sdi <- sdi[not.na]
                ni <- ni[not.na]
                slab <- slab[not.na]
                warning("Tables with NAs omitted.")
            }
            if (na.act == "na.fail") 
                stop("Missing values in tables.")
        }
        k <- length(mi)
        if (k < 1) 
            stop("Processing terminated since k = 0.")
        if (missing(rows)) {
            rows <- c("Grp")
        }
        else {
            if (length(rows) != 1) 
                stop("Group names not of length 1.")
        }
        if (missing(cols)) {
            cols <- c("Mean", "SD", "n")
        }
        else {
            if (length(cols) != 3) 
                stop("Outcome names not of length 3.")
        }
        dat <- array(NA, dim = c(1, 3, k), dimnames = list(rows, 
            cols, slab))
        for (i in 1:k) {
            tab.i <- c(mi[i], sdi[i], ni[i])
            dat[, , i] <- tab.i
        }
    }
    if (is.element(measure, c("MC", "SMCC", "SMCR", "SMCRH", 
        "ROMC"))) {
        if (is.element(measure, c("MC", "SMCC", "SMCRH", "ROMC"))) {
            m1im2isdiniri.na <- is.na(m1i) | is.na(m2i) | is.na(sd1i) | 
                is.na(sd2i) | is.na(ni) | is.na(ri)
        }
        else {
            m1im2isdiniri.na <- is.na(m1i) | is.na(m2i) | is.na(sd1i) | 
                is.na(ni) | is.na(ri)
        }
        if (any(m1im2isdiniri.na)) {
            not.na <- !m1im2isdiniri.na
            if (na.act == "na.omit") {
                m1i <- m1i[not.na]
                m2i <- m2i[not.na]
                sd1i <- sd1i[not.na]
                if (is.element(measure, c("MC", "SMCC", "SMCRH", 
                  "ROMC"))) 
                  sd2i <- sd2i[not.na]
                ni <- ni[not.na]
                ri <- ri[not.na]
                slab <- slab[not.na]
                warning("Tables with NAs omitted.")
            }
            if (na.act == "na.fail") 
                stop("Missing values in tables.")
        }
        k <- length(m1i)
        if (k < 1) 
            stop("Processing terminated since k = 0.")
        if (missing(rows)) {
            rows <- c("Grp")
        }
        else {
            if (length(rows) != 1) 
                stop("Group names not of length 1.")
        }
        if (is.element(measure, c("MC", "SMCC", "SMCRH", "ROMC"))) {
            if (missing(cols)) {
                cols <- c("Mean1", "Mean2", "SD1", "SD2", "n", 
                  "r")
            }
            else {
                if (length(cols) != 6) 
                  stop("Outcome names not of length 6.")
            }
        }
        else {
            if (missing(cols)) {
                cols <- c("Mean1", "Mean2", "SD1", "n", "r")
            }
            else {
                if (length(cols) != 5) 
                  stop("Outcome names not of length 5.")
            }
        }
        if (is.element(measure, c("MC", "SMCC", "SMCRH", "ROMC"))) {
            dat <- array(NA, dim = c(1, 6, k), dimnames = list(rows, 
                cols, slab))
            for (i in 1:k) {
                tab.i <- c(m1i[i], m2i[i], sd1i[i], sd2i[i], 
                  ni[i], ri[i])
                dat[, , i] <- tab.i
            }
        }
        else {
            dat <- array(NA, dim = c(1, 5, k), dimnames = list(rows, 
                cols, slab))
            for (i in 1:k) {
                tab.i <- c(m1i[i], m2i[i], sd1i[i], ni[i], ri[i])
                dat[, , i] <- tab.i
            }
        }
    }
    if (is.element(measure, c("ARAW", "AHW", "ABT"))) {
        aimini.na <- is.na(ai) | is.na(mi) | is.na(ni)
        if (any(aimini.na)) {
            not.na <- !aimini.na
            if (na.act == "na.omit") {
                ai <- ai[not.na]
                mi <- mi[not.na]
                ni <- ni[not.na]
                slab <- slab[not.na]
                warning("Tables with NAs omitted.")
            }
            if (na.act == "na.fail") 
                stop("Missing values in tables.")
        }
        k <- length(ai)
        if (k < 1) 
            stop("Processing terminated since k = 0.")
        if (missing(rows)) {
            rows <- c("Grp")
        }
        else {
            if (length(rows) != 1) 
                stop("Group names not of length 1.")
        }
        if (missing(cols)) {
            cols <- c("alpha", "m", "n")
        }
        else {
            if (length(cols) != 3) 
                stop("Outcome names not of length 3.")
        }
        dat <- array(NA, dim = c(1, 3, k), dimnames = list(rows, 
            cols, slab))
        for (i in 1:k) {
            tab.i <- c(ai[i], mi[i], ni[i])
            dat[, , i] <- tab.i
        }
    }
    return(dat)
}
