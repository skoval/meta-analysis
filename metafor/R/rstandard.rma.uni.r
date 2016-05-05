rstandard.rma.uni <-
function (model, digits, ...) 
{
    if (!is.element("rma.uni", class(model))) 
        stop("Argument 'model' must be an object of class \"rma.uni\".")
    na.act <- getOption("na.action")
    if (!is.element(na.act, c("na.omit", "na.exclude", "na.fail", 
        "na.pass"))) 
        stop("Unknown 'na.action' specified under options().")
    x <- model
    if (missing(digits)) 
        digits <- x$digits
    M <- diag(x$vi + x$tau2, nrow = x$k, ncol = x$k)
    options(na.action = "na.omit")
    H <- hatvalues(x, type = "matrix")
    options(na.action = na.act)
    ImH <- diag(x$k) - H
    ei <- ImH %*% cbind(x$yi)
    ei[abs(ei) < 100 * .Machine$double.eps] <- 0
    ve <- ImH %*% tcrossprod(M, ImH)
    sei <- sqrt(diag(ve))
    resid <- rep(NA_real_, x$k.f)
    seresid <- rep(NA_real_, x$k.f)
    stanres <- rep(NA_real_, x$k.f)
    resid[x$not.na] <- ei
    seresid[x$not.na] <- sei
    stanres[x$not.na] <- ei/sei
    if (na.act == "na.omit") {
        out <- list(resid = resid[x$not.na], se = seresid[x$not.na], 
            z = stanres[x$not.na])
        out$slab <- x$slab[x$not.na]
    }
    if (na.act == "na.exclude" || na.act == "na.pass") {
        out <- list(resid = resid, se = seresid, z = stanres)
        out$slab <- x$slab
    }
    if (na.act == "na.fail" && any(!x$not.na)) 
        stop("Missing values in results.")
    out$digits <- digits
    class(out) <- c("list.rma")
    return(out)
}
