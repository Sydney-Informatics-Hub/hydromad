#' @useDynLib hydromad ar1_tv
ar1_tv <- function(x, a, n, init, out) {
  .C(ar1_tv,
     as.double(x),
     as.double(a),
     as.integer(n),
     as.double(init),
     as.double(out),
     NAOK = FALSE,
     PACKAGE = "hydromad"
  )
}
