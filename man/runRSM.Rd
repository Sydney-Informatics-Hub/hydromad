\name{runRSM}
\alias{evalRSM}
\alias{runRSM}
\title{
  Response Surface Method
}
\description{
  Fit second-order response-surface model to model objective function,
  see \code{\link{rsm}}; and evaluate on an independent sample. Uses the \code{\link[rsm]{rsm}} package.
}
\usage{
runRSM(modx, ..., objective = hydromad.getOption("objective"))
evalRSM(modx,rsm.object,n=100,
  objective = hydromad.getOption("objective"),
  method="latin.hypercube")
}
\arguments{
  \item{modx}{
    a model specification created by \code{\link{hydromad}}. It should
    not be fully specified, i.e one or more parameters should be defined
    by \emph{ranges} of values rather than exact values.
    
    The response surface for this model and objective within these
    bounds should be able to be approximated by a quadratic, which may
    only be the case close to the optimum.

    \code{\link{findUnivariateBounds}} can be used as a heuristic method
    to narrow down bounds
}
  \item{\dots}{
    Passed to \code{\link{ccd}} to select an experimental design.
}
  \item{objective}{
    objective function to use to generate response surface, given as a \code{function(Q, X, ...)}.
    See \code{\link{objFunVal}}.
  }
  \item{rsm.object}{rsm object produced by runRSM}
  \item{n}{Number of independent samples to draw for evaluation of fit}
  \item{method}{Sampling scheme for \code{evalRSM}. See \code{\link{parameterSets}}}
}
\details{
  Wrapper around \code{\link{ccd}}, \code{\link{evalPars}} and
  \code{\link{rsm}} to respectively generate a response-surface design,
  run a \code{hydromad} model and fit a second-order response-surface model.

  Parameters for \code{\link{ccd}} need to be determined before hand by
  the user, e.g. using \code{\link{ccd.pick}}.

  The fit of the resulting response surface model should evaluated,
  e.g. using \code{summary.lm}. Fit might be improved with better
  design parameters \code{ccd} or by reducing the ranges of parameters
  in \code{modx} to a region that can be better approximated by a
  quadratic.

  \code{evalRSM} randomly samples an independent set of parameters, evaluates
  the objective using the hydromad model and response surface at each
  point and calculates measures of fit similarly to
  \code{\link{summary.lm}}, displaying them using the print method.
}
\value{
  For \code{runRSM}, an \code{\link{rsm}} object.

  For \code{evalRSM}, a list with elements:
  \item{fitted.values}{objective values from rsm object}
  \item{model.values}{objective values from hydromad runs}
  \item{indep.sample}{\code{coded.data} describing new sampled points}
  \item{df}{Degrees of freedom, see \code{\link{summary.lm}}}
  \item{sigma}{the square root of the estimated variance of the
    random error, see \code{\link{summary.lm}}}
  \item{r.squared}{R^2, the 'fraction of variance explained by the
    model', see \code{\link{summary.lm}}}
  \item{adj.r.squared}{the above R^2 statistic 'adjusted', penalizing for higher p}
}
\author{
Joseph Guillaume
}
\references{
Shin, Mun-Ju, Joseph H.A. Guillaume, Barry F.W. Croke, and Anthony J. Jakeman. 2015. "A Review of Foundational Methods for Checking the Structural Identifiability of Models: Results for Rainfall-Runoff." Journal of Hydrology 520(November): 1-16. doi:\href{http://dx.doi.org/10.1016/j.jhydrol.2014.11.040}{10.1016/j.jhydrol.2014.11.040}

Lenth RV (2009) "Response-Surface Methods in R, Using rsm", Journal of Statistical Software, 32(7), 1-17. \url{http://www.jstatsoft.org/v32/i07/}

G.E.P. Box, N.R. Draper. 1987. Empirical Model-building and Response Surfaces. John Wiley and Sons, New York

A. Abusam, K.J. Keesman, G. van Straten, H. Spanjers, K. Meinema. 2001. "Sensitivity analysis in oxidation ditch modelling: the effect of variations in stoichiometric, kinetic and operating parameters on the performance indices" J. Chem. Technol. Biot., 76(4):430-438. doi:\href{http://dx.doi.org/10.1002/jctb.398}{10.1002/jctb.398}
}
\seealso{
the \code{\link[rsm]{rsm}} package; \code{\link{findUnivariateBounds}} to help reduce bounds to a quadratic
region, \code{\link{ccd.pick}} to help determine parameters of design
(passed as \dots)
}
\examples{
## This method depends on the rsm package
library(rsm)

################################################################################
## Load data and define model

data(Cotter)
x <- Cotter[1:1000]

## IHACRES CWI model with exponential unit hydrograph
## an unfitted model, with ranges of possible parameter values
modx <- hydromad(x, sma = "cwi", routing = "expuh",
                 tau_s = c(2,100), v_s = c(0,1))

################################################################################
## Find bounds around best guess 

## Best fit, used as initial feasible solution
##fitx=fitBySCE(modx,control=list(ncomplex=20))
## Stored solution
fitx <- hydromad(x, sma = "cwi", routing = "expuh",
    tw = 99.9999996914052, f = 4.82636111146549, scale = 0.00129007217632751, 
    l = 0, p = 1, t_ref = 20, tau_s = 25.2327996372133, v_s = 0.925195113458179)

## Identify bounds
thres <- objFunVal(fitx)-0.05 ## Look for models within 0.05 of best fit
bounds <- findUnivariateBounds(modx,fitx,thres)
## If fit of RSM is poor, probably need to narrow bounds further to concentrate on quadratic region
modx <- update(modx,newpars=bounds)

################################################################################
## Evaluate designs with 4 variables, because there are 4 free parameters
getFreeParsRanges(modx)
ccd.pick(4)
## Design 5 with n0.c=10 and n0.s=5 is both rotatable and orthogonal,
##  as alpha.rot and alpha.orth are identical
##  and it uses N=39 model evaluations
## This seems suitable

################################################################################
## Run RSM with n0.c=10 and n0.s=5
set.seed(10) #make replicable
evals.rsm <- runRSM(modx,n0=c(10,5))

##evaluate fit
summary.lm(evals.rsm) 
## Residual standard error of 0.008575
##  and R2=0.9235 could be ok,
##  but has room for improvement.

## Standard results from ?rsm
summary(evals.rsm)

## Evaluate on an independent sample
evalRSM(modx,evals.rsm,n=100)

## Plot eigen plots
eigen.plot(evals.rsm,fixed.axis=TRUE)
## Wide/tall ellipses indicate relatively lower identifiability
## Rotated ellipses indicate correlation between pairs of parameters
dev.new()
eigen.plot(evals.rsm,fixed.axis=FALSE)
## Rotation of ellipses is more visible with fixed axes

}
\keyword{models}
