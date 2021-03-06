\name{sacramento}
\alias{sacramento}
\alias{sacramento.sim}
\title{ Sacramento Soil Moisture Accounting model }
\description{
  Sacramento Soil Moisture Accounting model.
  Developed by the US National Weather Service.
}
\usage{
sacramento.sim(DATA, uztwm, uzfwm, uzk, pctim, adimp, zperc, rexp,
               lztwm, lzfsm, lzfpm, lzsk, lzpk, pfree,
               etmult = 1, dt = 1,
               uztwc_0=0.5,uzfwc_0=0.5,
               lztwc_0=0.5,lzfsc_0=0.5,lzfpc_0=0.5,
               adimc_0=0.5,min_ninc=20,
               return_state = FALSE)
}
\arguments{
  \item{DATA}{
    time-series-like object with columns \code{P} (precipitation,
    mm) and \code{E} (potential evapo-transpiration, mm, scaled by
    \code{etmult}).
  }
  \item{uztwm}{Upper zone tension water maximum capacity (mm).}
  \item{uzfwm}{Upper zone free water maximum capacity (mm).}
  \item{uzk}{Lateral drainage rate of upper zone free water expressed
    as a fraction of contents per day.}
  \item{pctim}{The fraction of the catchment which produces
    impervious runoff during low flow conditions.}
  \item{adimp}{The additional fraction of the catchment which
    exhibits impervious characteristics when the catchment's tension
    water requirements are met.}
  \item{zperc}{Maximum percolation (from upper zone free water into
    the lower zone) rate coefficient.}
  \item{rexp}{An exponent determining the rate of change of the
    percolation rate with changing lower zone water contents.}
  \item{lztwm}{Lower zone tension water maximum capacity (mm).}
  \item{lzfsm}{Lower zone supplemental free water maximum capacity (mm).}
  \item{lzfpm}{Lower zone primary free water maximum capacity (mm).}
  \item{lzsk}{Lateral drainage rate of lower zone supplemental free
    water expressed as a fraction of contents per day.}
  \item{lzpk}{Lateral drainage rate of lower zone primary free water
    expressed as a fraction of contents per day.}
  \item{pfree}{Direct percolation fraction from upper to lower zone
    free water (the percentage of percolated water which is available
    to the lower zone free water aquifers before all lower zone tension
    water deficiencies are satisfied).}
  \item{etmult}{Multiplier applied to \code{DATA$E} to estimate
    potential evapotranspiration.}
  \item{dt}{Length of each time step in days.}
  \item{uztwc_0}{Initial upper zone tension water contents as proportion
    of \code{uztwm}}
  \item{uzfwc_0}{Initial upper zone free water content as proportion of
    \code{uzfwm}}
  \item{lztwc_0}{Initial lower zone tension water content as proportion
    of \code{lztwm}}
  \item{lzfsc_0}{Initial lower zone free water secondary as proportion
    of \code{lzfsm}}
  \item{lzfpc_0}{Initial lower zone free water primary as proportion of
    \code{lzfpm}}
  \item{adimc_0}{Initial additional impervious flow store, as proportion
    of \code{uztwm+lztwm}}
  \item{min_ninc}{Minimum number of inner iterations. This is a simple attempt to improve numerical stability. See Details.}
  \item{return_state}{to return time series of each state variable and
    flow component}
}
\details{
  This description of the model is given by Burnash (1995):

  \dQuote{The moisture accounting system utilized in the Sacramento
    Catchment Model is a carefully structured representation of the
    catchment's soil moisture storage system. It is based on using
    simple approximations of many of those soil moisture processes
    which have been reported in the hydrologic literature. The authors
    have organised these approximations in a manner which would allow
    the determination of many catchment characteristics from carefully
    selected portions of the catchment's hydrologic record. Inasmuch as
    many of the catchment characteristics are related to the soil
    moisture capabilities of the catchment, an intelligent application
    of the model start with a good understanding of the three basic
    types of soil moisture which can potentially influence catchment
    runoff conditions. These soil moisture types are: (1) Hygroscopic
    Water, (2) Tension Water and (3) Free Water. }

  [...]

  \dQuote{Streamflow as computed by the Sacramento Catchment Model is
    the result of processing precipiatation through an algorithm
    representing the uppermost soil mantle identified as the upper zone
    and a deeper portion of the soil mantle or lower zone. The
    algorithm computes runoff in five basic forms. These are (1) direct
    runoff from permanant and temporary impervious areas, (2) surface
    runoff due to precipitation occurring at a rate faster than
    percolation and interflow can take place when both upper zone
    storages are full, (3) interflow resulting from the lateral
    drainage of a temporary free water storage, (4) supplemental base
    flow, and (5) primary base flow.} (Burnash, 1995)

  The default parameter ranges were taken from Blasone et. al. (2008).
  
  Note that the Sacramento model potentially suffers from numerical instabilities, which can be seen for example as discontinuities in output and derivatives of outputs (see Hendrickson et al. 1988). Ideally, the underlying differential equations of the model would be solved using a numerically robust timestepping scheme (see Clark & Kavetski 2010). The hydromad package makes use of an existing implementation. To help remedy the numerical instability, the argument \code{min_ninc} has been added, which defines the minimum number of inner loops used within each timestep. The user is encouraged to test the effect of increasing \code{min_ninc} on their dataset.
  
}
\value{
  the simulated effective rainfall (\dQuote{total channel
    inflow}), a time series of the same length as the input series.

  if \code{return_state=TRUE}, a list with components:
  \item{uztwc}{Upper zone tension water content}
  \item{uzfwc}{Upper zone free water content}
  \item{lztwc}{Lower zone tension water content}
  \item{lzfsc}{Lower zone free secondary water content}
  \item{lzfpc}{Lower zone free primary water content}
  \item{adimc}{Tension water contents of the additional impervious area}
  \item{sett}{Cumulative total evapotranspiration}
  \item{se1}{Cumulative evapotranspiration from upper zone tension
    water}
  \item{se3}{Cumulative evapotranspiration from lower zone tension
    water}
  \item{se4}{Cumulative evapotranspiration}
  \item{se5}{Cumulative evapotranspiration from riparian zone}
  \item{roimp}{Runoff from impervious area}
  \item{sdro}{Six hour sum of runoff (?)}
  \item{ssur}{Surface runoff}
  \item{sif}{Interflow}
  \item{bfp}{Primary baseflow}
  \item{bfs}{Secondary baseflow}
  \item{bfcc}{Channel baseflow (bfp+bfs)}
}
\references{
  Burnash, R.J.C (1995). The NWS River Forecast System -- Catchment Modeling.
  In: Vijay P. Singh (ed.), \emph{Computer models of watershed hydrology.}
  Revised edition, Highlands Ranch, Colo. : Water Resources Publications, c1995.
  \url{http://www.wrpllc.com/books/cmwh.html}.

  Blasone, R., J.A. Vrugt, H. Madsen, D. Rosbjerg, B.A. Robinson,
  G.A. Zyvoloski (2008). Generalized likelihood uncertainty estimation
  (GLUE) using adaptive Markov Chain Monte Carlo
  sampling. \emph{Advances in Water Resources} 31, pp. 630-648.
  
  Hendrickson, Jene' D., Soroosh Sorooshian, and Larry E. Brazil (1988)
  Comparison of Newton-Type and Direct Search Algorithms for Calibration of
  Conceptual Rainfall-Runoff Models. \emph{Water Resources Research} 24 (5): 691-700.
  \url{http://dx.doi.org/10.1029/WR024i005p00691}
  
  Clark, Martyn P., and Dmitri Kavetski (2010) Ancient Numerical 
  Daemons of Conceptual Hydrological Modeling: 1. Fidelity and Efficiency 
  of Time Stepping Schemes.” Water Resources Research 46 (10).
  \url{http://dx.doi.org/10.1029/2009WR008894}
}
\author{ Felix Andrews \email{felix@nfrac.org} and Joseph Guillaume, based on code from the University of Arizona MOSCEM project}
\seealso{
  \code{\link{hydromad}(sma = "sacramento")} to work with models as objects (recommended).
}
\examples{
## view default parameter ranges:
str(hydromad.options("sacramento"))

data(HydroTestData)
mod0 <- hydromad(HydroTestData, sma = "sacramento")
mod0

## simulate with some arbitrary parameter values
set.seed(2)
mod1 <- simulate(update(mod0, etmult = 0.01), 1, sampletype =
"random")[[1]]

testQ <- predict(mod1, return_state = TRUE)
xyplot(window(cbind(HydroTestData[,1:2], sacramento = testQ), start = 100))
mod1

## show effect of increase/decrease in each parameter
parRanges <- hydromad.getOption("sacramento")
parsims <- mapply(val = parRanges, nm = names(parRanges),
  FUN = function(val, nm) {
    lopar <- min(val)
    hipar <- max(val)
    names(lopar) <- names(hipar) <- nm
    fitted(runlist(decrease = update(mod1, newpars = lopar),
                   increase = update(mod1, newpars = hipar)))
  }, SIMPLIFY = FALSE)

xyplot.list(parsims, superpose = TRUE, layout = c(1,NA),
            strip = FALSE, strip.left = TRUE,
            main = "Simple parameter perturbation example") +
  latticeExtra::layer(panel.lines(fitted(mod1), col = "grey", lwd = 2))
}
\keyword{ models }

