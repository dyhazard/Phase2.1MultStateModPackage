#' Prepare Data
#'
#' This function creates a data frame in long format with the covariates of interest
#' 
#' @param dir.input Path to the input file
#' @param last_day Last date when the local data set was updated
#' @return The data frame in long format with covariates
#' @export

prep_data <- function(dir.input, last_day) {

data <- read_csv(dir.input)
names(data)

# Generate new covariates


# Wave
wave1 <- interval(ymd("2020-01-01"), ymd("2020-07-31"))
wave2 <- interval(ymd("2020-08-01"), ymd("2021-06-30"))
wave3 <- interval(ymd("2021-07-01"), ymd(last_day))


data$wave1_ind <- data$admission_date %within% wave1
data$wave2_ind <- data$admission_date %within% wave2
data$wave3_ind <- data$admission_date %within% wave3


data$wave <- ifelse(data$wave1_ind == "TRUE", 1, ifelse(data$wave2_ind == "TRUE", 2, 3))
table(data$wave)


# Age groups

data <- data %>% 
  mutate(age_cat = case_when(
    age_group == c('00to02') ~ 1,
    age_group == c('03to05') ~ 1,
    age_group == c('06to11') ~ 1,
    age_group == c('12to17') ~ 2,
    age_group == c('18to25') ~ 2,
    age_group == c('26to49') ~ 3,
    age_group == c('50to69') ~ 4,
    age_group == c('70to79') ~ 5,
    age_group == c('80plus') ~ 6,

  ))

data$age_cat <- factor(data$age_cat, labels = c("00-11", "12-25", "26-49","50-69","70-79", "80+"))
data$age_cat <- relevel(data$age_cat, ref="26-49")


# Add vector of possible administrative censoring time
data$adm_censoring_date <- rep(last_day, nrow(data))



# State 0: Censored
# State 1: Non-severe
# State 2: Severe
# State 3: Discharge
# State 4: Death
table(data$deceased)
table(data$still_in_hospital)
data$severe_date[data$severe_date=='1900-01-01']                 <-NA
data$last_discharge_date[data$last_discharge_date=='1900-01-01'] <-NA

# state 1
state1 <- data
state1$id    <- state1$patient_num
state1$entry <- 0
state1$exit  <- pmin(state1$severe_date - state1$admission_date,
                     state1$last_discharge_date - state1$admission_date, na.rm = T)

state1$from  <- 1
state1$to    <- ifelse(state1$severe == 1,2,
                       ifelse(state1$deceased == 1,4,
                              ifelse(state1$still_in_hospital==1 & state1$severe==0,0,3)))
table(state1$to)



state1       <- subset(state1, select=c("id", "admission_date", "adm_censoring_date", "age_cat", "sex","wave", "entry","exit","from","to"))


###################################################################################
# state 2
state2       <- data[data$severe==1,]
state2$id    <- state2$patient_num
state2$entry <-  pmin(state2$severe_date - state2$admission_date,
                      state2$last_discharge_date - state2$admission_date,
                      na.rm = T)


state2$exit  <- pmin(state2$last_discharge_date - state2$admission_date,
                     na.rm = T)
state2$from  <- 2
state2$to    <- ifelse(state2$deceased==1,4,
                       ifelse(state2$deceased==1,4,
                              ifelse(state2$still_in_hospital==1,0,3)))
table(state2$to)
state2       <- subset(state2, select=c("id", "admission_date", "adm_censoring_date", "age_cat", "sex","wave", "entry","exit","from","to"))
#table(state1$to)
summary(as.numeric(state2$exit))
#hist(as.numeric(state1$exit))
#table(state2$to)

state <- rbind(state1,state2)
state[order(state$id),]


# give patients that are still in hospital a censoring time
state[is.na(state$exit),]$exit <- state[is.na(state$exit),]$adm_censoring_date - 
                                               state[is.na(state$exit),]$admission_date



table(state$to)

# Change 'entry' and 'exit' to numeric
state$entry <- as.numeric(state$entry)
state$exit <- as.numeric(state$exit)





# order by id
state <- state[order(state$id),]

# Add a half-day transition from Non-Severe to Severe for patients with same day transitions
state <- state %>% 
  mutate(entry = lag(ifelse((entry == exit) & (to == 2), lead(entry) +0.5, lead(entry)), default = first(entry)))

state[(state$entry == state$exit) & (state$to == 2),]$exit <- state[(state$entry == state$exit) & (state$to == 2),]$exit + 0.5

# Add a half-day to same day transitions hospital to discharge or death for patients with same day transitions

state[(state$entry == state$exit) & (state$to != 2) & !is.na(state$exit),]$exit <- state[(state$entry == state$exit) & (state$to != 2) & !is.na(state$exit),]$exit + 0.5

# For patients who had two transitions on day one (non-severe -> severe -> death/discharge), they now have severe before death. Make their exit time one.
state[(state$exit < state$entry) & !is.na(state$exit) ,]$exit <- 1


# give patients that are still in hospital a censoring time
state[is.na(state$exit),]$exit <- as.numeric(state[is.na(state$exit),]$adm_censoring_date - 
                                               state[is.na(state$exit),]$admission_date)


# Add status vector, indicates observed transition
state$status <- 1

# Status vector for censored observations set to '0'
state$status[state$to == 0] <- 0

# Rename 'to' == 0  to 'cens' for use in 'ext_mstate' function
state$to[state$to == 0] <- 'cens'




return(state)

}
