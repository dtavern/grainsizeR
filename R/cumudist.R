#' calculate proportion less than
#'
#' Note: this function trims the last number for plotting purposes
#'
#' @param x vector of counts
#'
#' @return vector of proportion less than the sieve size.
#' @export
#'
#' @examples
#'
cumudist <- function(x){
  total <- sum(x, na.rm = TRUE)
  new <- cumsum(c(0, x))[1:1-length(x)] / total
  return(new)
}
