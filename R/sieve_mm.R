
#' Sieve data (mm)
#'
#' @param x a list of grain size measurements
#' @param sieve_sizes a vector containing desired sieve sizes in order of ascending size
#'
#' @return a dataframe of sieve sizes and associated counts of particles sieved at that size
#' @export
#'
#' @examples
#'
sieve.mm <- function(x, sieve_sizes = c(8,11,16,22.6,32,45,64,90,128,180,256,360,512,1024)){
  sieve_lookup <- data.frame("number" = seq(1:length(sieve_sizes)),
                             "size"  =  sieve_sizes)

  df <- data.frame("size.mm" = numeric(0),
                   "count" = integer(0))
  min_size <- data.frame("size.mm" = 0,
                        "count" = sum(x <= min(sieve_sizes)))
  df <- rbind(df, min_size)

  for (i in sieve_sizes){
    if (i == max(sieve_sizes)) {
      size <- data.frame("size.mm" = i,
                         "count" = sum(x > i))
      df <- rbind(df, size)
    } else {

    size <- data.frame("size.mm" = i,
                       "count" = sum(
                         x > i & x <= sieve_sizes[match(i, sieve_sizes)+1]
                       ))
      df <- rbind(df, size)
    } # end ELSE
  }# endFOR

  return(df)

}
