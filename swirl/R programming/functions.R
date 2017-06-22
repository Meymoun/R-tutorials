# Basic functions

# prints today's date
Sys.Date()

# mean value of the values in the input vector (adds up the sum and divides that by the length of the vector)
mean(c(2, 4, 5))


# the script boring_function is given and modified. 
# The function takes an argument and return the argument unchanged.
# save and then print submit() in the console to access the script ??   
submit()

# Remember: the last expression evaluated will be returned!

boring_function("My first function")
# --> "My first function!" (takes argument and returns it unchanged)

# To understand computations in R, two slogans are helpful: 
# 1. Everything that exists is an object. 
# 2. Everything that happens is a function call.

# to look at the source code, write the function's name without and argument
boring_function
# --> function(x) {
#       x
# }

# replicate the functionality of the mean() function
my_mean <- function(my_vector) {
  sum(my_vector) / length(my_vector)
  
}

# test function my_mean
my_mean(c(4, 5, 10))
# 6.333333

# function with default value
# the default value can be changed by giving two arguments, eg. remainder(5, 3)
# --> the remainder of 5 modulo 3 = 2
# otherwise with only one value, eg. remainder(5)
# --> 5 modulo 2 = 1

remainder <- function(num, divisor = 2) {
  num %% divisor
   
}

remainder(5)
# --> 1

remainder(11, 5)
# --> 1

# with specifying arguments in a function, the order of the arguments become unimportent

remainder(divisor = 11, num = 5)
# --> 5

# note: difference between remainder(11, 5) and remainder(divisor = 11, num = 5)

# R can also partially match aguments
remainder(4, div = 2)
# --> 0

# see a function's arguments
args(remainder)
# --> function(num, divisor = 2)
# NULL


# functions can be passed as arguments in another function
# evaluate takes two arguments: one function and one argument
# and performs the function on the argument
evaluate <- function(func, dat){
  func(dat)
  # Remember: the last expression evaluated will be returned! 
}

# use evaluate to find the standard deviation of a vector
evaluate(sd, c(1.4, 3.6, 7.9, 8.8))

# you can pass a function as an argument without first difining the passed function
# these are called anonymous functions
evaluate(function(x){x+1}, 6)
# the function is created within the function
# x + 1 with x = 6
# --> 7

# an anonomous function that takes the first element in a vector
evaluate(function(x){x[1]}, c(8, 4, 0))
# --> 8

# anonomous function that take the last element of the vector
evaluate(function(x){x[-1]}, c(8, 4, 0))
# --> 4 0

# the previous solution gave the two last elements, but swirl approved..
# correction: 
evaluate(function(x){x[length(x)]}, c(8, 4, 0))

# also for last element: tail(x, n=1), (default n = 6)


# first argument of paste is `...`, this means that it can take an infinite number of arguments
# will return any numbers of strings and return all combined into one string.

# combine strings into one, seperated by default sep = " "
paste("Programming", "is", "fun!")

# format sentence for telegram, start with "START" followed by all arguments passed to the function,
# end with "STOP"

telegram <- function(...){
  paste("START", ..., "STOP")
}

# take several arguments
# make list
# create variable 
mad_libs <- function(...){
  # Do your argument unpacking here!
  args <- list(...)
  place <- args[[1]]
  adjective <- args[[2]]
  noun <- args[[3]] 
  # Don't modify any code below this comment.
  # Notice the variables you'll need to create in order for the code below to
  # be functional!
  paste("News from", place, "today where", adjective, 
        "students took to the streets in protest of the new", noun, "being installed on campus.")
}


mad_libs("Stockholm", "good", "dog")
# doesn't include "Stockholm", "good", "dog"

# if place <- args[['place']]
# use:
# mad_libs(place = "Stockholm", adjective = "good", noun = "dog")
# "News from Stockholm today where good students took to the streets in 
# protest of the new dog being installed on campus."

# making an own binary operator
# "word1" %p% "word2" --> "word1 word2"
"%p%" <- function(left, right){ # Remember to add arguments!
  paste(left, right)   
}

"I" %p% "love" %p% "R!"
# --> "I love R!"
