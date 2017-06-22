myString <- "5.60"
myNumeric <- 5.6

# change class from character to integer
myInteger1 <- as.integer(myString)

# change class from numeric to integer
myInteger2 <- as.integer(myNumeric)

# check if same
myInteger1 == myInteger2
# output: [1] TRUE

myInteger1
# output: [1] 5

