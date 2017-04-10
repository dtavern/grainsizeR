#' Compute mean grain size from cumulative size distribution
#'
#' @param sieve_size vector of sieve sizes related to input cumulative distribution
#' @param cumu cumulative distribution pertaining to sieve sizes
#' @param units sieve size units "phi" = phi scale, "mm" = milimeter (metric) scale
#' @param method Algebraic: "inm" = Inman (1952) very simple calculation focus on central data;"tra" = Trask (1932) use interquartile values;"fw" = Folk and Ward (1957) incorporate median value to Inman equation;"brig" = Briggs (1977) use all percentile values (10, 20, 30...80, 90) to incorprate distribution;"mccam" = McCammon (1962) Similar to Briggs but on the 5th percentiles. Geometric: "sqrt" = Geometric approach similar to Inman but with metric log-normal distributions;"cubr" = Similar to square root but incorporate D50;"log" = Log transform metric data to calculate and backtransform result to original units (works for log-normal distributions); "all" = All outputs into a dataframe
#'
#' @return dataframe or value containing specified measures of mean
#' @export
#'
#' @examples
#'
#' @source see Bunte and Abt (2001) for examples and equations. Bunte, Kristin, and Steven R. Abt. "Sampling surface and subsurface particle-size distributions in wadable gravel-and cobble-bed streams for analyses in sediment transport, hydraulics, and streambed monitoring." (2001).

stat.mean <- function(sieve_size, cumu, units = "phi", method = "all"){
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
  p15 <- stat.dx(sieve_size, cumu, d = 0.15, phi = phi_in)
  p16 <- stat.dx(sieve_size, cumu, d = 0.16, phi = phi_in)
  p20 <- stat.dx(sieve_size, cumu, d = 0.20, phi = phi_in)
  p25 <- stat.dx(sieve_size, cumu, d = 0.25, phi = phi_in)
  p30 <- stat.dx(sieve_size, cumu, d = 0.30, phi = phi_in)
  p35 <- stat.dx(sieve_size, cumu, d = 0.35, phi = phi_in)
  p40 <- stat.dx(sieve_size, cumu, d = 0.40, phi = phi_in)
  p45 <- stat.dx(sieve_size, cumu, d = 0.45, phi = phi_in)
  p50 <- stat.dx(sieve_size, cumu, d = 0.50, phi = phi_in)
  p55 <- stat.dx(sieve_size, cumu, d = 0.55, phi = phi_in)
  p60 <- stat.dx(sieve_size, cumu, d = 0.60, phi = phi_in)
  p65 <- stat.dx(sieve_size, cumu, d = 0.65, phi = phi_in)
  p70 <- stat.dx(sieve_size, cumu, d = 0.70, phi = phi_in)
  p75 <- stat.dx(sieve_size, cumu, d = 0.75, phi = phi_in)
  p80 <- stat.dx(sieve_size, cumu, d = 0.80, phi = phi_in)
  p85 <- stat.dx(sieve_size, cumu, d = 0.85, phi = phi_in)
  p84 <- stat.dx(sieve_size, cumu, d = 0.84, phi = phi_in)
  p90 <- stat.dx(sieve_size, cumu, d = 0.90, phi = phi_in)
  p95 <- stat.dx(sieve_size, cumu, d = 0.95, phi = phi_in)

  # Arithmetic
  if (method == "inm"){
    inm <- (p16 + p84) / 2
    return(inm)
  }
  if (method == "tra"){
    tra <- (p25 + p75) / 2
    return(tra)
  }
  if (method == "fw"){
    fw <- (p16 + p50 + p84) / 3
    return(fw)
  }
  if (method == "brig"){
    brig <- (p10+p20+p30+p40+p50+p60+p70+p80+p90)/9
    return(brig)
  }
  if (method == "mccam"){
    mccam <- (p05+p15+p25+p35+p45+p55+p65+p75+p85+p95)/10
    return(mccam)
  }

  ## Graphic geometric methods
  if (method == "sqrt"){
    sqrt <- sqrt(p84 * p16)
    return(sqrt)
  }
  if (method == "cubr"){
    cubr <- (p84 * p50 * p16) ^ (1/3)
    return(cubr)
  }
  if (method == "log"){
    log <- 10^(log10(p16*p84)/2)
    return(log)
  }
  if (method == "all"){
    inm <- (p16 + p84) / 2
    tra <- (p25 + p75) / 2
    fw <- (p16 + p50 + p84) / 3
    brig <- (p10+p20+p30+p40+p50+p60+p70+p80+p90)/9
    sqrt <- sqrt(p84 * p16)
    cubr <- (p84 * p50 * p16) ^ (1/3)
    log <- 10^(log10(p16*p84)/2)

    return(data.frame("Folkward" = fw,
                      "Inman" = inm,
                      "Trask" = tra,
                      "Briggs" = brig,
                      "Geometric_sqrt" = sqrt,
                      "Geometric_cuberoot" = cubr,
                      "Geometric_log" = log))
  }

}
