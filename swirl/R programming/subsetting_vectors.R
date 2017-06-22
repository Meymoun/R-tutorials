# vector of 20 random numbers (from normal distribution) and 20 NAs

x <- c(-1.97114325, NA, 1.07320844, NA, NA, 0.91784376, -0.20133389, -0.24035836, -0.39559717, 
       -0.03097145, -0.03398913, NA, NA, NA, NA, 1.56883402, -1.15075112, NA, NA, NA, -0.36070594, 
       0.43648975, -1.19942063, -0.35948450, NA, 0.04997390, 2.93289801, NA, NA, NA, 0.05594802, NA, 
       NA, NA, NA, NA, -0.06871020, NA, 0.80006459, -0.64018504)

# Use index to select the 10 first elements
x[1:10]

# Index vectors come in four different flavors -- logical vectors, vectors of positive integers,
# vectors of negative integers, and vectors of character strings 
# each of which we'll cover in this lesson.
# ?? different index vectors ??

# indexing with logical vectors

# gives a vector of all NAs
x[is.na(x)] 

# negation of a logical expression, "is not NA" 
# isolate the non-missing values of x
y <- x[!is.na(x)]

# y > 0 gives a logical vector 
# y[y > 0] gives a vector of all positive elements of y
y[y > 0]

# why not x[x > 0]? 
# NA is a placeholder and not a number, therefore testing NA greater than zero will yield NA, 
# and we'll have NAs mixed with the positive numbers 
x[x > 0]

# combine the expressions, not NA and greater then 0 yields only positive elements
x[!is.na(x) & x > 0]

# request element 3, 5 and 7
x[c( 3, 5, 7)]

# asks for a index outside of the vector
x[0]
x[3000]
# output: numeric(0) and NA
# nothing useful, but R doesn't prevent this
# make sure to ask for a number within the vector

# ask for all number except for index 2 and 10
# negative integer indexes
x[c(-2, -10)]

# also possible: put negative sign in front of the vector 
x[-c(2, 10)]

# create a numeric vector with three named elements
vect <- c(foo = 11, bar = 2, norf = NA)

# gives the names 
names(vect)

# unnamed vector
vect2 <- c(11, 2, NA)

# name vector elements
names(vect2) <- c('foo', 'bar', 'norf')

# check if vectors are identical
identical(vect, vect2)
# TRUE

# select element 2 with name "bar"
vect['bar']

# specify a vector of names
vect[c('foo', 'bar')]

# Now you know all four methods of subsetting data from vectors. Different approaches are best in
# different scenarios and when in doubt, try it out!