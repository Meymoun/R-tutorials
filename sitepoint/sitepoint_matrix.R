# creates matrix with range 1:20, fills up by column
m <- matrix(nrow = 4, ncol = 5, 1:20)

# error message, but creates the same output as previous matrix. The last 5 elements are discarded. 
m <- matrix(nrow = 4, ncol = 5, 1:25)

# error message, but creates matrix with recykled values when the matrix is full.
m <- matrix(nrow = 4, ncol = 5, 1:16)

