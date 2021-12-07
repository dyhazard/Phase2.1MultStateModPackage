# 4CE_Phase2.1_MultStateModPackage

R code to run and submit the analysis for the multi-state models project. The code should take about 30 minutes to run. We appreciate your collaboration!

# Important details to running the R script

## Always RESTART your R session before installing or re-installing the package!
## The package uses the Phase 2.1 LocalPatientSummary.csv
## Missing values in the LocalPatientSummary.csv should be given "NA" 
## Make sure R packages listed in the code are already installed

User needs to enter to 4 values noted with "### Enter own value"
1. Local site same ("site_name")
2. Administrative censoring date ("last_date")
3. Directory with the Phase 2.1 LocalPatientSummary.csv file ("dir.LocPatSum")
4. Directory for the output (dir.output)

Note again: Missing values in the LocalPatientSummary.csv should be given "NA"

# Run the following script in R 

```{r, echo=TRUE, message=FALSE, warning=FALSE ,include=FALSE}

# Install packages if not already installed
library(devtools)
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


rm(list=ls())


devtools::install_github("https://github.com/dyhazard/Phase2.1MultStateModPackage", upgrade=FALSE, ref="master", force=T)


### Enter own value
# Give site name
site_name <- "Freiburg"

### Enter own value
# Give date of administrative censoring (last date data were collected) in year-month-day
last_date <- "2021-10-31"

### Enter own value
# Directory with the Phase 2.1 LocalPatientSummary.csv file (should be .csv format)
dir.LocPatSum <- "/Users/dyhazard/Documents/LocalPatientSummary.csv"

### Enter own value
# Directory for results
dir.output <- "/Users/dyhazard/Documents/Output"


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






```


# Submit Results

1. The code produces a pdf report and an R object list of aggregated results  Either post on Slack channel or send results to hazard@imbi.uni-freiburg.de
