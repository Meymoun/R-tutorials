# Matrices and data frames store tabular data, with rows and columns
# matrices can only contain a single class of data
# data frames can consist of many classes of data

my_vector <- 1:20

# show the dimension of the vector
dim(my_vector)
# NULL (one dimension)

# show the length of the vector
length(my_vector)

# change dimension to 2d, 4 rows, 5 columns
dim(my_vector) <- c(4, 5)

# shows the attributes of the vector, shows dim attribute if it is given
attributes(my_vector)

# since object is 2d, it isn't a vector anymore
class(my_vector)
# 'matrix'

# store in a more suitable name
my_matrix <- my_vector

# create an identical matrix with the matrix function
my_matrix2 <- matrix(1:20, nrow = 4, ncol = 5) 

# confirm that they are identical
identical(my_matrix, my_matrix2)

# to map numbers to patient, create patients vector and...
patients <- c('Bill', 'Gina', 'Kelly', 'Sean')

# bind the vector as a column in my_matrix
cbind(patients, my_matrix)

# this changes the numeric vector into a character vector, everything is enclosed in double quotes
# matrices only deal with one type of data, when 2 data types were bound, R forced to 'coerce' the numbers to characters

# however, data frames can handle different classes of data
my_data <- data.frame(patients, my_matrix)

class(my_data)
# class 'data.frame'

# name the columns
# but first: vector with names
cnames <- c('patient', 'age', 'weight', 'bp', 'rating', 'test')

# assign cnames to columns in matrix
colnames(my_data) <- cnames


