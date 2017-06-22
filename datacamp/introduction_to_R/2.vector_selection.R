# Poker and roulette winnings from Monday to Friday:
poker_vector <- c(140, -50, 20, -120, 240)
roulette_vector <- c(-24, -50, 100, -350, 10)
days_vector <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday")
names(poker_vector) <- days_vector
names(roulette_vector) <- days_vector

# Define a new variable based on a selection
poker_wednesday <- poker_vector[3]

# Define a new variable based on a selection
poker_midweek <- poker_vector[c(2,3,4)]

# Define a new variable based on a selection
roulette_selection_vector <- roulette_vector[c(2:5)] 

# Select poker results for Monday, Tuesday and Wednesday
poker_start <- poker_vector[c('Monday', 'Tuesday', 'Wednesday')]

# Calculate the average of the elements in poker_start
mean(poker_start)