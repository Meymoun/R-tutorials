# summarize is most powerful when applied to grouped data

# break up the dataset into groups of rows based on the values of one or more variables

# load package
library(dplyr)

# put data frame in "data frame tbl"
cran <- tbl_df(mydf)

# remove original dataset from workspace
rm('mydf')

# group the data by package name
by_package <- group_by(cran, package)

# check average size for each package
summarize(by_package, mean(size))

# n_distinct is the same as lenght(unique(x))

pack_sum <- summarize(by_package,
                      count = n(),
                      unique = n_distinct(ip_id),
                      countries = n_distinct(country),
                      avg_bytes = mean(size))

# the count column created with n() contains the total number of rows for each package 
# the 'unique' column, created with n_distinct(ip_id), 
# gives the total number of unique downloads for each package

# the 'countries' column, created with n_distinct(country), 
# provides the number of countries in which each package was downloaded
# the 'avg_bytes' column, created with mean(size), 
# contains the mean download size (in bytes) for each package.

# 99% sample quantile
quantile(pack_sum$count, probs = 0.99)

# select packages that had more than 679 downloads
top_counts <- filter(pack_sum, count > 679)

# 61 packages in our top 1%, but dplyr only shows the first 10 rows, therefore:
View(top_counts)
# to see all of them

# arrange in descending order. Highest count first. 
top_counts_sorted <- arrange(top_counts, desc(count))

# find unique downloads, 99 % quantile
quantile(pack_sum$unique, probs = 0.99)

# find top 1 %
top_unique <- filter(pack_sum, unique > 465)

# arrange nr of unique downloads in descending order
top_unique_sorted <- arrange(top_unique, desc(unique))

######################################

by_package <- group_by(cran, package)
pack_sum <- summarize(by_package,
                      count = n(),
                      unique = n_distinct(ip_id),
                      countries = n_distinct(country),
                      avg_bytes = mean(size))


# select the countries with more than 60 downloads
# arrange first by country, then size
top_countries <- filter(pack_sum, countries > 60)
result1 <- arrange(top_countries, desc(countries), avg_bytes)

# Print the results to the console.
print(result1)

#######################################

# same result, different approach:
# chaining
# %>% is read as "then"

result3 <-
  cran %>%
  group_by(package) %>%
  summarize(count = n(),
            unique = n_distinct(ip_id),
            countries = n_distinct(country),
            avg_bytes = mean(size)
  ) %>%
  filter(countries > 60) %>%
  arrange(desc(countries), avg_bytes)

# Print result to console
print(result3)


#######################################

# select columns from dataset cran
cran %>%
  select(ip_id, country, package, size) %>%
  print

#######################################

# add size_mb to dataset

cran %>%
  select(ip_id, country, package, size) %>%
  mutate(size_mb = size /2^20) %>%
  print

######################################

# filter size_mb less than or equal to 0.5
cran %>%
  select(ip_id, country, package, size) %>%
  mutate(size_mb = size / 2^20) %>%
  filter(size_mb <= 0.5) %>%
  print

######################################

# arrange in descending order

cran %>%
  select(ip_id, country, package, size) %>%
  mutate(size_mb = size / 2^20) %>%
  filter(size_mb <= 0.5) %>%
  arrange(desc(size_mb)) %>% 
  print




