
# simulate rolling four six-sided dices
sample(1:6, 4, replace = TRUE)

# dafault: replace = FALSE (sampling without replacement)

# sample 10 numbers between 1 and 20, without replacement
sample(1:20, 10)

# LETTERS is a vector with all the 26 letters in the english alphabet
# sample can be used to permute a variable
sample(LETTERS)

# take 100 samples from vector c(0,1) with replacement
# uneven probabilities
flips <- sample(c(0,1), 100, prob = c(0.3, 0.7), replace = TRUE)

# the probability for 1 was 0.7, therefore we expect that the ones are around 70% of the sample
# summarize the ones
sum(flips)

# calculate the chance of getting 1 in 100 flips with a probability of getting 1 = 0.7
rbinom(1, size = 100, prob = 0.7)

# get all 0s and 1s, 100 observations, each of size 1, with success probability of 0.7
flips2 <- rbinom(n = 100, size = 1, prob = 0.7)
# --> vector with 0s and 1s

# calculate 1s
sum(flips2)

# the standard normal distribution has mean 0 and standard deviation 1
# generate 10 random number from standard normal distribution
rnorm(10)

# 10 random number from normal distribution with mean = 100 and sd = 25
rnorm(10, mean = 100, sd = 25)

# generate 5 random numbers from a Poisson distribution with mean 10
rpois(5, 10)

# repeat x 100
my_pois <- replicate(100, rpois(5, 10))
# creates a matrix, each column contains 5 random numbers generated from a Poisson distribution with mean 10

# calculate mean of each column
cm <- colMeans(my_pois)

# look at distribution
hist(cm)


# other standard probability distributions built into R:
# exponential (rexp()), chi-squared (rchisq()), gamma (rgamma())

