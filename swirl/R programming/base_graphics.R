# load dataset cars
data(cars)

# view 6 first rows
head(cars)

# 2 variables: speed and stopping distance
# view a plot of the data frame
plot(cars)

# define x- and y-axis
plot(x = cars$speed, y = cars$dist)
# returns a different plot than plot(cars)

# formula interface, later in lecture
# plot(dist ~ speed, cars)

# swap axes
plot(x = cars$dist, y = cars$speed)

# makes more sence for speed to go on the x-axis since stopping distance is a function of speed

# x label set to "Speed"
plot(x = cars$speed, y = cars$dist, xlab = "Speed")

# y label
plot(x = cars$speed, y = cars$dist, ylab = "Stopping Distance")

# x and y label
plot(x = cars$speed, y = cars$dist, xlab = "Speed", ylab = "Stopping Distance")

# add title
plot(cars, main = "My Plot")

# add subtitle
plot(cars, sub = "My Plot Subtitle")

# plotted points colored red
lot(cars, col = 2)

# limit the x-axis
plot(cars, xlim = c(10,15))

# plot triangles
plot(cars, pch = 2)

# modern packages like ggplot is good to create graphics in R

# load data
data(mtcars)

# formula = mpg ~ cyl plot the relationship between cyl (number of cylinders) on the x-axis
# and mpg (miles per gallon) on the y-axis
boxplot(formula = mpg ~ cyl, data = mtcars)

# histogram is useful when looking at a single variable
hist(mtcars$mpg)