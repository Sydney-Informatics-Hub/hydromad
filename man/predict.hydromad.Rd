\name{predict.hydromad}
\alias{predict.hydromad}
\title{ Generate simulated time series from Hydromad model objects }
\description{
  Generate simulated time series from Hydromad model objects.
}
\usage{
\method{predict}{hydromad}(object, newdata = NULL,
	which = c("both", "sma", "routing"), ...,
        all = TRUE, feasible.set = FALSE, glue.quantiles = NULL,
        groups = NULL, FUN = sum,
        return_state = FALSE, return_components = FALSE)
}
\arguments{
  \item{object}{
    an object of class \code{hydromad}.
  }
  \item{newdata}{
    a \code{\link{ts}}-like object containing a new time series
    dataset (replacing the original \code{DATA} argument given to the
    \code{hydromad} function).
  }
  \item{which}{
    selects either the SMA or routing model, or both models (the
    default). Note that if \code{which = "routing"}, then \code{newdata}
    is treated as the effective rainfall (U). 
  }
  \item{\dots}{
    any unmatched arguments will generate an error.
  }
  \item{all}{
    if \code{TRUE}, return the entire time series for which data
    exists. Otherwise, the warmup period (specified as an argument to
    \code{\link{hydromad}} or \code{update}) is stripped off.
  }
  \item{feasible.set, glue.quantiles}{
    if \code{feasible.set} is TRUE, then many simulations will be
    generated, using all parameter sets in the \emph{feasible set}. This
    must have been previously specified using
    \code{\link{defineFeasibleSet}}. If \code{glue.quantiles} is NULL
    then all the simulated time series are returned. If it is
    \code{c(0,1)} then the overall bounds (minimum and maximum at each
    time step) are returned. Otherwise the specified quantiles are
    estimated using GLUE-type weighting.
  }
  \item{groups, FUN}{
    \code{groups} is an optional grouping variable, of the same length
    as the observed data in \code{object}, used to aggregate the observed
    and fitted time series. The function \code{FUN} is applied to each
    group.
  }
  \item{return_state}{
    passed to the SMA simulation function, to return state variables.
  }
  \item{return_components}{
    passed to the routing simulation function, to return flow components.
  }
}
\details{
  
}
\value{
  simulated time series.
}
\author{ Felix Andrews \email{felix@nfrac.org} }
\seealso{
  \code{\link{hydromad}},
  \code{\link{update.hydromad}}
}
\examples{

}
\keyword{ methods }

