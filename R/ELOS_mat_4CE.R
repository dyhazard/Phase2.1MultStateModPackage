#' Expected Length of Stay Matrix
#'
#' Function for creating expected length of stay and probability of being in hospital matrix
#'
#' @param pt probability transition matrix
#' @param end_day days after admission for which estimation should occur
#' @param sub_condition subgroup to be analyzed
#' @param boot_n number of bootstrap samples for confidence inteval estimation
#' @return  list with expected length of stay matrix and bootstrapped confidence intervals
#' @export


ELOS_mat <- function( pt, end_day, sub_condition, boot_n){

  # Get point estimates
  LOS_mat_2 <- ELOS(pt, end_day)
  LOS_vec <- LOS_mat_2[1,1] + LOS_mat_2[1,2]

  my.data_sub <- subset(my.data_ext, sub_condition)

  # change class of data frame for msboot
  class(my.data_sub) <- c("msdata"  , "data.frame")

  set.seed(1905)
  Example_boot <- msboot(theta = LOS_boot, data = my.data_sub , id="id", B= boot_n,
                         days_from_adm = end_day)

  # Expected time non-severe
  CI_hosp <- quantile(Example_boot[1, ], probs=c(0.025, 0.975))

  # Expected time severe
  CI_severe <- quantile(Example_boot[2, ], probs=c(0.025,0.975))

  LOS_CI <- CI_hosp + CI_severe



  temp_data <- pt[[1]][pt[[1]]$time <= end_day,]
  stay_vec <- temp_data[nrow(temp_data), c(2,3)]
  stay <- sum(stay_vec)

  # standard error for probabilities
  stay_vec_se <- temp_data[nrow(temp_data), c(6,7)]
  stay_se <- sum(stay_vec_se)

  LOS_mat <- c(round(LOS_vec,3),round(LOS_CI[1],3), round(LOS_CI[2],3), round(stay, 3), round(stay_se, 3))
  LOS_mat <- as.matrix(LOS_mat)



  label1 <- paste("Expected length of hospital stay in days at day", end_day)
  label2 <- paste("Lower bound of 95% Conf. Int.")
  label3 <- paste("Upper bound of 95% Conf. Int.")
  label4 <- paste("Probability of being in the hospital at day", end_day)
  label5 <- paste("Standard error", end_day)
  rownames(LOS_mat) <- c(label1, label2, label3, label4, label5)
  return(list(LOS_mat = LOS_mat, CI_hosp = CI_hosp, CI_severe = CI_severe  ))

}
