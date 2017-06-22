# every integer between (incl. 1 and 20)
1:20

# vector of real numbers starting with pi (3.142...), increasing with 1. 
pi:10

# backwards counting
15:1

# for help with symbols: ?`:` (shift + ´)
# also possible to close with regular quotes)
?`:`

# create sequence of numbers, same as 1:20 
seq(1, 20)

# change interval of sequence
seq(0, 10, by = 0.5)

# 30 evenly spaced numbers between 5 and 10
my_seq <- seq(5, 10, length = 30)

# check length of sequence
length(my_seq)

# create a sequence with same length as my_seq
# 3 approaches: 

1:length(my_seq)
seq(along.with = my_seq)
seq_along(my_seq) # built-in function

# create a vector with 40 zeroes
rep(0, times = 40)

# repeat vector x 10
rep(c(0, 1, 2), times = 10)

# repeat each element x 10 one at a time
rep(c(0, 1, 2), each = 10)