#' Extend data frame for mstate
#'
#' Prepares data frame for use in mstate package
#' 
#' @param dataset data frame of observed transitions
#' @param traM: transition matrix of multi-state model used in mstate
#' @return  data frame with rows of all possible transitions for which a patient is at risk
#' @export



# function for preparing data set for mstate package

ext_mstate <- function(dataset,traM)
{   
  ## Authors: Jerome Lambert, Derek Hazard
  ## Creates data frame for use in mstate package
  ## 
  ##
  ## Args:
  ##    dataset: data frame of observed transitions
  ##    traM: transition matrix of multi-state model used in mstate
  ##
  ## Returns:
  ##    data frame with rows of all possible transitions for which a 
  ##    patient is at risk
  
  
  ## trabis is just a different way to describe all transitions
  trabis <- cbind(traM[!is.na(traM)]
                  , which(!is.na(traM),arr.ind=T))
  
  colnames(trabis) <- c("trans","from","to")
  rownames(trabis) <- NULL
  trabis <- as.data.frame(trabis)
  trabis <- trabis[order(trabis$from,trabis$to),]
  
  ## matCens : will be used for generating dummy transitions 
  ## based on observed CENSORED transitions
  
  matCens <-  trabis
  
  ### matObs : will be used for generating  dummy transitions
  ## based on observed ACTUAL transitions
  matObs <- NULL
  for (i in  1:nrow(trabis))
  {
    dumti <- subset(trabis, 
                    from==trabis$from[i] & to !=trabis$to[i] )
    dumi <- cbind(rep(trabis$trans[i],nrow(dumti)),dumti)
    matObs <- rbind(matObs,dumi)
  }
  names(matObs) <- c("trans","dumtrans","from","dumto")
  
  
  ### generate dummy transitions for   
  ##  observations   without censoring
  datObs <- subset(dataset, to!="cens")
  datObs_ext <- datObs
  
  for (i in 1:nrow(matObs)){
    # subset data frame for a transition  
    trans1a <- subset(datObs, trans==matObs$trans[i])
    # indicates dummy transition
    trans1a$status <- 0
    # dummy 'to'
    trans1a$to <- matObs$dumto[i]
    # dummy transition
    trans1a$trans <- matObs$dumtrans[i]
    # extend data frame
    datObs_ext <- rbind(datObs_ext, trans1a)
  }  
  
  ### generate dummy transitions for 
  ## censored observations   
  datCens <- subset(dataset, to=="cens")
  datCens_ext <- NULL
  for (i in 1:nrow(matCens))
  {
    transi <- subset(datCens, from==matCens$from[i] )
    if(nrow(transi)!=0) {
      transi$status <- 0
      transi$trans <-  matCens$trans[i]
      transi$to <-  matCens$to[i]
      datCens_ext <- rbind(transi,datCens_ext)
    }
  }
  
  
  ## reunite and order dataframe by id, entry time, state
  datEXT <- rbind(datObs_ext, datCens_ext)
  datEXT <- datEXT[order(datEXT$id,datEXT$entry,datEXT$from),] 
}
