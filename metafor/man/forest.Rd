\name{forest}
\alias{forest}
\title{Forest Plots}
\description{
   The function \code{forest} is generic. It can be used to create forest plots.
}
\usage{
forest(x, \dots)
}
\arguments{
   \item{x}{either an object of class \code{"rma"}, a vector with the observed effect size or outcomes, or an object of class \code{"cumul.rma"}. See \sQuote{Details}.}
   \item{\dots}{other arguments.}
}
\details{
   Currently, methods exist for three types of situations.

   In the first case, object \code{x} is a fitted model object coming from the \code{\link{rma.uni}}, \code{\link{rma.mh}}, or \code{\link{rma.peto}} functions. The corresponding method is then \code{\link{forest.rma}}.

   Alternatively, object \code{x} can be a vector with observed effect size or outcomes. The corresponding method is then \code{\link{forest.default}}.

   Finally, object \code{x} could be an object coming from the \code{\link{cumul.rma.uni}}, \code{\link{cumul.rma.mh}}, or \code{\link{cumul.rma.peto}} functions. The corresponding method is then \code{\link{forest.cumul.rma}}.
}
\author{
   Wolfgang Viechtbauer \email{wvb@metafor-project.org} \cr
   package website: \url{http://www.metafor-project.org/} \cr
   author homepage: \url{http://www.wvbauer.com/}
}
\references{
   Lewis, S., & Clarke, M. (2001). Forest plots: Trying to see the wood and the trees. \emph{British Medical Journal}, \bold{322}, 1479--1480.

   Viechtbauer, W. (2010). Conducting meta-analyses in R with the metafor package. \emph{Journal of Statistical Software}, \bold{36}(3), 1--48. \url{http://www.jstatsoft.org/v36/i03/}.
}
\seealso{
   \code{\link{forest.rma}}, \code{\link{forest.default}}, \code{\link{forest.cumul.rma}}
}
\keyword{hplot}
