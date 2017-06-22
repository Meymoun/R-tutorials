
# dispersion (= variability)

# the range is the difference between the maximum and minimum values of the data set

# minimum and maximum value of price in cars data set
range(cars$price)

# calculate the range, maximun - minumum value
range(cars$price)[2] - range(cars$price)[1]

# calculate the variance
# the average of the squared differences from the mean
var(cars$price)

# the standard deviation can be calculated by taking the square root of the variance
# sd = sqrt(variance), sd^2 = variance

# the standard deviation is expressed in the same units as the original data values

# calculate sd of the prices
sd(cars$price)

# outliers: observation that is unusual or extreme relative to the other values