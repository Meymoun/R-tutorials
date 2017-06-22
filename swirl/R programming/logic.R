# arithmetic operators: `+`, `-`, `*`, and `/`

# is TRUE equal to TRUE?
TRUE == TRUE
# TRUE

# logical expressions can be grouped by parenthesis so that the entire 
# expression (TRUE == TRUE) == TRUE evaluates to TRUE.
# test this:
(FALSE == TRUE) == FALSE
# TRUE

# is 6 equal to 7?
6 == 7
# FALSE

# test if 6 is less than 7
6 < 7
# TRUE 

# is 10 less than or equal to 10?
10 <= 10
# TRUE

# is 5 not equal to 7?
5 != 7

# negate a whole expression, check if the condition is true using both 
# the equals operator and the NOT (!) operator
!(5 == 7)

# the NOT operator `!` negates logical expressions so that TRUE expressions become FALSE 
# and FALSE expressions become TRUE

# AND operators: `&` and `&&` 
# work similarly, if both right and left operands of ANDs are TRUE, the expression is TRUE
# otherwise: FALSE

FALSE & FALSE
# FALSE

# evaluate accross a vector
TRUE & c(TRUE, FALSE, FALSE)
# TRUE FALSE FALSE

# && only evaluates the expression for the first member of a vector. 
# The other elements are not evaluated at all.
TRUE && c(TRUE, FALSE, FALSE)
# TRUE

# OR operator `|` evaluate to TRUE if either the left or the right operand is TRUE
# both TRUE: TRUE
# if neither are TRUE: FALSE

TRUE | c(TRUE, FALSE, FALSE)
# TRUE TRUE TRUE

# `||` only evaluates the first element of the vector, "non-vectorized"
TRUE || c(TRUE, FALSE, FALSE)
# TRUE

# order of operators: all AND operators are evaluated before OR operators

5 > 8 || 6 != 8 && 4 > 3.9
# TRUE

# check if condition is true
isTRUE(6 > 4)

# evaluates to TRUE (!FALSE)
!isTRUE(4 < 3)

# function identical() returns TRUE if two objects are identical
identical('twins', 'twins')

# also valid for expression
identical(5 > 4, 3 < 3.1)

# xor function. Evaluates to TRUE if one expression evaluates to TRUE and the other to FALSE.
# If both are TRUE or both are FALSE --> FALSE 
xor(5 == 6, !FALSE)
# TRUE


xor(4 >= 9, 8 != 8.0)
# first expression: FALSE, second: FALSE (!TRUE)
# xor(FALSE, FALSE) --> FALSE

xor(!isTRUE(TRUE), 6 > -1)
# first expression: FALSE (!TRUE), second: TRUE
# xor(FALSE, TRUE) --> TRUE

# random sampling of integers from 1 to 10 without replacement
# without replacement: each value is only taken once
ints <- sample(10)

# check if integer is larger than 5 in vector ints
ints > 5
# returns logical vector

# use logical vector to ask other questions about vector
# which() function takes logical vector and returns the indices of the vector that are TRUE

which(c(TRUE, FALSE, TRUE))
# returns vector c(1,3)

# find indices of ints that are greater than 7
which(ints > 7)

# any() return TRUE if one or more of the elements in the logical vector is TRUE
# all() return TRUE if every element in the logical vector is TRUE

# see if any element is less than zero
any(ints < 0)
# FALSE

# see if all elements are greater than zero
all(ints > 0)
# TRUE