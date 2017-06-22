5 + 7

# store the value in a variable
x <- 5 + 7

y <- x - 3

# create a vector containing the numbers 1.1, 9 and 3.14
z <- c(1.1, 9, 3.14)

# more info about concatenate: ?c

# print vector of that contains z, 555, z
c(z, 555, z)

# arithmetic expression, multiply and adds 100 to each element of the vector
z * 2 + 100

# square root: sqrt()
# absolut value: abs()

# each element is substracted with 1 and then takes the square root
my_sqrt <- sqrt(z-1)

# each element in z is divided with the square root of z - 1
y_div <- z/my_sqrt

# when given two vectors of the same lenght, R simply performs
# the specified arithmetic operation element-by-element. 
# Different lenghts: R "recycles the shorter vector. 
# in z * 2 + 100, 2 is a vector of one, 100 is a vector of 1. They are recycled in the vector. 

# 2nd vector recycled in evenly divided vector
c(1, 2, 3, 4) + c(0,10)
# output: 1, 12, 3, 14

# unevenly divided vectors gives warning
c(1, 2, 3, 4) + c(0, 10, 100)
# output: 1, 12, 103, 4 with a warning message: longer object length is not a multiple of shorter object length  


