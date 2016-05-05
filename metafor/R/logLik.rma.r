logLik.rma <-
function (object, REML, ...) 
{
    if (!is.element("rma", class(object))) 
        stop("Argument 'object' must be an object of class \"rma\".")
    if (missing(REML)) {
        if (object$method == "REML") {
            REML <- TRUE
        }
        else {
            REML <- FALSE
        }
    }
    if (REML) {
        val <- object$fit.stats$REML[1]
    }
    else {
        val <- object$fit.stats$ML[1]
    }
    attr(val, "nall") <- object$k.eff
    attr(val, "nobs") <- object$k.eff - ifelse(REML, 1, 0) * 
        object$p.eff
    attr(val, "df") <- object$parms
    class(val) <- "logLik"
    return(val)
}
