# 4CE_Phase2.1_MultStateModPackage

R code to run and submit the analysis for the multi-state models project. The code should take about 30 minutes to run. We appreciate your collaboration!

# Important details to running the R script 

User needs to enter to 4 values noted with "### Enter own value"
1. Local site same ("site_name")
2. Administrative censoring date ("last_date")
3. Directory with the Phase 2.1 LocalPatientSummary.csv file ("dir.LocPatSum")
4. Directory for the output (dir.output)

Note: Missing values in the LocalPatientSummary.csv should be given "NA"

# Run the following script in R 

```{r, echo=TRUE, message=FALSE, warning=FALSE ,include=FALSE}
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
# Directory for results/output
dir.output <- "/Users/dyhazard/Documents/Output"


# Working Directory
workd1 <- getwd()


# Install packages if not already installed
library(readr)
library(mstate)
library(dplyr)
library(survival)
library(kableExtra)
library(lubridate)
library(tableone)
library(papeR)
library(rmarkdown)
library(Phase2.1MultStateModPackage)

# Create HTML Report
render(file.path(system.file("rmd", "4CE_Phase21_MSM.Rmd", package = "Phase2.1MultStateModPackage")),
       output_file = paste(site_name,"_MSM"), output_dir = dir.output, knit_root_dir = workd1,
       envir = parent.frame(), params = list(dir_LPS = dir.LocPatSum, admin_censor = last_date,
                                             site_loc = site_name))

# Create object with aggregated results
final_results <- save_results()

# Save results in output directory
save(final_results ,file = file.path(dir.output, paste(site_name,"_MSM_Results.Rda")))





```


# Submit Results

1. In the interim, please send results to hazard@imbi.uni-freiburg.de
