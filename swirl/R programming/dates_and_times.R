# store today's date
d1 <- Sys.Date()

class(d1)
# class: "Date"

# see how d1 looks internally
unclass(d1)

# --> 17330, the exact number of days since 1970-01-01

d1
# "2017-06-13"

# reference to a date before the reference date
d2 <- as.Date("1969-01-01")

# how does it look internally?
unclass(d2)
# -365

# store the current date + time
t1 <- Sys.time()

class(t1)
# "POSIXct" "POSIXt"
# POSIXct is just one of two ways that R represents time information
# POSIXt functions as a common language between POSIXct and POSIXlt, ignore

unclass(t1)
# 1497363812 (the number of seconds since the beginning of 1970)

# change class from POSIXct to POSIXlt
t2 <- as.POSIXlt(Sys.time())

class(t2)
# "POSIXlt" "POSIXt" 

# printed t2 is identical to printed t1

# different internally

unclass(t2)
# --> list of sec, min, hour, day, etc.
# unclass(t1) --> number of seconds since 1970

# look at structure
str(unclass(t2))

# access minutes
t2$min

# show which weekday
weekdays(d1)

# show what month
months(t1)

# show which quarter of the year (Q1-Q4)
quarters(t2)

# strptime() converts character vectors to POSIXlt
# the input doesn't have to be in a particular format (YYY/-MM-DD) as in as.POSIXlt()

# create character vector
t3 <- "October 17, 1986 08:24" 

# convert character string to POSIXlt
t4 <- strptime(t3, "%B %d, %Y %H:%M")

# when I print t4 it says "NA" but swirl approves. ??

# also possible to perform arithmetics on date and time
# is current time larger than the time saved earlier?
Sys.time() > t1
# TRUE

# how much time has passed since I created t1?
Sys.time() - t1

# specify units with difftime
# days passed since I created t1
difftime(Sys.time(), t1, units = 'days')