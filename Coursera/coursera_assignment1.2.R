# files in specdata contain 3 variables:
# Date: the date of the observation in YYYY-MM-DD format (year-month-day)
# sulfate: the level of sulfate PM in the air on that date (measured in micrograms per cubic meter)
# nitrate: the level of nitrate PM in the air on that date (measured in micrograms per cubic meter)



complete <- function(directory, id = 1:332) {
  
  ## parse through files in directory that matches *csv
  filelist <- Sys.glob(file.path(directory, "*csv"))
  
  ## number of observations
  nobs <- integer()
  
  for (i in id) {
    
    ## access file by index
    ff <- read.csv(filelist[i])
    
    ## TRUE = both column "nitrate" and column "sulfate" contain observations
    logical_vector <- logical()
    
    ## loop through all rows
    for (j in 1:nrow(ff)) {
      
        n <- ff[j, "nitrate"]
        s <- ff[j, "sulfate"]
    
        ## are both conditions TRUE?
        lv <- !is.na(n) & !is.na(s) == TRUE
        
        logical_vector <- c(logical_vector, lv)
        
    }
      
    ## TRUE = 1, sum all trues
    no_observations <- sum(logical_vector)
    
    ## add result to vector
    nobs <- c(nobs, no_observations)
    
    
  }
  
  ## bind id to number of observations by column
  ma <- cbind(id, nobs)
  print (ma)
  
  
  
}

complete("specdata", 3)
