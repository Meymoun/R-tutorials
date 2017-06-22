# path2 csv is the full file path to the dataset
# the characters should not be coverted to factors
mydf <- read.csv(path2csv, stringsAsFactors = FALSE)

# how many rows and columns?
dim(mydf)

# look at first 6 rows
head(mydf)

# load package dplyr
library(dplyr)

# check version. Important that it is version 0.4.0 or later
packageVersion('dplyr')

# load the date into a 'data frame tbl' and save in variable 'cran'
cran <- tbl_df(mydf)

# remove original data frame from workspace
rm('mydf')

# "The main advantage to using a tbl_df over a regular data frame is the printing."

# more informative and compact output than original data frame
# first dimensions, then a preview of the data (10 first rows and only as many columns that fit the console)
cran

# "The dplyr philosophy is to have small functions that each do one thing well." 
# 5 functions that cover most fundamental data manipulation tasks:
# select(), filter(), arrange(), mutate(), and summarize()

# select specific columns
select(cran, ip_id, package, country)
# no need for cran$ip_id etc. select() knows we're referring to the columns in the cran dataset
# also: the columns are returned in the specified order

# select columns in a range
select(cran, r_arch:country)

# select columns in reversed order
select(cran, country:r_arch)

# select all columns except for time
select(cran, -time)

# gives a range from -5 to 20
-5:20

# negates all numbers
-(5:20)

# select all columns except for column X to size
select(cran, -(X:size))


# select all rows for which the package variable is equal to "swirl"
filter(cran, package == "swirl")

# filter returns only the rows of cran corresponding to TRUE values from logical expression

# several conditions, R version equal to "3.1.1", in US
filter(cran, r_version == "3.1.1", country == "US")

# several conditions, R version smaller than or equal to "3.0.2" in India
filter(cran, r_version <= "3.0.2", country == "IN")

# either conditions TRUE
filter(cran, country == "US" | country == "IN")

# size not in quotes since it's a number
filter(cran, size > 100500, r_os == "linux-gnu")

# show NAs, logical vector
is.na(c(3, 5, NA, 10))

# logical vector. "is not NA"
!is.na(c(3, 5, NA, 10))

# show all values for which r_version is not NA
filter(cran, !is.na(r_version))

#select subset, all columns from size through ip_id
cran2 <- select(cran, size:ip_id)

# order the rows of cran2 so that ip_id is in ascending order (small to large)
arrange(cran2, ip_id)

# -''- in descending order (large to small)
arrange(cran2, desc(ip_id))

# arrange according to multiple variables
# first arrange py package names, then if they are the same, they will be sorted by ip_id
arrange(cran2, package, ip_id)

# arrange according to country (ascending), r_version (descending) and ip_id (ascending) (in that order)
arrange(cran2, country, desc(r_version), ip_id)

# subset of original data
cran3 <- select(cran, ip_id, package, size)

# mutate() creates a new variable with data from existing variable
# 1 mb is equal to 2^20 bytes 
mutate(cran3, size_mb = size / 2^20)

# possible to create new columns based on mutate created columns
# all in the same line
# 1 gb is equal to 2^10 mb
mutate(cran3, size_mb = size / 2^20, size_gb = size_mb / 2^10)

# the values in size were 1000 bytes less than they should be
# correct with mutate
mutate(cran3, correct_size = size + 1000)

# create a variable called avg_bytes that shows the mean download size
summarize(cran, avg_bytes = mean(size))


