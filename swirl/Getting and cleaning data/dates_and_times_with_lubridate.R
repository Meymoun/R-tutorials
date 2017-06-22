


Sys.getlocale("LC_TIME")

library(lubridate)

this_day <- today


year(this_day)
# shows the year

month(this_day)

day(this_day)

wday(this_day)
# represents day as a number, 1 = Sunday, 2 = Monday etc.


wday(this_day, label = TRUE)
# [1] Thurs
# Levels: Sun < Mon < Tues < Wed < Thurs < Fri < Sat


this_moment <- now()
# [1] "2017-06-22 14:06:26 CEST"

hour(this_moment)

minute(this_moment)

second(this_moment)

# store a character string as an object of class POSIXct
my_date <- ymd("1989-05-17")

# Fortunately, lubridate offers a variety of functions for parsing date-times. These functions take
# the form of ymd(), dmy(), hms(), ymd_hms(), etc., where each letter in the name of the function
# stands for the location of years (y), months (m), days (d), hours (h), minutes (m), and/or seconds
# (s) in the date-time being read in.

# other date-time formats:
ymd("1989 May 17")
# [1] "1989-05-17"

# other order:
mdy("March 12, 1975")
#[1] "1975-12-19"

# 25th August 1985
dmy(25081985)
# [1] "1985-08-25"

# with character string:
ymd("192012")
# [1] NA
# lubridate is unclear with what date I want

# therefore, add dashes or forward slashes
ymd("1920/1/2")
# [1] "1920-01-02"

# parse dt1 <- "2014-08-23 17:23:02"
ymd_hms(dt1)
# [1] "2014-08-23 17:23:02 UTC"

# for time:
hms("03:22:14")
# [1] "3H 22M 14S"

dt2 <- c("2014-05-14", "2014-09-22", "2014-07-11")

ymd(dt2)
# [1] "2014-05-14" "2014-09-22" "2014-07-11"

# update time
update(this_moment, hours = 8, minutes = 34, seconds = 55)

# create variable for the current time in New York
nyc <- now("America/New_York")
# valid time zones with lubridate: 
# http://en.wikipedia.org/wiki/List_of_tz_database_time_zones

# the flight leaves in 2 days
# use arithmetic operators on dates and times
depart <- nyc + days(2)

# update with the correct time
depart <- update(depart, hours = 17, minutes = 34)


# what time do you arrive in Hong Kong?
arrive <- depart + hours(15) + minutes(50)
# but thats in time zone: New York

# local arrival time
arrive <- with_tz(arrive, "Asia/Hong_Kong")

# last time you saw your friend in Singapore
last_time <- mdy("June 17, 2008", tz = "Singapore")

# how long time has passed?
how_long <- interval(last_time, arrive)

# how long has it been?
as.period(how_long)

# a timer was created in the beginning, how? 
stopwatch()
