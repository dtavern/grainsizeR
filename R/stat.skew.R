#' Measure skewness from cumulative distribution data
#'
#' @param sieve_size vector of sieve sizes related to input cumulative distribution
#' @param cumu cumulative distribution pertaining to sieve sizes
#' @param units sieve size units "phi" = phi scale, "mm" = milimeter scale
#' @param method "inm" = Inman (1952) difference between mean and median divided by sorting;"inmod" = Modified Inman (1952) to account for tails;"fw" = Folk and Ward (1957) combination of the above;"war" = Warren (1974) simplified Folk and Ward;"gor" = Gordon (1992) less weighting on tails in case of unreliable data;"qsk" = Quartile skewness to use only inter-quartile data points;"tra" = Trask (1932) same as qsk but with mm units;"fred" = Fredle Index. Ratio of mean to sorting;"all" Output results of all methods in one dataframe
#'
#' @return numeric or dataframe output according to the method chosen
#' @export
#'
#' @examples
#'


stat.skew <- function(sieve_size, cumu, units = "phi", method = "all"){
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

  if (method == "inm"){
    inm <- (p16+p84-2*p50) / (p84 - p16)
    return(inm)
  }
  if (method == "inmod"){
    inmod <- (p05 + p84 - 2*p50) / 2*(p84 - p16)
    return(inmod)
  }
  if (method == "fw"){
    fw <- ((p16 + p84 - (2*p50)) / 2*(p84 - p16)) + ((p05 + p95 - (2 * p50))/2*(p95 - p05))
    return(fw)
  }
  if (method == "war"){
    war <- ((p84 - p50)/(p84 - p16)) - ((p50 - p05) / (p95 - p05))
    return(war)
  }
  if (method == "gor"){
    gor <- ((p84 - p50)/(p84 - p16)) - ((p50 - p10) / (p90 - p10))
    return(gor)
  }
  if (method == "qsk"){
    qsk <- ((p75 - p50) - (p50 - p25)) / (p75 - p25)
    return(qsk)
  }
  if (method == "tra"){
    tra <- (p25 * p75) / (p50^2)
    return(tra)
  }
  if (method == "fred"){
    fred <- sqrt((p84*p16)/(p75 / p25))
    return(log)
  }
  if (method == "all"){
    inm <- (p16+p84-2*p50) / (p84 - p16)
    inmod <- (p05 + p84 - 2*p50) / 2*(p84 - p16)
    fw <- ((p16 + p84 - (2*p50)) / 2*(p84 - p16)) + ((p05 + p95 - (2 * p50))/2*(p95 - p05))
    war <- ((p84 - p50)/(p84 - p16)) - ((p50 - p05) / (p95 - p05))
    gor <- ((p84 - p50)/(p84 - p16)) - ((p50 - p10) / (p90 - p10))
    qsk <- ((p75 - p50) - (p50 - p25)) / (p75 - p25)
    tra <- (p25 * p75) / (p50^2)
    fred <- sqrt((p84*p16)/(p75 / p25))
    return(data.frame("Inman" = inm,
                      "Inman-modified" = inmod,
                      "Folk-ward" = fw,
                      "Warren" = war,
                      "Gordon" = gor,
                      "quartile-skew" = qsk,
                      "Trask" = tra,
                      "Fredle Index" = fred))
  } else {return(print("Method not recognized. Please check method input."))}
}
