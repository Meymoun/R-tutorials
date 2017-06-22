

corr <- function(directory, threshold = 0, id = 1:332) {
  
  ## parse through files in directory that matches *csv
  filelist <- Sys.glob(file.path(directory, "*csv"))

  ## save correlation values in vector
  correlations <- numeric()
  
  for (i in id) {
    
    ## access file by index
    ff <- read.csv(filelist[i])
    
    ## identify rows with 4 non-missing values, can I use something else? 
    #not_na <- (rowSums(!is.na(ff)) == 4)
    
    ## returns object with incomplete cases (rows containing NAs) removed
    ## gives the same result as with not_na and the facit
    complete_observations <- na.omit(ff)
    
    #complete_observations <- (ff[not_na,])
    
    no_rows <- (nrow(complete_observations))
    
    if (no_rows > threshold) {
      
        nitrate <- numeric()
        sulfate <- numeric()
      
        nitrate <- c(nitrate, complete_observations[, "nitrate"])
        sulfate <- c(sulfate, complete_observations[, "sulfate"])
        
        corr <- cor(nitrate, sulfate)
        
        correlations <- c(correlations, corr)
    
        
        }
    
    
    }
  

  correlations
  
  
}


cr <- corr("specdata", 400)
head(cr)
summary(cr)