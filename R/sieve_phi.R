#' sieve data (phi)
#'
#' @param x vector containing individual measurements
#' @param sieve_sizes vector containing sieve sizes in phi scale in ascending order
#'
#' @return dataframe containing sieve sizes and according number of particles retained within each sieve
#' @export
#'
#' @examples
#'

sieve.phi <- function(x, sieve_sizes = -log2(c(8,11,16,22.6,32,45,64,90,128,180,256,360,512,1024))){

  df <- data.frame("size.phi" = character(0),
                   "count" = integer(0))
  min_size <- data.frame("size.phi" = as.character(paste(">", max(sieve_sizes))),
                         "count" = sum(x >= max(sieve_sizes)))
  df <- rbind(df, min_size)

  for (i in sieve_sizes){
    if (i == min(sieve_sizes)) {
      size <- data.frame("size.phi" = as.character(i),
                         "count" = sum(x < i))
      df <- rbind(df, size)
    } else {

      size <- data.frame("size.phi" = as.character(i),
                         "count" = sum(
                           x < i & x >= sieve_sizes[match(i, sieve_sizes)+1]
                         ))
      df <- rbind(df, size)
      df$size.phi <- as.factor(df$size.phi)
    } # end ELSE
  }# endFOR

  return(df)

}
