cube <- function(x, n) {
  x^3
}

cube(3)
# result: 27

###############################

x <- 1:10

if(x > 5) {
  x <- 0
}

# Warning message:
#  In if (x > 5) { :
#      the condition has length > 1 and only the first element will be used

################################

f <- function(x) {
  g <- function(y) {
    y + z
  }
  z <- 4
  x + g(x)
}

z <- 10
f(3)
# result: 10

################################

x <- 5
y <- if(x < 3) {
  NA
} else {
  10
}

y
# result: 10

#################################

h <- function(x, y = NULL, d = 3L) {
  z <- cbind(x, d)
  if(!is.null(y))
    z <- z + y
  else
    z <- z + f
  g <- x + y / z
  if(d == 3L)
    return(g)
  g <- g + 10
  g
}

h(4)
# free variable: not defined in the function
# f