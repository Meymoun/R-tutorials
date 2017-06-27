## Basic R

## Exercise 2.3

## a) create vectors
x <- c(0.1, 1.2, 2.5, 10)
y <- as.integer(1:100)
z <- y < 10
pets <- c("dog", "cat", "bird")
pet_names <- c("Doggo", "Catto", "Birdman")

names(pet_names) <- pets
pet_names

## b) vectors in arithmetic expressions
2 * x + c(1, 2)
## every element in x is multiplied with 2, 
## c(1, 2) is recycled to match lenght of x: c(1, 2, 1, 2)
## 2 * every element in x, then first element of the result adds to first element 
## of c(1, 2, 1, 2), 2nd element with 2nd, 3rd with 3rd etc. 

## c) index vectors to select subsets of elements of a vector
## 3 different ways: vector[index], vector[name], vector[logical]

## select element of a list
## list[[index]], list[[name]]
## create a list: list(vector1, vector2, vector3)

## difference between a dataframe and a matrix:
## dataframe can store elements in different classes, matrix can only store elements in the same class


#################################

## Functions

## 2.3.1

sq1 = function(x) return (x*x)
sq2 = function(x) x*x

## Exercice 2.4
## function that takes a string as input and reurn that string with a caret prepended
## ppc('xx') returns '^xx'

ppc = function(x) {
  
    (paste('^', x, sep = ""))

    }

########################################

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

my_environment = new.env(hash = TRUE)

func = function(x, y) {
  
    x$probes_in_ch_18 = mappedProbes(y)
    
    x
}

#my_environment$probes_in_ch_18 = mappedProbes(18)
#my_environment$remove_ch_nr = 

chr18 <- func(my_environment, 18)
xc <- as.list(chr18)
xc
# as.list(my_environment)


#x$remove_ch_nr = gsub(y, "", x$probes_in_ch_18)


my_environment$remove18 <- function(x) gsub('18', '', x)

xy = as.list(my_environment)
xy