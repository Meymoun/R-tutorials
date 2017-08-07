library(datasets)
data(iris)


# split groups based on specie

s <- split(iris, iris$Species)

# applies anonomous function on subgroups
# column mean in "Sepal.Lenght"
# returns matrix 
sapply(s, function(x) colMeans(x["Sepal.Length"]))


# what R code returns a vector of the means of the variables 
# 'Sepal.Length', 'Sepal.Width', 'Petal.Length', and 'Petal.Width'?
apply(iris[, 1:4], 2, mean)


##################### 

data(mtcars)


