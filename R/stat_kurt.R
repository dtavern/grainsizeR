#' Measure kurtosis from cumulative distribution data
#'
#' @param sieve_size vector of sieve sizes related to input cumulative distribution
#' @param cumu cumulative distribution pertaining to sieve sizes
#' @param units sieve size units "phi" = phi scale, "mm" = milimeter scale
#' @param method Method to calculate kurtosis. "fw" = Folk and Ward, 1957. This method is typically used for phi units and is fairly standard; "inm" = Inman, 1952. For phi scale and focuses on tails of distribution; "tra" = Trask, 1932. For metric (mm) data.; "sqrt" = Square root method for geometric approach in metric units;"log" = log transform metric data. Geometric approach. "all" = compute all methods into a data frame.
#'
#'
#' @return a numeric value or dataframe according to method chosen
#' @export
#'
#' @examples
#'
#' @source see Bunte and Abt (2001) for examples and equations. Bunte, Kristin, and Steven R. Abt. "Sampling surface and subsurface particle-size distributions in wadable gravel-and cobble-bed streams for analyses in sediment transport, hydraulics, and streambed monitoring." (2001).
stat.kurt <- function(sieve_size, cumu, units = "phi", method = "all"){
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

  if (method == "fw"){
    fw <- ((p95 - p05)/(2.44*(p75 - p25)))
    return(fw)
  }
  if (method == "inm"){
    inm <- ((0.5*(p95 - p05)-((p84 - p16)/2)) / ((p84 - p16)/2))
    return(inm)
  }
  if (method == "tra"){
    tra <- (p75 - p25) / (2 * (p90 - p10))
    return(tra)
  }
  if (method == "sqrt"){
    sqrt <- sqrt((p16/p84)/(p75 - p25))
    return(sqrt)
  }
  if (method == "log"){
    log <- (log10(p16/p84)/log10(p75/p25))
    return(log)
  }
  if (method == "all"){
    fw <- ((p95 - p05)/(2.44*(p75 - p25)))
    inm <- ((0.5*(p95 - p05)-((p84 - p16)/2)) / ((p84 - p16)/2))
    tra <- (p75 - p25) / (2 * (p90 - p10))
    sqrt <- sqrt((p16/p84)/(p75 - p25))
    log <- (log10(p16/p84)/log10(p75/p25))
    return(data.frame("Folkward" = fw,
                      "Inman" = inm,
                      "Trask" = tra,
                      "Geometric_sqrt" = sqrt,
                      "Geometric_log" = log))
  } else {return(print("Method not recognized. Please check method input."))}

}
