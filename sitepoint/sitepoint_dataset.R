# create a dataset
men <- data.frame(height = c(50:65), weight = c(150:165))

# prints first 6 elements
head(men)

# assigns new column headers
names(men) <- c("Male Height", "Male Weight")

men