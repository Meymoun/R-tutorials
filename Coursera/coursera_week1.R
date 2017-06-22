data <- read.csv("hw1_data.csv")

head(data, n = 2)
tail(data, n = 2)

# subset column Ozone
ozone <- data$Ozone

# select NAs
na <- is.na(ozone)

# count NAs
sum_missing_values <- sum(na)

# select non-NAs
not_na <- (ozone[!na == TRUE])

mean(not_na)

# extract values where ozone > 31 and temp values > 91
# what is the mean of Solar.S? 

logic_vector <- data$Ozone >= 31 & data$Temp >= 91 
solar <- data$Solar.R[logic_vector]
solar_values <- solar[!is.na(solar)]
mean(solar_values)

# average temperature of month 6
month <- data$Month == 6
temp <- data$Temp[month]
mean(temp)

# highest ozone value in May?
may <- data$Month == 5
data$Ozone[may]

# how find maximum value? 