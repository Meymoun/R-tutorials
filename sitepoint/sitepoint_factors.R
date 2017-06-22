f <- factor(c("Hello", "World", "Hello", "Annie", "Hello", "World"))


# shows the factor vector and the different levels
f

# output:
# [1] Hello World Hello Annie Hello World
# Levels: Annie Hello World

# print table of factors
table(f)

# output:
# f
# Annie Hello World 
# 1     3     2