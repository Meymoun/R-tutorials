
library("Biobase")
library("genefilter")
library("ALL")
data("ALL")

# select B cells
bcell <- grep("^B", as.character(ALL$BT))

# select types: no cytogenetic abnormalities (NEG) and BCR/ABL translocation
moltyp <- which(as.character(ALL$mol.biol) %in% c("NEG", "BCR/ABL"))

# select the columns that intersect B cells and desired molecular type
ALL_bcrneg <- ALL[, intersect(bcell, moltyp)]

# drop unused levels of the factor variable mol.biol
ALL_bcrneg$mol.biol <- factor(ALL_bcrneg$mol.biol)


# 6.2 Non-specific filtering

# The shorth is the shortest interval that covers half of the values in x. 
# This function calculates the mean of the x values that lie in the shorth.
# estimates the peak of the distribution

sds <- rowSds(exprs(ALL_bcrneg))
sh <- shorth(sds)
sh


hist(sds, breaks = 50, col = "mistyrose", xlab = "standard deviation")
abline(v=sh, col ="blue", lwd = 3, lty = 2)

# we can see a large number of probes with low variability
# differential expression for their target genes will not be detected
# therefore remove probes with sd lower than the shorth

ALLfilt <- ALL_bcrneg[sds >= sh, ]

dim(exprs(ALLfilt))

# 6.3 Differential expression
table(ALLfilt$mol.biol)

tt <- rowttests(ALLfilt, "mol.biol")
names(tt)

hist(tt$p.value, breaks = 50, col = "mistyrose", xlab = "p-value",
     main = "Retained")

ALLrest <- ALL_bcrneg[sds < sh, ]
ttrest <- rowttests(ALLrest, "mol.biol")
hist(ttrest$p.value, breaks = 50, col = "lightblue", 
     xlab = "p-value", main = "Removed")

# The nonspecific filtering removed many probes that resulted in a high p-value in the t-test

# 6.4 Multiple testing correction
biocLite("multtest")
library("multtest")

# multiple t-tests
mt <- mt.rawp2adjp(tt$p.value, proc = "BH")

# 10 highest-ranking genes with respect to the adjusted p-value
g <- featureNames(ALLfilt[mt$index[1:10]])

library("hgu95av2.db")

# get the corresponding gene symbol for each probe in the top 10
links(hgu95av2SYMBOL[g])

mb <- ALLfilt$mol.biol
y <- exprs(ALLfilt)[g[1], ]
ord <- order(mb)

# plot the top 10 differently expressed probe sets 
# plot symbols indicate mol.biol value
plot(y[ord], pch = c(1, 16)[mb[ord]],
     col = c("black", "red")[mb[ord]], 
     main = g[1], ylab = expression(log[2]~intensity),
     xlab = "samples")

