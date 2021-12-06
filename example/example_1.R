rm(list=ls())


devtools::install_github("https://github.com/dyhazard/Phase2.1MultStateModPackage", upgrade=FALSE, ref="master", force=T)

### Enter own value
# Give site name
site_name <- "Freiburg"

### Enter own value
# Give date of administrative censoring (last date data were collected) in year-month-day
last_date <- "2021-10-31"

### Enter own value
# Directory with the LocalPatientSummary.csv file (should be .csv format)
dir.LocPatSum <- "/Users/dyhazard/Documents/LocalPatientSummary.csv"

### Enter own value
# Directory for results
dir.output <- "/Users/dyhazard/Documents/Output"




# Install packages if not already installed
library(readr)
library(mstate)
library(dplyr)
library(survival)
options(kableExtra.latex.load_packages = FALSE)
library(kableExtra)
library(lubridate)
library(tableone)
library(papeR)
library(rmarkdown)
library(Phase2.1MultStateModPackage)

# Create pdf Report
render(file.path(system.file("rmd", "4CE_Phase21_MSM.Rmd", package = "Phase2.1MultStateModPackage")),
       output_file = paste(site_name), output_dir = dir.output,
       envir = parent.frame(), params = list(dir_LPS = dir.LocPatSum, admin_censor = last_date,
                                             site_loc = site_name))

# Create object with aggregated results
final_results <- save_results()

# Save results in output directory
save(final_results ,file = file.path(dir.output, paste(site_name,"_MSM_Results.Rda")))

