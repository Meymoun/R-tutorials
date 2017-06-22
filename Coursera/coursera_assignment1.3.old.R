

corr <- function(directory, threshold = 0, id = 1:332) {
  
  ## parse through files in directory that matches *csv
  filelist <- Sys.glob(file.path(directory, "*csv"))
  
  
  # should be inside "for (i in id)" - loop
  nitrate <- numeric()
  sulfate <- numeric()
  
  correlations <- numeric()
  
  for (i in id) {
    
    ## access file by index
    ff <- read.csv(filelist[i])
    
    ## TRUE = both column "nitrate" and column "sulfate" contain observations
    logical_vector <- logical()
    
    ## loop through all rows
    for (j in 1:nrow(ff)) {
      
        n <- ff[j, "nitrate"]
        s <- ff[j, "sulfate"]
      
        lv <- !is.na(n) & !is.na(s) == TRUE
        logical_vector <- c(logical_vector, lv)

        nitrate <- c(nitrate, n[lv])
        sulfate <- c(sulfate, s[lv])
      
    }
    
  
    ## TRUE = 1, number of observations
    no_observations <- sum(logical_vector)
    
    if (no_observations > threshold) {
      
        corr <- cor(sulfate, nitrate)
        print (corr)
        correlations <- c(correlations, corr)
      
    }
    
 
  }
  
  #print (correlations)
  correlations
  
  
}

cr <- corr("specdata", 400, 1:10)
head(cr)
summary(cr)
length(cr)