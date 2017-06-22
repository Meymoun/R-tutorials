x <- c(44, NA, 5, NA)

# multiply each element by 3
# NA * 3 = NA
x * 3

# vector with 1000 draws from a standard normal distribution
y <- rnorm(1000)

# 1000 NAs
z <- rep(NA, 1000)

# select 100 random element from y and z 
my_data <- sample(c(y, z), 100)

# how many NAs? 
# logical vector with TRUE or FALSE
my_na <- is.na(my_data)

# does it work in the same way as is.na?
# no, vector of NA in all elements
# NA is not a value,  logical expression is incomplete
my_data == NA

# R represents TRUE as the number 1 and FALSE as the number 0
# count number of TRUE
sum(my_na)

# NaN = not a number
0/0  # --> NaN

# Inf = Infinity
Inf - Inf # --> NaN
