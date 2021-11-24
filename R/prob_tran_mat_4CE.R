#' Creates probability transition matrix
#'
#' Creates and saves probability transition matrix, cumulative hazard increments, and cox model results in list
#'
#' @param sub_condition subset of data to be analyzed
#' @return  transition matrix, cumulative hazard increments, and cox model results
#' @export



prob.tran.mat <- function(data1 ,sub_condition, trans_matrix){

  ## Cox model stratified by transition
  c <- coxph(Surv(entry, exit, status) ~ strata(trans), data= data1, method = "breslow", subset = sub_condition)

  # msfit calculates baseline hazards
  msf <- msfit(c,  trans = trans_matrix )

  # probtrans calculates transition probabilities, prediction from day 0
  pt <- probtrans(msf, predt = 0)

  return(list(pt = pt ,msf = msf, c = c))

}
