print.hc.rma.uni <-
function (x, digits, ...) 
{
    if (!is.element("hc.rma.uni", class(x))) 
        stop("Argument 'x' must be an object of class \"hc.rma.uni\".")
    if (missing(digits)) 
        digits <- x$digits
    res.table <- data.frame(method = c(x$method.rma, x$method), 
        tau2 = formatC(c(x$tau2.rma, x$tau2), digits = digits, 
            format = "f"), estimate = formatC(c(x$b.rma, x$b), 
            digits = digits, format = "f"), se = c(ifelse(is.na(x$se.rma), 
            NA, formatC(x$se.rma, digits = digits, format = "f")), 
            ifelse(is.na(x$se), NA, formatC(x$se, digits = digits, 
                format = "f"))), ci.lb = formatC(c(x$ci.lb.rma, 
            x$ci.lb), digits = digits, format = "f"), ci.ub = formatC(c(x$ci.ub.rma, 
            x$ci.ub), digits = digits, format = "f"), stringsAsFactors = FALSE)
    rownames(res.table) <- c("rma", "hc")
    print(res.table, quote = FALSE, right = TRUE)
    invisible(res.table)
}
