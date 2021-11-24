#' Run analysis
#'
#' runs multi-state analyses
#'
#' @param dir_LocalPatientSummary path to the Local Patient Summary .csv file
#' @param dir.output directory to results
#' @param site_name name of local site
#' @param adm_cens last day of data collection
#' @return results in html and R object
#' @export




run_analysis <- function(dir_LocalPatientSummary, dir.output, site_name, adm_cens, workd1) {



library(readr)
library(mstate)
library(dplyr)
library(sjPlot)
library(survival)
library(kableExtra)
library(lubridate)
library(table1)
library(rmarkdown)
library(Phase2.1MultStateModPackage)




render(file.path(system.file("rmd", "4CE_Phase21_MSM.Rmd", package = "Phase2.1MultStateModPackage")), output_file = paste(site_name,"_MSM"),
                  output_dir = dir.output, knit_root_dir = workd1, envir = parent.frame(), params = list(dir_LPS =dir_LocalPatientSummary, admin_censor = adm_cens))

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


save(final_results ,file = paste(dir.output, site_name, "_MSM_Results.Rda"))

}
