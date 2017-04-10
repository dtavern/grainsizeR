#' percentile return
#'
#' @param sieve_size vector of sieve sizes
#' @param cumu vector of corresponding cumulative distribution values
#' @param d percentile value (decimal)
#' @param phi logical to state if using phi units or not
#'
#' @return value of grain size of desired percentile value
#' @export
#'
#' @examples
#'
stat.dx <- function(sieve_size, cumu, d = 0.5, phi = FALSE){
  ## Input check
  if(d > 1 | d < 0){
    warning(message("Percentile value exceeds the bounds of 0 and 1. Please convert to decimal."))
  }
  ## If percentile value falls on the exact cumulative distribution, return the sieve size
  if(sum(cumu == d) >= 1){
    ref_df <- data.frame(sieve_size, cumu)
    val <- ref_df$sieve_size[which(ref_df$cumu == d)]
    return(val)
  }
  ## Check for phi scale or metric (due to reversal of signage) If true:
  if(isTRUE(phi)){
    ref_df <- data.frame(sieve_size, cumu)
    # Look for the coarsest sieve that is finer than d
    x1 <- min(
      ref_df$sieve_size[which(ref_df$cumu <= d)]
    )
    # Look for the finest sieve that is coarser than d
    x2 <- max(
      ref_df$sieve_size[which(ref_df$cumu >= d)]
    )
    # Find the associated percentages finer than for each x1 and x2
    y1 <- max(
      ref_df$cumu[which(ref_df$cumu <= d)]
    )
    y2 <- min(
      ref_df$cumu[which(ref_df$cumu >= d)]
    )

  } else {
  ref_df <- data.frame(sieve_size, cumu)
  # Find the coarsest sieve finer than d
  x1 <- max(
    ref_df$sieve_size[which(ref_df$cumu <= d)]
    )
  # Find finest sieve coarser than d
  x2 <- min(
    ref_df$sieve_size[which(ref_df$cumu >= d)]
  )
  # Find associated percentage values for x1 and x2
  y1 <- max(
    ref_df$cumu[which(ref_df$cumu <= d)]
  )
  y2 <- min(
    ref_df$cumu[which(ref_df$cumu >= d)]
  )}
  # Determine the percentage finer than input d using linear interpolation between x1 and x2
  val <- (x2 - x1) * ((d - y1) / (y2 - y1)) + x1


  # return
  return(val)
}
