# "Data are values of qualitative or quantitative variables, 
# belonging to a set of items."

# use a subset, or SAMPLE, to study an entire population

# begin with a specific question


# draw conclusion about the population from which the sample was selected
# called inference

# describe our sample with just one number: 
# the center (mean), the middle (median) or the most common element (mode) of our data?
# called central tendency


# extract mpgCity from dataset
myMPG <- cars$mpgCity

# calculate the mean
mean(myMPG)

# find the median
median(myMPG)

# find the most common element
# show how frequent each element is
table(myMPG)


