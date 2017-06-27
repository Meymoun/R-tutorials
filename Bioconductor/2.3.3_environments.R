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

#my_environment = new.env(hash = TRUE)

#func = function(x, y) {
  
#  x$probes_in_ch_18 = mappedProbes(y)
  
#  x
#}

#my_environment$probes_in_ch_18 = mappedProbes(18)
#my_environment$remove_ch_nr = 

#chr18 <- func(my_environment, 18)
#xc <- as.list(chr18)
#xc
# as.list(my_environment)

#x$remove_ch_nr = gsub(y, "", x$probes_in_ch_18)

#my_environment$remove18 <- function(x) gsub('18', '', x)

#xy = as.list(my_environment)
#xy


my_environment = new.env(hash = TRUE)

my_environment$a = function(x) grep("^18", x, value = TRUE)

my_environment$a = eapply(hgu95av2MAP, function(x) grep("^18", x, value = TRUE))

my_environment$a