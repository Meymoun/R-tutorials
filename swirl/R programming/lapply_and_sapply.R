
# 6 first lines in the dataset
head(flags)

# show dimensions, ie how many rows and columns in the dataset
dim(flags)
# 194 rows, or observations
# 30 columns, or variables

# open up a more complete description od the dataset in a seperate text file
viewinfo()


class(flags)
# class data.frame

# check class for a column at a time
# automate the process with a loop


# store list of classes for each column in the dataset flags
cls_list <- lapply(flags, class)

# the 'l' in 'lapply' stands for 'list'
class(cls_list)
# --> list

# the classes of flags are characters vectors. 
# therefore it's possible to simplify, from a list with 30 character vectors into one character vector
as.character(cls_list)

# this process (lapply + simplify) is automated by the function sapply ('s' for 'simplify')
# does the same behind the scenes

cls_vect <- sapply(flags, class)

class(cls_vect)
# --> "character"

# if the result is a list where every element is of length one, sapply() returns a vector
# if the result is a list where every element is a vector of the same length (> 1), 
# sapply() returns a matrix
# otherwise: if sapply() can't figure it out, it returns a list just like lapply()


# count all flags with orange
sum(flags$orange)

# select the columns containing the color data
# all rows, column 11:17
flag_colors <- flags[,11:17]

# loop over list to get the sum of each column 
lapply(flag_colors, sum)

# the result of lapply can be simplified to a vector,
# instead of two steps, use sapply right away
sapply(flag_colors, sum)
# returns a matrix

# take the mean of each column
sapply(flag_colors, mean)
# returns a matrix

# stores the columns with info about flag shape
flag_shapes <- flags[, 19:23]

# list with range (minumum, maximum) of flags containing a specific shape
lapply(flag_shapes, range)

# stored matrix with range of flags with a specific form
shape_mat <- sapply(flag_shapes, range)

# Each column of shape_mat gives the minimum (row 1) and maximum (row 2) number of times its
# respective shape appears in different flags.


# unique() returns a vector with all duplicates removed
unique(c(3, 4, 5, 5, 5, 6, 6))

# store unique values from each column in dataset
unique_vals <- lapply(flags, unique) 

# find length for each vector in unique_vals
sapply(unique_vals, length)


sapply(flags, unique)
# same output as lapply(flags, unique)
# sapply cannot simplify since the vectors has different lengths

# create a function that takes the second item in each element of unique_vals
lapply(unique_vals, function(elem) elem[2])
# anonymous function