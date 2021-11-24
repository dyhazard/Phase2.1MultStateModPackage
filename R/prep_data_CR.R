#' Prepare Competing Risks
#'
#' Create data set for competing risks model
#' 
#' @param data_set data frame to be converted
#' @return  data frame prepared for competing risks model
#' @export 


prep_data_CR <- function(data_set) {

my.data <- data_set
## subset to only transition to death and discharge
my.data_CR <- subset(my.data, my.data$to == 3 | my.data$to == 4 | my.data$to == 'cens')
my.data_CR$event <- ifelse(my.data_CR$to == 4 , 1, ifelse(my.data_CR$to == 3, 2 , 0))
my.data_CR$entry <- 0

table(my.data_CR$event)

my.data_CR$age_cat <- factor(my.data_CR$age_cat, ordered = FALSE)
my.data_CR$age_cat <- relevel(my.data_CR$age_cat, ref="26-49")
table(my.data_CR$age_cat)

my.data_CR$wave <- factor(my.data_CR$wave, ordered = FALSE)
my.data_CR$wave <- relevel(my.data_CR$wave, ref="1")
table(my.data_CR$wave)
return(my.data_CR)

}