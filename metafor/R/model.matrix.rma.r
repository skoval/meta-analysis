model.matrix.rma <-
function (object, ...) 
{
    if (!is.element("rma", class(object))) 
        stop("Argument 'object' must be an object of class \"rma\".")
    na.act <- getOption("na.action")
    if (!is.element(na.act, c("na.omit", "na.exclude", "na.fail", 
        "na.pass"))) 
        stop("Unknown 'na.action' specified under options().")
    if (na.act == "na.omit") 
        out <- object$X
    if (na.act == "na.exclude" || na.act == "na.pass") 
        out <- object$X.f
    if (na.act == "na.fail" && any(!object$not.na)) 
        stop("Missing values in results.")
    return(out)
}
