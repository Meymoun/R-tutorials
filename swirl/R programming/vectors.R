# create a numerical vector
num_vect <- c(0.5, 55, -10, 6)

# create a logical vector, condition: each element in vector is smaller than 1
tf <- num_vect < 1

# check each element if greater or equal to 6
num_vect >= 6

# logical expressions: A and B. 
# Check if at least one is TRUE: A|B (union)
# Check if both are TRUE: A & B (intersection)
# !A is the negation of A. TRUE when A == FALSE

# both fulfilled: FALSE
(3 > 5) & (4 == 4)

# At least one fulfilled: TRUE
(TRUE == TRUE) | (TRUE == FALSE)

# From left: 1) At least one fulfilled: TRUE, 2) both fulfilled: TRUE
# From right: 1) Both fulfilled: FALSE, 2) at least one fulfilled: TRUE
((111 >= 111) | !(TRUE)) & ((4 + 1) == 5)


# create vector with words
my_char <- c('My', 'name', 'is')

# join the elements
paste(my_char, collapse = ' ')

# add name
my_name <- c(my_char, 'Elinor')

# join
paste(my_name, collapse = ' ')

# join two character vectors of length 1 (ie join 2 words. 
# sep = ' ' tells R to seperate with a single space)

paste('Hello', 'world!', sep = ' ')

# join vectors element by element 
paste(1:3, c('X', 'Y', 'Z'), sep = '')

# vectors of different length? Recycle
# LETTERS = predefined variable in R containing a character vector of all 26 letters in the English alphabet
# numeric vector changes class into a character vector
paste(LETTERS, 1:4, sep = '-')
