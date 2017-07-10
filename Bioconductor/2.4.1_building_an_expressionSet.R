biocLite("convert")
library(convert)


## Building an ExpressionSet from .CEL and other files
# try:
as(object, "ExpressionSet")
# says in the book it might not work, that no converter is available. 
# Error message is "'object' not found" ?

# Building an ExpressionSet from scratch

# assay data, sample annotations, feature annotations, overall description of the experiment

# F rows and S columns (F = number of features, S = number of samples)
# data imported from "tab-delimited" text file (eg. exported from a spreadsheet)
# rows corresponding to F, columns to S
# use: read.table(), converts the result to a matrix


dataDirectory <- system.file("extdata", package = "Biobase")
exprsFile = file.path(dataDirectory, "exprsData.txt")
exprs = as.matrix(read.table(exprsFile, header = TRUE,
                             sep = "\t", row.names = 1, as.is = TRUE))

# replace the file path with string: 
#exprsFile <- "c:/path/to/exprsData.txt"
# to get relative path: setwd(location of file), read.table("./folder/file.R")
# ? otherwise, use full path ? 

# for comma-separated values, or "csv" files, use sep argument sep = ","

# look at data
class(exprs)
dim(exprs)
colnames(exprs)
head(exprs)


# Sample annotation
# information about the sample (e.g experimental conditions or parameters, 
# or attributes of the subjects such as sex, age, and diagnosis) are covariates

pDataFile <- file.path(dataDirectory, "pData.txt")
pData <- read.table(pDataFile, 
                    row.names = 1, header = TRUE, sep = "\t")
dim(pData)

rownames(pData)

summary(pData)

# the row of the sample data table align with the columns of the expression data matrix
# if not, ExpressionSet will complain
all(rownames(pData) == colnames(exprs))

# some covariates are represented as numeric values, others (eg. gender, tissue type or cancer status)
# are better represented as factors

## Exercise 2.7
# a) which class do read.table return?
class(pData)
# read.table returns class = data.frame

# b) determine the column names of pData
# hint: apropos("name") ? 
colnames(pData)

# c) use sapply to determine the classes of each column of pData
sapply(pData, class)

# d) what is the sex and Case/Control status of the 15th and 20th samples?

pData[15,"gender"]
# [1] Female

pData[15,"type"]
# [1] Case

pData[20,]
# dataframe: 
#   gender type score
# T Female Case 0.74

# what is the status for the sample(s) with score greater than 0.8?
subset(pData, subset = score > 0.8)
# gives a dataframe subset

# or: 
select <- pData$score > 0.8
pData[select, "type"]
# for a factor vector


metadata <- data.frame(labelDescription = c("Patient gender", 
                                            "Case/Control status", "Tumor progress on XYZ scale"),
                                            row.names = c("gender", "type", "score"))

adf <- new("AnnotatedDataFrame", data = pData, varMetadata = metadata)
adf

head(pData(adf))

adf[c("A", "Z"), "gender"]

pData(adf[adf$score > 0.8,])

annotation <- "hgu95av2"

experimentData <- new("MIAME", name = "Pierre Fermat", 
                      lab = "Francis Galton Lab", contact = "pfermat@lab.not.exist",
                      title = "Smoking-Cancer Experiment", abstract = "An example Expression Set",
                      url = "www.lab.not.exist", other = list(notes = "Created from text files"))

exampleSet <- new("ExpressionSet", exprs = exprs, phenoData = adf,
                  experimentData = experimentData, annotation = "hgu95av2")

minimalSet <- new("ExpressionSet", exprs = exprs)



## 2.4.3
# ExpressionSet basics

help("ExpressionSet-class")

exampleSet

# accessing data elements
exampleSet$gender[1:5]

exampleSet$gender[1:5] == "Female"

# name of the feature: eg. probe set identifiers
featureNames(exampleSet)[1:5]

# sample names
sampleNames(exampleSet)[1:5]

# list the column names
varLabels(exampleSet)

mat <- exprs(exampleSet)
dim(mat)

adf <- phenoData(exampleSet)
adf

vv <- exampleSet[1:5, 1:3]
dim(vv)

featureNames(vv)

sampleNames(vv)

# creating a subset consising of only the male samples

males <- exampleSet[, exampleSet$gender == "Male"]
males

# graphics
# plot and par 
# par is used to set parameters in eg. plot

x <- exprs(exampleSet[, 1])
y <- exprs(exampleSet[,3])
plot(x = x, y = y, log = "xy")

# Exercise 2.8
# add meaningful axis labels and a title to the plot
# change the plotting symbols


# pch changes the plotting symbol

plot(x = x, y = y, log = "xy", pch = 1,  
     xlab = "Sample A", ylab = "Sample C", 
     main = "Expression intensities")


######### ???????????????????
# add the 45 degrees diagonal to the plot, hint: use abline()

biocLite("CLL")
library("CLL")
biocLite("matchprobes")
library("matchprobes")
biocLite("hgu95av2probe")
library("hgu95av2probe")
biocLite("hgu95av2cdf")
library("hgu95av2cdf")
biocLite("RColorBrewer")
library("RColorBrewer")
biocLite("oligo")
library("oligo")

data("CLLbatch")

bases <- basecontent(hgu95av2probe$sequence)

# match the probes via their position on the array to 
# positions in the data matrix of the CLLbatch object
iab <- with(hgu95av2probe, xy2indices(x, y, cdf = "hgu95av2cdf"))
probedata <- data.frame(int = rowMeans(log2(exprs(CLLbatch)[iab, ])),
                        gc = bases[, "C"] + bases[, "G"])

colorfunction = colorRampPalette(brewer.pal(9, "GnBu"))
mycolors <- colorfunction(length(unique(probedata$gc)))
label <- expression(log[2]~intensity)

# boxplots of the distributions of log2 intensities from the CLL dataset grouped by GC content
# figure 2.2
boxplot(int ~ gc, data = probedata, col = mycolors,
        outline = FALSE, xlab = "Number of G and C", 
        ylab = label, main = "")

tab <- table(probedata$gc)
gcUse <- as.integer(names(sort(tab, decreasing = TRUE)[1:10]))
gcUse

biocLite("geneplotter")
library("geneplotter")

# density plot figure 2.3
multidensity(int ~ gc, data = subset(probedata, gc %in% gcUse), 
             xlim = c(6, 11), col = colorfunction(12)[-(1:2)],
             lwd = 2, main = "", xlab = label)

## Exercise 2.9
# create a plot similar to the one in Figure 2.3 using the function multiecdf
# plot of the emperical cumulative distribution --> useful distribution summary plot


multiecdf(int ~ gc, data = subset(probedata, gc %in% gcUse),
          ylab = "Cumulative distribution")

# ??

