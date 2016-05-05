profile.rma.mv <-
function (fitted, sigma2, tau2, rho, gamma2, phi, xlim, ylim, 
    steps = 20, startmethod = "init", progbar = TRUE, parallel = "no", 
    ncpus = 1, cl = NULL, plot = TRUE, pch = 19, ...) 
{
    if (!is.element("rma.mv", class(fitted))) 
        stop("Argument 'fitted' must be an object of class \"rma.mv\".")
    if (steps < 2) 
        stop("Argument 'steps' must be >= 2.")
    x <- fitted
    parallel <- match.arg(parallel, c("no", "snow", "multicore"))
    if (missing(sigma2) && missing(tau2) && missing(rho) && missing(gamma2) && 
        missing(phi)) {
        cl <- match.call()
        comps <- ifelse(x$withS, sum(!x$vc.fix$sigma2), 0) + 
            ifelse(x$withG, sum(!x$vc.fix$tau2) + sum(!x$vc.fix$rho), 
                0) + ifelse(x$withH, sum(!x$vc.fix$gamma2) + 
            sum(!x$vc.fix$phi), 0)
        if (comps == 0) 
            stop("No components to profile.")
        if (plot) {
            if (dev.cur() == 1) 
                par(mfrow = c(comps, 1))
        }
        res <- list()
        j <- 0
        if (x$withS && any(!x$vc.fix$sigma2)) {
            for (pos in (1:x$sigma2s)[!x$vc.fix$sigma2]) {
                j <- j + 1
                cl.vc <- cl
                cl.vc$sigma2 <- pos
                cl.vc$fitted <- quote(x)
                if (progbar) 
                  cat("Profiling sigma2 =", pos, "\n")
                res[[j]] <- eval(cl.vc)
            }
        }
        if (x$withG) {
            if (any(!x$vc.fix$tau2)) {
                for (pos in (1:x$tau2s)[!x$vc.fix$tau2]) {
                  j <- j + 1
                  cl.vc <- cl
                  cl.vc$tau2 <- pos
                  cl.vc$fitted <- quote(x)
                  if (progbar) 
                    cat("Profiling tau2 =", pos, "\n")
                  res[[j]] <- eval(cl.vc)
                }
            }
            if (any(!x$vc.fix$rho)) {
                for (pos in (1:x$rhos)[!x$vc.fix$rho]) {
                  j <- j + 1
                  cl.vc <- cl
                  cl.vc$rho <- pos
                  cl.vc$fitted <- quote(x)
                  if (progbar) 
                    cat("Profiling rho =", pos, "\n")
                  res[[j]] <- eval(cl.vc)
                }
            }
        }
        if (x$withH) {
            if (any(!x$vc.fix$gamma2)) {
                for (pos in (1:x$gamma2s)[!x$vc.fix$gamma2]) {
                  j <- j + 1
                  cl.vc <- cl
                  cl.vc$gamma2 <- pos
                  cl.vc$fitted <- quote(x)
                  if (progbar) 
                    cat("Profiling gamma2 =", pos, "\n")
                  res[[j]] <- eval(cl.vc)
                }
            }
            if (any(!x$vc.fix$phi)) {
                for (pos in (1:x$phis)[!x$vc.fix$phi]) {
                  j <- j + 1
                  cl.vc <- cl
                  cl.vc$phi <- pos
                  cl.vc$fitted <- quote(x)
                  if (progbar) 
                    cat("Profiling phi =", pos, "\n")
                  res[[j]] <- eval(cl.vc)
                }
            }
        }
        return(invisible(res))
    }
    if (sum(!missing(sigma2), !missing(tau2), !missing(rho), 
        !missing(gamma2), !missing(phi)) > 1L) 
        stop("Must specify only one of the arguments 'sigma2', 'tau2', 'rho', 'gamma2', or 'phi'.")
    if (!missing(sigma2) && (all(is.na(x$vc.fix$sigma2)) || all(x$vc.fix$sigma2))) 
        stop("Model does not contain any (estimated) 'sigma2' components.")
    if (!missing(tau2) && (all(is.na(x$vc.fix$tau2)) || all(x$vc.fix$tau2))) 
        stop("Model does not contain any (estimated) 'tau2' components.")
    if (!missing(rho) && c(all(is.na(x$vc.fix$rho)) || all(x$vc.fix$rho))) 
        stop("Model does not contain any (estimated) 'rho' components.")
    if (!missing(gamma2) && (all(is.na(x$vc.fix$gamma2)) || all(x$vc.fix$gamma2))) 
        stop("Model does not contain any (estimated) 'gamma2' components.")
    if (!missing(phi) && c(all(is.na(x$vc.fix$phi)) || all(x$vc.fix$phi))) 
        stop("Model does not contain any (estimated) 'phi' components.")
    if (!missing(sigma2) && (length(sigma2) > 1L)) 
        stop("Can only specify one 'sigma2' component.")
    if (!missing(tau2) && (length(tau2) > 1L)) 
        stop("Can only specify one 'tau2' component.")
    if (!missing(rho) && (length(rho) > 1L)) 
        stop("Can only specify one 'rho' component.")
    if (!missing(gamma2) && (length(gamma2) > 1L)) 
        stop("Can only specify one 'gamma2' component.")
    if (!missing(phi) && (length(phi) > 1L)) 
        stop("Can only specify one 'phi' component.")
    if (!missing(sigma2) && is.logical(sigma2)) 
        stop("Must specify the number for the 'sigma2' component.")
    if (!missing(tau2) && is.logical(tau2)) 
        stop("Must specify the number for the 'tau2' component.")
    if (!missing(rho) && is.logical(rho)) 
        stop("Must specify the number for the 'rho' component.")
    if (!missing(gamma2) && is.logical(gamma2)) 
        stop("Must specify the number for the 'gamma2' component.")
    if (!missing(phi) && is.logical(phi)) 
        stop("Must specify the number for the 'phi' component.")
    if (!missing(sigma2) && (sigma2 > length(x$vc.fix$sigma2) || 
        sigma2 <= 0)) 
        stop("No such 'sigma2' component in the model.")
    if (!missing(tau2) && (tau2 > length(x$vc.fix$tau2) || tau2 <= 
        0)) 
        stop("No such 'tau2' component in the model.")
    if (!missing(rho) && (rho > length(x$vc.fix$rho) || rho <= 
        0)) 
        stop("No such 'rho' component in the model.")
    if (!missing(gamma2) && (gamma2 > length(x$vc.fix$gamma2) || 
        gamma2 <= 0)) 
        stop("No such 'gamma2' component in the model.")
    if (!missing(phi) && (phi > length(x$vc.fix$phi) || phi <= 
        0)) 
        stop("No such 'phi' component in the model.")
    if (!missing(sigma2) && x$vc.fix$sigma2[sigma2]) 
        stop("Specified 'sigma2' component was fixed.")
    if (!missing(tau2) && x$vc.fix$tau2[tau2]) 
        stop("Specified 'tau2' component was fixed.")
    if (!missing(rho) && x$vc.fix$rho[rho]) 
        stop("Specified 'rho' component was fixed.")
    if (!missing(gamma2) && x$vc.fix$gamma2[gamma2]) 
        stop("Specified 'gamma2' component was fixed.")
    if (!missing(phi) && x$vc.fix$phi[phi]) 
        stop("Specified 'phi' component was fixed.")
    sigma2.pos <- NA
    tau2.pos <- NA
    rho.pos <- NA
    gamma2.pos <- NA
    phi.pos <- NA
    if (!missing(sigma2)) {
        vc <- x$sigma2[sigma2]
        comp <- "sigma2"
        sigma2.pos <- sigma2
    }
    if (!missing(tau2)) {
        vc <- x$tau2[tau2]
        comp <- "tau2"
        tau2.pos <- tau2
    }
    if (!missing(rho)) {
        vc <- x$rho[rho]
        comp <- "rho"
        rho.pos <- rho
    }
    if (!missing(gamma2)) {
        vc <- x$gamma2[gamma2]
        comp <- "gamma2"
        gamma2.pos <- gamma2
    }
    if (!missing(phi)) {
        vc <- x$phi[phi]
        comp <- "phi"
        phi.pos <- phi
    }
    if (missing(xlim)) {
        if (is.element(comp, c("sigma2", "tau2", "gamma2"))) {
            vc.lb <- max(0, vc/4)
            vc.ub <- max(0.1, vc * 4)
        }
        else {
            vc.lb <- max(-0.99999, vc - 0.5)
            vc.ub <- min(+0.99999, vc + 0.5)
        }
        if (is.na(vc.lb) || is.na(vc.ub)) 
            stop("Cannot set 'xlim' automatically. Please set this argument manually.")
        xlim <- c(vc.lb, vc.ub)
    }
    else {
        if (length(xlim) != 2L) 
            stop("Argument 'xlim' should be a vector of length 2.")
        xlim <- sort(xlim)
    }
    vcs <- seq(xlim[1], xlim[2], length = steps)
    if (length(vcs) <= 1) 
        stop("Cannot set 'xlim' automatically. Please set this argument manually.")
    x.control <- x$control
    if (length(x.control) > 0) {
        con.pos.sigma2.init <- pmatch("sigma2.init", names(x.control))
        con.pos.tau2.init <- pmatch("tau2.init", names(x.control))
        con.pos.rho.init <- pmatch("rho.init", names(x.control))
        con.pos.gamma2.init <- pmatch("gamma2.init", names(x.control))
        con.pos.phi.init <- pmatch("phi.init", names(x.control))
    }
    else {
        con.pos.sigma2.init <- NA
        con.pos.tau2.init <- NA
        con.pos.rho.init <- NA
        con.pos.gamma2.init <- NA
        con.pos.phi.init <- NA
    }
    if (parallel == "no") {
        lls <- rep(NA_real_, length(vcs))
        b <- matrix(NA_real_, nrow = length(vcs), ncol = x$p)
        ci.lb <- matrix(NA_real_, nrow = length(vcs), ncol = x$p)
        ci.ub <- matrix(NA_real_, nrow = length(vcs), ncol = x$p)
        if (progbar) 
            pbar <- txtProgressBar(min = 0, max = steps, style = 3)
        sigma2.arg <- ifelse(x$vc.fix$sigma2, x$sigma2, NA)
        tau2.arg <- ifelse(x$vc.fix$tau2, x$tau2, NA)
        rho.arg <- ifelse(x$vc.fix$rho, x$rho, NA)
        gamma2.arg <- ifelse(x$vc.fix$gamma2, x$gamma2, NA)
        phi.arg <- ifelse(x$vc.fix$phi, x$phi, NA)
        for (i in 1:length(vcs)) {
            if (comp == "sigma2") 
                sigma2.arg[sigma2] <- vcs[i]
            if (comp == "tau2") 
                tau2.arg[tau2] <- vcs[i]
            if (comp == "rho") 
                rho.arg[rho] <- vcs[i]
            if (comp == "gamma2") 
                gamma2.arg[gamma2] <- vcs[i]
            if (comp == "phi") 
                phi.arg[phi] <- vcs[i]
            if (startmethod == "prev" && i > 1 && !inherits(res, 
                "try-error")) {
                if (is.na(con.pos.sigma2.init)) {
                  x.control$sigma2.init <- res$sigma2
                }
                else {
                  x.control[[con.pos.sigma2.init]] <- res$sigma2
                }
                if (is.na(con.pos.tau2.init)) {
                  x.control$tau2.init <- res$tau2
                }
                else {
                  x.control[[con.pos.tau2.init]] <- res$tau2
                }
                if (is.na(con.pos.rho.init)) {
                  x.control$rho.init <- res$rho
                }
                else {
                  x.control[[con.pos.rho.init]] <- res$rho
                }
                if (is.na(con.pos.gamma2.init)) {
                  x.control$gamma2.init <- res$gamma2
                }
                else {
                  x.control[[con.pos.gamma2.init]] <- res$gamma2
                }
                if (is.na(con.pos.phi.init)) {
                  x.control$phi.init <- res$phi
                }
                else {
                  x.control[[con.pos.phi.init]] <- res$phi
                }
                res <- try(suppressWarnings(rma.mv(x$yi, x$V, 
                  x$W, mods = x$X, random = x$random, struct = x$struct, 
                  intercept = FALSE, method = x$method, tdist = x$knha, 
                  level = x$level, R = x$R, Rscale = x$Rscale, 
                  data = x$mf.r, sigma2 = sigma2.arg, tau2 = tau2.arg, 
                  rho = rho.arg, gamma2 = gamma2.arg, phi = phi.arg, 
                  control = x.control)), silent = TRUE)
            }
            else {
                res <- try(suppressWarnings(rma.mv(x$yi, x$V, 
                  x$W, mods = x$X, random = x$random, struct = x$struct, 
                  intercept = FALSE, method = x$method, tdist = x$knha, 
                  level = x$level, R = x$R, Rscale = x$Rscale, 
                  data = x$mf.r, sigma2 = sigma2.arg, tau2 = tau2.arg, 
                  rho = rho.arg, gamma2 = gamma2.arg, phi = phi.arg, 
                  control = x$control)), silent = TRUE)
            }
            if (inherits(res, "try-error")) 
                next
            lls[i] <- c(logLik(res))
            b[i, ] <- c(res$b)
            ci.lb[i, ] <- c(res$ci.lb)
            ci.ub[i, ] <- c(res$ci.ub)
            if (progbar) 
                setTxtProgressBar(pbar, i)
        }
        if (progbar) 
            close(pbar)
    }
    if (parallel == "snow" || parallel == "multicore") {
        if (!requireNamespace("parallel", quietly = TRUE)) 
            stop("Please install the 'parallel' package for parallel processing.")
        ncpus <- as.integer(ncpus)
        if (ncpus < 1) 
            stop("Argument 'ncpus' must be >= 1.")
        if (parallel == "multicore") 
            res <- parallel::mclapply(vcs, .profile.rma.mv, obj = x, 
                comp = comp, sigma2.pos = sigma2.pos, tau2.pos = tau2.pos, 
                rho.pos = rho.pos, gamma2.pos = gamma2.pos, phi.pos = phi.pos, 
                mc.cores = ncpus, parallel = parallel)
        if (parallel == "snow") {
            if (is.null(cl)) {
                cl <- parallel::makePSOCKcluster(ncpus)
                res <- parallel::parLapply(cl, vcs, .profile.rma.mv, 
                  obj = x, comp = comp, sigma2.pos = sigma2.pos, 
                  tau2.pos = tau2.pos, rho.pos = rho.pos, gamma2.pos = gamma2.pos, 
                  phi.pos = phi.pos, parallel = parallel)
                parallel::stopCluster(cl)
            }
            else {
                res <- parallel::parLapply(cl, vcs, .profile.rma.mv, 
                  obj = x, comp = comp, sigma2.pos = sigma2.pos, 
                  tau2.pos = tau2.pos, rho.pos = rho.pos, gamma2.pos = gamma2.pos, 
                  phi.pos = phi.pos, parallel = parallel)
            }
        }
        lls <- sapply(res, function(z) z$ll)
        b <- do.call("rbind", lapply(res, function(z) t(z$b)))
        ci.lb <- do.call("rbind", lapply(res, function(z) t(z$ci.lb)))
        ci.ub <- do.call("rbind", lapply(res, function(z) t(z$ci.ub)))
    }
    b <- data.frame(b)
    ci.lb <- data.frame(ci.lb)
    ci.ub <- data.frame(ci.ub)
    names(b) <- rownames(x$b)
    names(ci.lb) <- rownames(x$b)
    names(ci.ub) <- rownames(x$b)
    res <- list(vc = vcs, ll = lls, b = b, ci.lb = ci.lb, ci.ub = ci.ub)
    names(res)[1] <- switch(comp, sigma2 = "sigma2", tau2 = "tau2", 
        rho = "rho", gamma2 = "gamma2", phi = "phi")
    class(res) <- c("profile.rma.mv")
    if (plot) {
        if (missing(ylim)) {
            ylim <- range(lls, na.rm = TRUE)
            ylim[1] <- ylim[1] - 0.1
            ylim[2] <- ylim[2] + 0.1
        }
        if (comp == "sigma2") {
            if (length(x$sigma2) == 1L) {
                xlab <- expression(paste(sigma^2, " Value"))
                title <- expression(paste("Profile Plot for ", 
                  sigma^2))
            }
            else {
                xlab <- bquote(sigma[.(sigma2)]^2 ~ "Value")
                title <- bquote("Profile Plot for" ~ sigma[.(sigma2)]^2)
            }
        }
        if (comp == "tau2") {
            if (length(x$tau2) == 1L) {
                xlab <- expression(paste(tau^2, " Value"))
                title <- expression(paste("Profile Plot for ", 
                  tau^2))
            }
            else {
                xlab <- bquote(tau[.(tau2)]^2 ~ "Value")
                title <- bquote("Profile Plot for" ~ tau[.(tau2)]^2)
            }
        }
        if (comp == "rho") {
            if (length(x$rho) == 1L) {
                xlab <- expression(paste(rho, " Value"))
                title <- expression(paste("Profile Plot for ", 
                  rho))
            }
            else {
                xlab <- bquote(rho[.(rho)] ~ "Value")
                title <- bquote("Profile Plot for" ~ rho[.(rho)])
            }
        }
        if (comp == "gamma2") {
            if (length(x$gamma2) == 1L) {
                xlab <- expression(paste(gamma^2, " Value"))
                title <- expression(paste("Profile Plot for ", 
                  gamma^2))
            }
            else {
                xlab <- bquote(gamma[.(gamma2)]^2 ~ "Value")
                title <- bquote("Profile Plot for" ~ gamma[.(gamma2)]^2)
            }
        }
        if (comp == "phi") {
            if (length(x$phi) == 1L) {
                xlab <- expression(paste(phi, " Value"))
                title <- expression(paste("Profile Plot for ", 
                  phi))
            }
            else {
                xlab <- bquote(phi[.(phi)] ~ "Value")
                title <- bquote("Profile Plot for" ~ phi[.(phi)])
            }
        }
        plot(vcs, lls, type = "o", xlab = xlab, ylab = paste(ifelse(x$method == 
            "REML", "Restricted", ""), " Log-Likelihood", sep = ""), 
            main = title, bty = "l", pch = pch, ylim = ylim, 
            ...)
        abline(v = vc, lty = "dotted")
        abline(h = logLik(x), lty = "dotted")
    }
    invisible(res)
}
