#' Compute sorting coefficient from cumulative distribution data
#'
#' @param sieve_size vector of sieve sizes related to input cumulative distribution
#' @param cumu cumulative distribution pertaining to sieve sizes
#' @param units sieve size units "phi" = phi scale, "mm" = milimeter (metric) scale
#' @param method Method to calculate sorting coefficient. Only algebraic methods available. "inm" = Inman, 1952. Algebraic method using central values; "fw" = Folk and Ward, 1957. Algebraic method to account for tail values. "all" = dataframe output with above calculations.
#'
#' @return a value or dataframe containing specified sorting coefficients.
#'
#' @export
#'
#' @examples
#'
#' @source see Bunte and Abt (2001) for examples and equations. Bunte, Kristin, and Steven R. Abt. "Sampling surface and subsurface particle-size distributions in wadable gravel-and cobble-bed streams for analyses in sediment transport, hydraulics, and streambed monitoring." (2001).
stat.sorting <- function(sieve_size, cumu, units = "phi", method = "all"){
  ## Function to calculate sorting coefficient.
  if (units == "phi"){
    phi_in <- TRUE
  }
  if (units == "mm"){
    phi_in <- FALSE
  }
  if (units != "phi" & units != "mm"){
    return(print("Units not recognized. Please check your input units."))
  }

  p05 <- stat.dx(sieve_size, cumu, d = 0.05, phi = phi_in)
  p10 <- stat.dx(sieve_size, cumu, d = 0.10, phi = phi_in)
  p16 <- stat.dx(sieve_size, cumu, d = 0.16, phi = phi_in)
  p25 <- stat.dx(sieve_size, cumu, d = 0.25, phi = phi_in)
  p50 <- stat.dx(sieve_size, cumu, d = 0.50, phi = phi_in)
  p75 <- stat.dx(sieve_size, cumu, d = 0.75, phi = phi_in)
  p84 <- stat.dx(sieve_size, cumu, d = 0.84, phi = phi_in)
  p90 <- stat.dx(sieve_size, cumu, d = 0.90, phi = phi_in)
  p95 <- stat.dx(sieve_size, cumu, d = 0.95, phi = phi_in)


  ## Algebraic methods
  inm <- abs((p84-p16)/2)
  fw <- ((p84 - p16)/4) + ((p95 - p05)/6.6)

  if (method == "fw"){
    fw <- ((p84 - p16)/4) + ((p95 - p05) / 6.6)
    return(fw)
  }
  if (method == "inm"){
    inm <- abs((p84-p16)/2)
    return(inm)
  }
  if (method == "all"){
    inm <- abs((p84-p16)/2)
    fw <- ((p84 - p16)/4) + ((p95 - p05)/6.6)
    return(data.frame("Folkward" = fw,
                      "Inman" = inm))
  } else {return(print("Method not recognized. Please check method input."))}
}
