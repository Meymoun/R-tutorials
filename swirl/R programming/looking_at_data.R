# list the variables in workspace
ls()

# check variable "plants"
class(plants)
# class: data.frame

# shows how many rows (observations) and columns (variables)
dim(plants)

# shows how many rows
nrows(plants)

# shows how many columns
ncol(plants)

# shows hon much space the dataset is occupying in memory
object.size(plants)

# show the variables in the dataset
names(plants)

# show first 6 rows, default
head(plants)

# show first 10 rows
head(plants, n = 10)

# show last 15 rows
tail(plants, n = 15)

# summary() show different output for each variable, depending on class
# numeric data displays the minimun, 1st quartile, median, mean, 3rd quartile, and maximum
# for categorical variables, or 'factor' variables in R, 
# the number of times each value occurs in the data
summary(plants)

# R truncated the summary for Active_Growth_Period by including category 'Other'
# therefore, in order to show all categories in the variable:
table(plants$Active_Growth_Period)

# show structure in a concise and readable format
str(plants)

# str() is a general function that is possible to use on most objects in R
# eg. a dataset, a function

