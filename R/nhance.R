#' nhance
#' @author fanchenzashi
#' @param file xpt
#' @param output csv
#' @name nhance
#' @description xpt to csv
#' @return
#' @export nhance
#' @examples
nhance <- function(file,output){
  i <- haven::read_xpt(file)
  seqn <- data.frame(SEQN=1:max(i$SEQN))
  o <- dplyr::full_join(i,seqn,by='SEQN')
  write.csv(o,output)
}


