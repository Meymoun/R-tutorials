## The apply family of functions

# apply, lapply, sapply, 
# eapply applying a function to each element of an environment

# hgu95avMAP environment contains the mappings between Affymetrix identifiers and chromosome band locations
# "1001_at" probe maps "1p34-p33"
library("hgu95av2.db")
hgu95av2MAP$"1001_at"
# [1] "1p34-p33"

# grep(): matching pattern, ^ = in beginning of word
# grep() returns matching value
# eapply: apply in each element of the environment
# anonymous function
myPos = eapply(hgu95av2MAP, function(x) grep("^17p", x, value = TRUE))
myPos = unlist(myPos)
length(myPos)

# also possible to name the function and then apply: 

f17p = function(x) grep("^17p", x, value = TRUE)
myPos2 = eapply(hgu95av2MAP, f17p)
myPos2 = unlist(myPos2)

identical(myPos, myPos2)
# [1] TRUE


## Exercise 2.5
## create a function that can find and return the probes that map to any chromosome

mappedProbes = function(chromosome_number) {
  pattern = paste('^', chromosome_number, sep = "")
  
  findPattern = function(x) {
    grep(pattern, x, value = TRUE)  
    
  }
  
  eapply(hgu95av2MAP, findPattern)
}


myPos3 = mappedProbes(15)
myPos3 = unlist(myPos3)
myPos3


################################

