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
  if(d > 1 | d < 0){
    warning(message("Percentile value exceeds the bounds of 0 and 1. Please convert to decimal."))
  }
  if(sum(cumu == d) >= 1){
    ref_df <- data.frame(sieve_size, cumu)
    val <- ref_df$sieve_size[which(ref_df$cumu == d)]
    return(val)
  }
  if(isTRUE(phi)){
    ref_df <- data.frame(sieve_size, cumu)
    x1 <- min(
      ref_df$sieve_size[which(ref_df$cumu <= d)]
    )
    x2 <- max(
      ref_df$sieve_size[which(ref_df$cumu >= d)]
    )
    y1 <- max(
      ref_df$cumu[which(ref_df$cumu <= d)]
    )
    y2 <- min(
      ref_df$cumu[which(ref_df$cumu >= d)]
    )

  } else {
  ref_df <- data.frame(sieve_size, cumu)
  x1 <- max(
    ref_df$sieve_size[which(ref_df$cumu <= d)]
    )
  x2 <- min(
    ref_df$sieve_size[which(ref_df$cumu >= d)]
  )
  y1 <- max(
    ref_df$cumu[which(ref_df$cumu <= d)]
  )
  y2 <- min(
    ref_df$cumu[which(ref_df$cumu >= d)]
  )}

  val <- (x2 - x1) * ((d - y1) / (y2 - y1)) + x1



  return(val)
}
