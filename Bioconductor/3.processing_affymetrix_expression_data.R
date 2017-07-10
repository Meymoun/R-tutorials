biocLite("affy")
library("affy")

# ReadAffy imports CEL files into R objects, reads by default all CEL files in the current wd
myAB <- ReadAffy()

# specify files:
#myAB <- ReadAffy(filenames = c("a1.cel", "a2.cel", "a3.cel"))

library("CLL")
data("CLLbatch")

# 3.1.1 The sample annotation

sampleNames(CLLbatch)

data("disease")
head(disease)

# connect to SampleID
rownames(disease) <- disease$SampleID

# remove ".CEL" from name
sampleNames(CLLbatch) <- sub("\\.CEL$", "", sampleNames(CLLbatch))

slotNames(CLLbatch)

mt <- match(rownames(disease), sampleNames(CLLbatch))

# add descriptions of variables
vmd <- data.frame(labelDescription = c("Sample ID",
                                       "Disease status: progressive or stable disease"))

# create annotated dataframe
phenoData(CLLbatch) <- new("AnnotatedDataFrame",
                           data = disease[mt, ], varMetadata = vmd)

# remove samples where disease status is NA
CLLbatch <- CLLbatch[, !is.na(CLLbatch$Disease)]

## 3.2 Quality assessment and quality control

biocLite("affyQCReport")
library("affyQCReport")
biocLite("arrayQualityMetrics")
library("arrayQualityMetrics")
biocLite("simpleaffy")
library("simpleaffy")

# Figure 3.1 QC summary statistics (simpleaffy package)
saqc <- qc(CLLbatch)
plot(saqc)

dd <- dist2(log2(exprs(CLLbatch)))

# heatmap plot
diag(dd) = 0

dd.row <- as.dendrogram(hclust(as.dist(dd)))
row.ord <- order.dendrogram(dd.row)

biocLite("latticeExtra")
library("latticeExtra")

legend <- list(top = list(fun = dendrogramGrob, args = list(x = dd.row, side = "top")))

lp <- levelplot(dd[row.ord, row.ord], scales = list(x = list(rot = 90)), 
                xlab = "", ylab = "", legend = legend)

# plot heatmap
lp

biocLite("affyPLM")
library("affyPLM")

dataPLM <- fitPLM(CLLbatch)


# NUSE values are useful for comparing arrays within one dataset

boxplot(dataPLM, main = "NUSE", ylim = c(0.95, 1.22), outline = FALSE,
        col = "lightblue", las = 3, whisklty = 0, staplety = 0)

# Figure 3.3, RLE plot

Mbox(dataPLM, main = "RLE", ylim = c(-0.4, 0.4),
     outline = FALSE, col = "mistyrose", las = 3, 
     whysklty = 0, staplelty = 0)

# Figure 3.3 indicate that array CLL1 is problematic, 
# therefore, we drop it from our further analysis:

badArray <- match("CLL1", sampleNames(CLLbatch))
CLLB <- CLLbatch[, -badArray]

# Exercise 3.1
# repeat the calculation of the NUSE and RLE plots for the data with the array CLL1 removed
dataPLM_CLLB <- fitPLM(CLLB)

boxplot(dataPLM_CLLB, main = "NUSE", ylim = c(0.95, 1.22), outline = FALSE,
        col = "lightblue", las = 3, whisklty = 0, staplety = 0)


Mbox(dataPLM_CLLB, main = "RLE", ylim = c(-0.4, 0.4),
     outline = FALSE, col = "mistyrose", las = 3, 
     whysklty = 0, staplelty = 0)

# 3.3 Preprocessing

# rma was already defined in the workspace, 
# therefore I defined that it was the rma from the affy package
CLLrma <- affy::rma(CLLB)
# accepts an instance of the Affybatch class and returns 
# an ExpressionSet object that can be used in downstream analysis
# calculated in log2 scale

# exprs () extracts the expression matrix.
e <- exprs(CLLrma)
dim(e)

dim(CLLrma)

## Exercise 3.2
# how many probe sets are there in this dataset?
nrow(CLLrma)



pData(CLLrma)[1:3,]

table(CLLrma$Disease)

# 3.4 Ranking and filtering probe sets
library("genefilter")

# filter out probe sets with no ENtrez Gene identifiers
CLLf <- nsFilter(CLLrma, remove.dupEntrez = FALSE,
                 var.cutof = 0.5)$eset


# 3.4.1 Summary statistics and tests for ranking 
# Log fold-change

CLLtt <- rowttests(CLLf, "Disease")
names(CLLtt)

a <- rowMeans(exprs(CLLf))
a

## Exercise 3.3
# Plot the log-ratio CLLtt$dm against the average intensity, a, as in figure 3.4, 

# also plot log-ratio vs rank(a)

plot(x = a, y = CLLtt$dm, xlab = "average intensity", 
     ylab = "log-ratio", pch = ".")

plot(x = rank(a), y = CLLtt$dm, xlab = "rank of average intensity", 
     ylab = "log-ratio", pch = ".")

#facit:

par(mfrow = c(1,2))
myPlot <- function(...) {
    plot(y = CLLtt$dm, pch = ".", ylim = c(-2, 2),
         ylab = "log-ratio", ...)
    abline(h = 0, col = "blue")
    
}

myPlot(x = a, xlab = "average intensity")
myPlot(x = rank(a), xlab = "rank of average intensity")

# t-statistic
# measures the difference in mean divided by an estimate of the variance

biocLite("limma")
library("limma")

# few replicates --> variance poorly estimated --> modified t-statistics
# eBayes

design <- model.matrix(~CLLf$Disease)
CLLlim <- lmFit(CLLf, design)
CLLeb <- eBayes(CLLlim)

# when sample size are moderate or large (>10) there is generally no advantage 
# (but also no disadvantage) to using the Bayesian approach

## Exercise 3.4

# compare the t-statistics obtained under the two approaches. 
# facit: plot the two approaches 
plot(CLLtt$statistic, CLLeb$t[, 2], pch = ".")

# 3.4.2 Visualization of differential expression
# The volcano plot is a useful way to see the estimate of the log fold-change
# and statistic you choose to rank the genes simultaneously

lod <- -log10(CLLtt$p.value)
plot(CLLtt$dm, lod, pch = ".", xlab = "log-ratio",
     ylab = expression(-log[10]~p))
abline(h = 2)

## Exercise 3.5
# create a volcano plot using a moderated t-statistic
lodx <- -log10(CLLeb$p.value[, 2])
plot(CLLtt$dm, lodx, pch = ".", xlab = "log-ratio",
     ylab = expression(-log[10]~p))
abline(h = 2)

## 3.4.3 Highlighting interesting genes

## Exercise 3.6

# can you highlight the top 25 genes with the smallest p-value with a different color and symbol?
# hint: points() with options col = "blue" and pch = 18

##################################
# Ex 3.6 my solution:

sorted <- order(CLLtt$p.value)
#head(CLLtt$p.value[sorted])
#tail(CLLtt$p.value[sorted])
# smallest p.value first

s_pvalue <- CLLtt[sorted, ][1:25,]

lod <- -log10(CLLtt$p.value)
lod2 <- -log10(s_pvalue$pvalue)

plot(CLLtt$dm, lod, pch = ".", xlab = "log-ratio",
     ylab = expression(-log[10]~p))
abline(h = 2)

points(s_pvalue$dm, lod2, col = "blue", pch = 18)


#########################################
# Ex 3.6 facit:

# abs() absolute value
o1 <- base::order(CLLtt$p.value)[1:25]

#CLLtt$p.value[o1]

lod <- -log10(CLLtt$p.value)

plot(CLLtt$dm, lod, pch = ".", xlab = "log-ratio", 
     ylab = expression(-log[10]~p))
abline(h = 2)

points(CLLtt$dm[o1], lod[o1], col = "blue", pch = 18)

######################################

# my solution and facit give different plots
# fixed


#####################################

# Selecting hit lists and the multiple testing problem

# significant p-value: <= 0.01
significant_p <- CLLtt$p.value <= 0.01
sum(significant_p)


significant_p_tmod <- CLLeb$F.p.value <= 0.01
sum(significant_p_tmod)

?topTable
?p.adjust

# find out which metadata package we need, and load it
annotation(CLLf)
# [1] "hgu95av2"

## 3.4.5 Annotation
biocLite("annotate")
library("annotate")

# n = how many genes that should be selected
tab <- topTable(CLLeb, coef = 2, adjust.method = "BH", n = 10)
class(tab)
genenames <- as.character(rownames(tab))


ll <- getEG(genenames, "hgu95av2")

sym <- getSYMBOL(genenames, "hgu95av2")
sym

####################################################

# ??????????????????????

tab <- data.frame(sym, signif(tab[, -1], 3))

biocLite("geneplotter")
library("geneplotter")

htmlpage(list(ll), othernames = tab,
         filename = "GeneList1.html",
         title = "HTML report", table.center = TRUE,
         table.head = c("Entrez ID", colnames(tab)))

browseURL("GeneList1.html")

## can't make this to work ?? 

biocLite("KEGG.db")
library("KEGG.db")

library("hgu95av2.db")

biocLite("GO.db")
library("GO.db")
biocLite("annaffy")
library("annaffy")


library("ggplot2")

atab <- aafTableAnn(genenames, "hgu95av2.db", aaf.handler())
annaffy::saveHTML(atab, file = "GeneList2.html")

atab <- aafTableAnn(genenames, "hgu95av2.db",
                    aaf.handler()[c(2, 5, 8, 12)])
annaffy::saveHTML(atab, file = "GeneList3.html")

# ????????????
##############################

# Advanced preprocessing
# background correction
# normalization
# reporter summarization 


# Perfect match (PM) and ismatch (MM) probes
# PM probes are complementary to mRNA
# MM has the same sequence except for the 13th position, where the base is changed to its complementary base
# MMs measure non-specific hybridization. PM - MM = true intensity

# the PM and MM values an be extracted through pm() and mm()


pms <- affy::pm(CLLB)
mms <- affy::mm(CLLB)


## Exercise 3.8

#plot(mms, pms, pch = ".")



smoothScatter(log2(mms[,1]), log2(pms[,1]), pch = ".",
              xlab = expression(log[2] * " MM values"),
              ylab = expression(log[2] * " PM values"))
abline(a = 0, b = 1, col = "blue")

#rownames(mms)

#sampleNames(CLLB)
#featureNames(CLLB)

# in the first array (or sample) how many mm has stronger intensity than its corresponding pm?
sum(mms[, 1] > pms[, 1])

# compare MM in group 1: with PM values > 2000 with group 2: PM values < 2000
pms_high <- pms[, 2] > 2000
pms_low <- pms[, 2] < 2000

mms_col2 <- mms[, 2]

mms_phigh <- mms_col2[pms_high]

mms_plow <- mms_col2[pms_low]

hist(mms_phigh)
hist(mms_plow)

grouping <- cut(log2(pms)[, 2], breaks = c(-Inf, log2(2000), Inf),
                labels = c("Low", "High"))

multidensity(log(mms)[, 2] ~ grouping, main = "", xlab = "",
             col = c("red", "blue"), lwd = 2)

legend("topright", levels(grouping), lty = 1, lwd = 2, 
           col = c("red", "blue")) 

#################################

# 3.5.2 Background correction

## background correction with rma
# background correction
bgrma <- bg.correct.rma(CLLB)

# exprs() extracts data from an eSet
# --> log2 the values
exprs(bgrma) <- log2(exprs(bgrma))

biocLite("vsn")
library("vsn")

# justvsn is equivalent to calling:

# fit = vsn2(x, ...)
# nx = predict(fit, newdata=x, useDataInFit = TRUE)

# vsn2 fits the vsn model to the data in x and returns a vsn object with the fit 
# parameters andthe transformed data matrix
# normalization

## background correction with vsn
bgvsn <- justvsn(CLLB)



# compare the result of the two background correction methods to the original values and 
# to each other

# RMA, 6 first samples
bgrma_subset <- bgrma[, 1:6]
exprs(bgrma_subset) <- log2(exprs(bgrma_subset))


# VSN, 6 first samples
bgvsn_subset <- bgvsn[,1:6]

# package hexbin required to plot meanSdPlot
biocLite("hexbin")
library("hexbin")

# plot mean sd on expression values
meanSdPlot(exprs(bgvsn_subset))
meanSdPlot(exprs(bgrma_subset))

# compare values to each other
plot(exprs(bgrma_subset), exprs(bgvsn_subset), xlab = "RMA", ylab = "VSN", pch = ".")

# different to the one in the book... 

# facit:
# select random subset of PM probes in one sample

sel <- sample(unlist(indexProbes(CLLB, "pm")), 500)
sel <- sel[order(exprs(CLLB)[sel, 1])]

yo <- exprs(CLLB)[sel, 1]
yr <- exprs(bgrma)[sel, 1]
yv <- exprs(bgvsn)[sel, 1]

# asp() : the y/x aspect ratio

# fits 3 graphs in one figure
par(mfrow=c(1,3))

# original vs RMA corrected
plot(yo, yr, xlab = "Original", ylab = "RMA", log = "x", type = "l", asp = 1)

# original vs VSN corrected
plot(yo, yv, xlab = "Original", ylab = "VSN", log = "x", type = "l", asp = 1)

# RMA vs VSN corrected
plot(yr, yv, xlab = "RMA", ylab = "VSN", type = "l", asp = 1, xlim = c(0, 14))


# the return value of justvsn is an AffyBatch with values that have been
# backgound-corected, normalized between arrays and log2 transformed
# vsnrma call the function rma with arguments normalize=FALSE and background=FALSE




CLLvsn <- vsnrma(CLLB)

CLLvsnf <- nsFilter(CLLvsn, remove.dupEntrez = FALSE,
                    var.cutoff = 0.5)$eset

CLLvsntt <- rowttests(CLLvsnf, "Disease")


names(CLLtt)

names(CLLvsntt) 

# compare t-test statistic between RMA (CLLtt) and VSN (CLLvsntt)

# select the intersect
inboth <- intersect(featureNames(CLLvsnf),
                    featureNames(CLLf))

plot(CLLtt[inboth, "statistic"], 
     CLLvsntt[inboth, "statistic"],
     pch = ".", xlab = "RMA", ylab = "VSN")



## 3.5.3 Summarization

pns <- probeNames(CLLB)
indices <- split(seq(along = pns), pns)

length(indices)

indices[["189_s_at"]]


# can you plot the PM and MM intensities for the probes of one probe set across a set of arrays?
i <- indices[["160038_s_at"]]

pm_array_x <- pms[i,]
mm_array_x <- mms[i,]

# facit exercise 3.12

# matplot plot the columns of one matrix against the columns of another.
# t(matrix/data frame) transpose matrix

colors <- brewer.pal(8, "Dark2")
index <- indices[["189_s_at"]][seq(along=colors)]
matplot(t(pms[index, 1:12]), pch = "P", log = "y", type = "b", lty = 1, main = "189_s_at",
        xlab = "samples", ylab = expression(log[2]~Intensity), ylim = c(50, 2000), col = colors)
matplot(t(mms[index, 1:12]), pch = "M", log = "y", type = "b",
        lty = 3, add = TRUE, col = colors) 

newsummary <- t(sapply(indices, function(j)
                       rowMedians(t(pms[j, ]-mms[j, ]))))
dim(newsummary)

# newsummary --> matrix with one row for each probe set and one column for each sample

# Exercise 3.13
# what percent of probe sets, for each array, yield negative values for each array?


