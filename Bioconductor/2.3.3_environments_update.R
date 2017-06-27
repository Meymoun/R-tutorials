
## Environments

## in R, an environment is a set of symbol-value pairs. (similar to lists but no natural order)

e1 = new.env(hash = TRUE)
e1$a = rnorm(10)
e1$b = runif(20)

ls(e1)
# [1] "a" "b"

xx = as.list(e1)
names(xx)
# [1] "a" "b"
rm(a, envir = e1)

## Exercise 2.6
## a) create an environment and put in the chromosomal localtions of all genes on chromosome 18
## using your function from the last exercise


#my_environment$ch18 <- mappedProbes(18)

# my_environment$ch18 is a list with the probes as names
# unlist gives a character vector of chromosome location connected to probe
#chromosome18_probes <- unlist(my_environment$ch18)
#chromosome18_probes


#my_environment$remove18 <- gsub("^18", "", chromosome18_probes)

#chromosome18 <- unlist(my_environment$remove18)


# create a function that takes an environment as a function and returns a vector of stripped
# chromosomal locations


my_environment <- new.env(hash = TRUE)

myExtract <- function(envir, chromosome_number) {
  
    pattern = paste('^', chromosome_number, sep = "")
  
    findPattern = function(x) {
        grep(pattern, x, value = TRUE)  
    
    }
  
    mpProbes <- eapply(hgu95av2MAP, findPattern)
    b <- unlist(mpProbes)
    
    v <- as.character()
    
    for (i in 1:length(b)) {
      v <- c(v, b[[i]])
    }
    
    
    var_name <- paste("chromosome", chromosome_number, sep = "")
    #envir$var_name <- 
    
    envir[[var_name]] <- v
    
    # remove pattern (chromosome number)  
    envir[[var_name]] <- eapply(envir, function(x) gsub(pattern, "", x))
    #envir$var_name <- gsub(pattern, "", unlist(envir$var_name))
    #envir$var_name

    
    envir[[var_name]]

    
}

myExtract(my_environment, 18)


## how do I extract the elements from a list??
# result: vector
