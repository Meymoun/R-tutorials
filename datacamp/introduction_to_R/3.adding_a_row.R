# star_wars_matrix and star_wars_matrix2 are available in your workspace
star_wars_matrix  

# create vectors for the matrix

the_phantom_menace <- c(474.0, 552.5)
attack_of_the_clones <- c(310.7, 338.7)
revenge_of_the_sith <- c(380.3, 468.5)

box_office2 <- c(the_phantom_menace, attack_of_the_clones, revenge_of_the_sith)
titles2 <- c('The Phantom Menace', 'Attack of the Clones', 'Revenge of the Sith')

# create star_wars_matrix2
star_wars_matrix2 <- matrix(movies, nrow = 3, ncol = 2, byrow = TRUE)

# name row and column
# region = US and non-US
rownames(star_wars_matrix2) <- titles2
colnames(star_wars_matrix2) <- region

# Combine both Star Wars trilogies in one matrix
all_wars_matrix <- rbind(star_wars_matrix, star_wars_matrix2)