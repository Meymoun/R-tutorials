# all_wars_matrix is available in your workspace
all_wars_matrix

# Estimate the visitors
# divides each element with 5
visitors <- all_wars_matrix/5

# Print the estimate to the console
visitors

# create ticket_prices_matrix
# tp = ticket price
tp_a_new_hope <- c(5.0, 5.0)
tp_the_empire_strikes_back <- c(6.0, 6.0)
tp_return_of_the_jedi <- c(7.0, 7.0)
tp_the_phantom_menace <- c(4.0, 4.0)
tp_attack_of_the_clones <- c(4.5, 4.5)
tp_revenge_of_the_sith <- c(4.9, 4.9)

ticket_prices <- c(tp_a_new_hope, tp_the_empire_strikes_back, 
                   tp_return_of_the_jedi, tp_the_phantom_menace, 
                   tp_attack_of_the_clones, tp_revenge_of_the_sith)


ticket_prices_matrix <- matrix(ticket_prices, nrow = 6, ncol = 2, byrow = TRUE)

# concatinate 2 vectors with titles
all_titles = c(titles, titles2) 

# name row and column, region = US and non-US
rownames(ticket_prices_matrix) <- all_titles
colnames(ticket_prices_matrix) <- region

ticket_prices_matrix

# Estimated number of visitors
visitors <- all_wars_matrix/ticket_prices_matrix

# US visitors
us_visitors <- visitors[,1]

# Average number of US visitors
mean(us_visitors)