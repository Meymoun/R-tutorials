# Vector with numerics from 1 up to 10
my_vector <- 1:10 

# Matrix with numerics from 1 up to 9
my_matrix <- matrix(1:9, ncol = 3)

# First 10 elements of the built-in data frame mtcars
my_df <- mtcars[1:10,]

# Adapt list() call to give the components names
my_list <- list(vec = my_vector, mat = my_matrix, df = my_df)

# Print out my_list
my_list

# The variables mov, act and rev are available

mov <- 'The Shining'
act <- c("Jack Nicholson", "Shelley Duvall", "Danny Lloyd", "Scatman Crothers","Barry Nelson")

# Create dataset
scores <- c(4.5, 4.0, 5.0)
sources <- c('IMDb1', 'IMDb2', 'IMDb3')
comments <- c("Best horror film I've ever seen", 
             "A truly brilliant and scary film", "A masterpiece of phychological horror")

rev <- data.frame(scores, sources, comments)

rev

# Finish the code to build shining_list 
# and name list elements
shining_list <- list(moviename = mov, actors = act, reviews = rev)
shining_list