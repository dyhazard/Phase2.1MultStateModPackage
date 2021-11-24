#' Bootstrap Length of Stay
#'
#' Function for bootstrap confidence intervals
#' 
#' @param data1 data frame with rows of all possible transitions for which a patient is at risk (i.e. returned data frame from ext_mstate function)
#' @param days_from_adm   number of days since admission for which estimation of duration in states is performed
#' @return  vector with c(1,2,...): non-severe/severe duration estimates for patients non-severe at admission   c(...,3,4,...): non-severe/severe duration estimates for patients severe at admission   c(...,5): length of severe stay estimates for entire cohort
#' @export



# function for bootstrap confidence intervals
#source("LOS_boot.R")

LOS_boot <- function(data1,  days_from_adm )
{
  ## Authors: Derek Hazard, Jerome Lambert
  ## Returns the duration/length of stay estimates for each bootstrap cohort for use with msboot function in mstate package
  ##
  ##
  ## Args:
  ##    data1: data frame with rows of all possible transitions for which a 
  ##    patient is at risk (i.e. returned data frame from ext_mstate function)
  ##    init_dis : distribution of patients in initial states at day 0
  ##    days_from_adm  : number of days since admission for which estimation
  ##    of duration in states is performed
  ##
  ## Returns:
  ##    vector with c(1,2,...): non-severe/severe duration estimates for patients non-severe at admission
  ##    c(...,3,4,...): non-severe/severe duration estimates for patients severe at admission
  ##    c(...,5): length of severe stay estimates for entire cohort
  
  # Cox model stratified by transition
  coxf <- coxph(Surv(entry, exit, status) ~ strata(trans), data1, method = "breslow")
  
  # msfit calculates baseline hazards
  msf_f <- msfit(coxf,trans = tra)
  
  # probtrans calculates transition probabilities, prediction from day 0
  pt_f <- probtrans(msf_f, predt = 0)
  
  # ELOS gives expected length of stay for given days since admission for patients in the states at day 0
  LOS_f <- ELOS(pt_f, days_from_adm)
  
  # Determine initial distribution of patients at time = 0
  # Subset of transitions from time = 0
  data1_start1 <- subset(data1, data1$entry ==0)
  
  # Keep relevant variables
  data1_start2 <- data.frame(data1_start1$id, data1_start1$from)
  
  # Remove multiple entries
  data1_start3 <- unique(data1_start2)
  
  colnames(data1_start3) <- c("id", "from")
  
  # Count of patients in each initial state
  temp_table <- table(data1_start3$from)
  
  # Calculate initial proportions, no patients are discharged or dead at admission
  init_dis <- c(temp_table[1]/nrow(data1_start3), temp_table[2]/nrow(data1_start3), 0, 0)
  
  # Multiply LOS_mat_1 with initial distribution to get weighted average of expected lengths of stay for entire cohort
  LOS_f_init <- init_dis %*% LOS_f
  
  # Return estimates    
  return(c(LOS_f[1,1:2],LOS_f[2,1:2], LOS_f_init[1:2]))
} 
