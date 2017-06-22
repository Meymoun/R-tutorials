# files in specdata contain 3 variables:
# Date: the date of the observation in YYYY-MM-DD format (year-month-day)
# sulfate: the level of sulfate PM in the air on that date (measured in micrograms per cubic meter)
# nitrate: the level of nitrate PM in the air on that date (measured in micrograms per cubic meter)


pollutantmean <- function(directory, pollutant, id = 1:332) {
  
    ## parse through files in directory that matches *csv
    filelist <- Sys.glob(file.path(directory, "*csv"))

    
    a <- numeric()
    
    for (i in id) {
      
        ## access file by index
        ff <- read.csv(filelist[i])
        
        
        ## each row in column 'pollutant'
        pollutant_values <- ff[,pollutant]
        
        ## logical vector, non-NA = TRUE
        select <- !is.na(pollutant_values)
        
        # only logical vector with 1 or more TRUE (remove only NA columns)
        select <- select > 0
        
        ## select non-NA values
        values <- as.numeric(pollutant_values[select])
       
        a <- c(a, values)
        
        
        }

    
    print (mean(a))

    }
    

#pollutantmean("specdata", "sulfate", 1:10)
## coursera facit: [1] 4.064128

#pollutantmean('specdata', 'nitrate', 70:72)
## coursera facit: [1] 1.706047

#pollutantmean("specdata", "nitrate", 23)
## coursera facit: [1] 1.280833


