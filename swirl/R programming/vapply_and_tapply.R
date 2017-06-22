# takes unique values of each variable 
sapply(flags, unique)

# sapply() tries to guess the right format, 
# vapply() allows you to specify
# it the result doesn't match the format --> error

# this can prevent significant problems 
# in your code that might be caused by getting unexpected return values from sapply()


# says: I expect each element of the result to be a numeric vector of length 1
vapply(flags, unique, numeric(1))
# error

# vector of the class of each variable
sapply(flags, class)

# says: I expect each element of the result to be a character vector of length 1
vapply(flags, class, character(1))
# since the expectation was right, the result is the same as with sapply(flags, class)

# tapply() used for: 
# split your data into groups based on the value of some variable,
# then apply a function to the members of each group

# creates a table of how many hits in each group in varable "landmass"
table(flags$landmass)

# creates a table of how many countries that have an animate image in their flag (1), and not (0)
table(flags$animate)

# apply the mean function to the 'animate' variable seperately for each of the six landmass groups
tapply(flags$animate, flags$landmass, mean)
# --> a table of the proportion of flags with an animate image (animate = 1) in each group

# divide in 2 groups: flags with or without red
# apply summary() function on the population parameter on each group
tapply(flags$population, flags$red, summary)
# --> list of summary for each group

# divide in groups based on landmass
# apply summary() on population variable for each group
tapply(flags$population, flags$landmass, summary)