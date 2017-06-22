# Integers get changed into numerics when saved in variables
myInt <- 209173987

# class numeric
class(myInt)

# prevent by setting integers with an L suffix
myInt = 5L

# class integer
class(myInt)

# large numbers get changed into a real number, even with an L suffix
myInt <- 2479827498237498723498729384

# class numeric
class(myInt)

myInt
# [1] 2.479827e+27

myIntCoerced <- as.integer(myInt)
# Warning message:
# NAs introduced by coercion 

myIntCoerced
#[1] NA, The NA is still of a type “integer”, but one without value.

# class integer
class(myIntCoerced)