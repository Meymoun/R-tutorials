
# load the package
library(tidyr)

# http://vita.had.co.nz/papers/tidy-data.pdf
# paper about tidyr

# 1) Each variable forms a column
# 2) Each observation forms a row
# 3) Each type of observational unit forms a table

# gather all columns except grade
gather(students, sex, count, -grade)
# each variable occupies exactly one column

# 
res <- gather(students2, sex_class, count, -grade)

# single character column into multiple columns
separate(res, sex_class, c("sex", "class"))
# splits on non-alpanumeric values unless other is requested

##################################

# chained arguments

students2 %>%
  gather(sex_class, count, -grade) %>%
  separate(sex_class, c("sex", "class")) %>%
  print

##################################


students3 %>%
  gather( 'class', 'grade', class1:class5 , na.rm = TRUE) %>%
  print


#################################

# spread a column with two variables into two columns

students3 %>%
  gather(class, grade, class1:class5, na.rm = TRUE) %>%
  spread(test, grade) %>%
  print


#######################################

parse_number("class5")


#####################################

# "overwrite" a column with mutate through assign a new variable to the existing one
# parse_number() removes all symbols before and after the number

students3 %>%
  gather(class, grade, class1:class5, na.rm = TRUE) %>%
  spread(test, grade) %>%
  mutate(class = parse_number(class)) %>%
  print


#####################################

# select id, name and sex
# id in both datasets

student_info <- students4 %>%
  select( id, name, sex) %>%
  print

#######################################

# remove duplicates

student_info <- students4 %>%
  select(id, name, sex) %>%
  unique %>%
  print

#########################################

# select id, class, midterm and final
# id in both datasets

gradebook <- students4 %>%
  select(id, class, midterm, final) %>%
  print

#####################################

# overwrite dataset with dataset that also contains column "status"

passed <- passed %>% mutate(status = "passed")

failed <- failed %>% mutate(status = "failed")

# join datasets by row

bind_rows(passed, failed)

# each row is an observation, each column is a variable

###########################################

## test scores, select all columns that doesn't contain the word "total"
## gather the columns that countains info about sex and count, not score range
## separate part_sex into 2 columns: part and sex

sat %>%
  select(-contains("total")) %>%
  gather(part_sex, count, -score_range) %>%
  separate(part_sex, c("part", "sex")) %>%
  print


## group the columns, first by part and then by sex
## add t columns: total and prop

sat %>%
  select(-contains("total")) %>%
  gather(part_sex, count, -score_range) %>%
  separate(part_sex, c("part", "sex")) %>%
  group_by(part, sex) %>%
  mutate(total = sum(count),
         prop = count / total
  ) %>% print