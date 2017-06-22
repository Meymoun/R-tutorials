m <- 1:15

dim(m)
# output: NULL (one-dimensional matrix)

# change dimention of m, 3 rows, 5 columns
dim(m) <- c(3,5)

# 5 rows, 3 columns
dim(m) <- c(5,3)

# changes to one dimension
dim(m) <- NULL