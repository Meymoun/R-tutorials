## basics of R
## Bioconductor datasets and tools
## environments as hash tables
## ExpressionSet for holding genomic data
## visualization techniques

## apropos() find objects in the search path parially matching the given character string
## find() also finds, but is more restictive

## objects that contains "mean"
apropos("mean")

## info about the topic
help.search("mean")

## Exercise 2.1

## a) find plotting functions:
apropos("plot")

## b) find out which function to use to performa Mann-Whitney test
apropos("test")

## Mann-Whitney test: Wilcoxon-Mann-Whitney test: Wilcox.test

## c) open the PDF version of the vignette "Bioconductor overview" (part of the Biobase package)

openVignette("Biobase")


###############

## install packages: 
## install.packages()
## in bioconductor: biocLite()

## check for and install new versions of already installed packages:
## update.packages()
## need to supply update.packages with the URL to a Bioconductor repository


## Exercise 2.2
## What is the output of function sessionInfo?
## a function? ...

## 


