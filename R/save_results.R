#' Save results
#'
#' Saves aggregated data as list
#'
#' @return list with cumulative hazards, expected lengths of stay and Cox model summaries
#' @export

save_results <- function() {


full_results <- list(pt_full = pt_full[[2]], LOS_mat_full = LOS_mat_full)

sex_results <- list(pt_male = pt_male[[2]], pt_female = pt_female[[2]],
                    LOS_mat_male = LOS_mat_male, LOS_mat_female = LOS_mat_female)

age_results <- list(p_age1 = p_age1[[2]], p_age2 = p_age2[[2]], p_age3 = p_age3[[2]], p_age4 = p_age4[[2]],
                    p_age5 = p_age5[[2]], p_age6 = p_age6[[2]],  LOS_mat_age1 =
                      LOS_mat_age1, LOS_mat_age2 = LOS_mat_age2, LOS_mat_age3 = LOS_mat_age3,
                    LOS_mat_age4 = LOS_mat_age4, LOS_mat_age5 = LOS_mat_age5,
                    LOS_mat_age6 = LOS_mat_age6)

wave_results <- list(p_wave1 = p_wave1[[2]], p_wave2 = p_wave2[[2]], p_wave3 = p_wave3[[2]],
                     LOS_mat_wave1 = LOS_mat_wave1,
                     LOS_mat_wave2 = LOS_mat_wave2, LOS_mat_wave3 = LOS_mat_wave3)

comprsk_results <- list(Cox_Death = Cox_Death, Cox_Dis = Cox_Dis, Cox_Death_FG = Cox_Death_FG,
                        Cox_Dis_FG = Cox_Dis_FG)

final_results <- list(full_results = full_results, sex_results = sex_results,
                      age_results = age_results, wave_results = wave_results,
                      comprsk_results = comprsk_results)
return(final_results)


}
