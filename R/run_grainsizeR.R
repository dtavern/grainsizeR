
#' Grain size extaction from photographs
#'
#' Initialize shiny app for the grain size extraction from photographs
#'
#' @return dataframe of grain sizes
#' @export
#'
#' @examples
#'#' run.grainsizeR()  # Open app to begin grain size extraction interface

run.grainsizeR <- function(){
  shiny::runApp("inst/shiny/")
}
