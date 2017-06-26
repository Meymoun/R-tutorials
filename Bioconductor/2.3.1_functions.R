

sq1 = function(x) return (x*x)
sq2 = function(x) x*x

## Exercice 2.4
## function that takes a string as input and reurn that string with a caret prepended
## ppc('xx') returns '^xx'

ppc = function(x) {
  
  (paste('^', x, sep = ""))
  
}
