v <- 1:5
x <- 6:10

# binds by column, one vector = one column
bound <- cbind(v, x)
bound

# binds by row, one vector = one row
bound <- rbind(v, x)
bound

?data.frame