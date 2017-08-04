# nonspecific filtering
# multiple testing
# the moderated test statistics provided by the limma package
# gene selection by ROC curves

# 7.1.1 The gene-by-gene approach
# ignore the dependencies between genes (eg. their interrelationships in regulatory modules)

# 7.1.2 Nonspecific filtering
# most microarrays contain probes for many more genes than will be differntially expressed
# one of the basic assumptions of normalization is that most genes are not differentially expressed
# loss of power
# nonspecific = filter genes witout reference to the parameters or conditions of the tested RNA samples
# aims to remove the sets of probes that are not differentilly expressed under any comparison
# the book says it's most useful to select genes of thebasics of variability (see chapter 6, last part)
# only the genes that show any variation across samples can potentially be differentially expressed among our groups of interest

# 7.1.3 Fold-change vs t-test
# the simplest approach to select genes is using a fold-change criterion
# may be the only possibility when few replicates are available
# however, loss of variability info
# other approach: diffrences between the distributions of a gene's expression levels under different conditions
# mean or median --> t-test 
# other properties of the distribution: the parial area under the ROC curve

library("ALL")
data("ALL")

bcell <- grep("^B", as.character(ALL$BT))
moltyp <- which(as.character(ALL$mol.biol) %in% c("NEG", "BCR/ABL"))
ALL_bcrneg <- ALL[, intersect(bcell, moltyp)]
ALL_bcrneg$mol.biol <- factor(ALL_bcrneg$mol.biol)

library("vsn")
meanSdPlot(ALL_bcrneg)

# the ranks parameter indicates wheter the x-axis shoudl be plotted 
# on the original scale (FALSE, default)
# or on the rank scale (TRUE)
# The latter distributes the data more evenly along the x-axis 
# and allows a better visual assessment of the standard deviation as a function of the mean.

# filter out the 80% lowest variability probe sets
# the book choses this high fraction because they want to limit the length of the computations
# otherwise this fraction usually is a lot lower, 
# the fraction depends on the array design and the biological samples

sds <- esApply(ALL, 1, sd)

sel <- (sds > quantile(sds, 0.8))
ALLset1 <- ALL_bcrneg[sel, ]

# 7.3 Differential expression
# rowttests perform a t-test for every row in a gene expression matrix
# rowFtests, doest F-tests, 
# rowQ calculates the quantile for each row

library("genefilter")
tt <- rowttests(ALLset1, "mol.biol")
names(tt)

# volcano plot
# p-value vs fold-change
plot(tt$dm, -log10(tt$p.value), pch = ".",
     xlab = expression(mean~log[2]~fold~change), 
     ylab = expression(-log[10](p)))


# Exercise 7.2 
# determine how many probe sets correspond to differnetially expressed genes using the t-test results
# abs() the absolute value

sum(tt$p.value < 0.05 & abs(tt$dm) > 0.5)

# 7.4 Multiple testing
# mt.maxT performing a permutating test using the Welch statistic 
# B = number of permutations

library("multtest")
cl <- as.numeric(ALLset1$mol.biol == "BCR/ABL")
resT <- mt.maxT(exprs(ALLset1), classlabel = cl, B = 1000)
ord <- order(resT$index) # the original gene order
rawp <- resT$rawp[ord] # permutation p-values

hist(rawp, breaks = 50, col = "#B2DF8A")

# to control the familiwise error rate (FWER) 
# (the probability of at least one false positive in the set of significatnt genes)
# mt.maxT used the permutation-based maxT procedure of Westfall and Young

sum(resT$adjp < 0.05)

# we obtain 34 genes with an adjusted p-value below 0.05
# compare with the histogram, lots of raw p-values below 0.05
# the book suggest that we're missing a large number of differentially expressed genes
# the FWER is a very stringent criterion, and in some microarray studies, 
# few or no genes may be significant in this sense

# a more sensitive criterion is provided by the false discovery rate (FDR)
# the expected proportion of false positives among the genes that are called significant


res <- mt.rawp2adjp(rawp, proc = "BH")
sum(res$adjp[, "BH"] < 0.05)


# 7.5 Moderated test statistics and the limma package

# t-test analysis with the limma package functions
library("limma")


# define the design matrix
design <- cbind(mean = 1, diff = cl)

# a linear model fitted for every gene by the function lmFit
# an empirical Bayes moderation of the standard errors

fit <- lmFit(exprs(ALLset1), design)
fit <- eBayes(fit)

# list the top 10 differentially expressed genes
library("hgu95av2")
ALLset1Syms <- unlist(mget(featureNames(ALLset1),
                            env = hgu95av2SYMBOL))
topTable(fit, coef = "diff", adjust.method = "fdr",
           sort.by = "p", genelist = ALLset1Syms)


# compare the p-values with the result of the parametric t-test = almost identical
plot(-log10(tt$p.value), -log10(fit$p.value[, "diff"]),
     xlab = "-log10(p) from two-sample t-test",
     ylab = "-log10(p) from moderated t-test (limma)",
     pch=".")
abline(c(0, 1), col = "red")


# 7.5.1 Small sample sizes

# The Bayes moderation can be useful in cases with fewer replicates
subs <- c(35, 65, 75, 1, 69, 71)
ALLset2 <- ALL_bcrneg[, subs]
table(ALLset2$mol.biol)

# t-test with small sample size
tt2 = rowttests(ALLset2, "mol.biol")
fit2 = eBayes(lmFit(exprs(ALLset2), design=design[subs, ]))

plot(-log10(tt2$p.value), -log10(fit2$p.value[, "diff"]),
     xlab = "-log10(p) from two-sample t-test",
     ylab = "-log10(p) from moderated t-test (limma)",
     pch=".")
abline(c(0, 1), col = "red")

# look at a gene that has a small p-value in the normal t-test but a large one in
# the moderated test
g <- which(tt2$p.value < 1e-4 &
            fit2$p.value[, "diff"] > 0.02)


# plot the expression values
# select different symbols for the different classes
# (ALLset2$mol.bio == "BCR/ABL") --> logical array, + 1 is equal to FALSE = 1 and TRUE = 2
sel <- (ALLset2$mol.bio == "BCR/ABL") + 1

# black for the first class in sel and red for the second class (different colors)
col <- c("black", "red")[sel]

# pch = 1 for the first class, pch = 16 for the second class (different symbols)
pch <- c(1,16)[sel]

# plot the expression of the gene in variable g
plot(exprs(ALLset2)[g,], pch=pch, col=col,
     ylab="expression")



# 7.6 Gene selection by Receiver Operator Characteristic (ROC)
# classification-based approach to find differentially expressed genes
# discriminate between groups
# plot sensitivity vs p = 1 - specificity
# identify genes that have the best ability to detect whether a sample has
# the BCR/ABL translocation
# area under the ROC curve (AUC)
# The pAUC criterion, for a small value of p such as p = 0.2, 
# is often more relevant than the AUC because
# for a practical diagnostic marker we will require high specificity, say, better than
# 80 %, before even considering its sensitivity.

# In addition, the function has an argument flip. If it is
# set to TRUE (the default), then for each gene both classification rules x < θ
# and x > θ are tested, and the (partial) area under the curve of the better
# one of the two is returned. 

rocs <- rowpAUCs(ALLset1, "mol.biol", p=0.2)

# select the probe set with the maximal value of our pAUC statistic
j <- which.max(area(rocs))
plot(rocs[j], main = featureNames(ALLset1)[j])


# Exercise 7.3
# Plot the expression values of 1636_g_at
# facit:
mtyp <- ALLset1$mol.biol
sel <- rep(1:2, each=rev(table(mtyp)))
plot(exprs(ALLset1)[j, order(mtyp)], pch=c(1,15)[sel],
       col=c("black", "red")[sel],
       main=featureNames(ALLset1)[j],
       ylab=expression(log[2]~expression~level))
legend("bottomleft", col=c("black", "red"),
         pch=c(1,15), levels(mtyp), bty="n")

# Exercise 7.4 
# How would you expect the ROC curve to look for a gene that does not
# show any differential expression between the groups? How would an ”ideal”
# ROC curve look? Why?

# A ROC curve that doesn't show any differential expression between 2 groups
# would be a diagonal, sensitivity follow p (1 - specificity)
# an ideal curve shows both high sensitivity and high specificity


# 7.7 When power increases

# wrapper function around t-test
nrsel.ttest = function(x, pthresh=0.05) {
  pval = rowttests(x, "mol.biol")$p.value
  return(sum(pval < pthresh))

}

# wrapper function around rowpAUCs 
nrsel.pAUC = function(x, pAUCthresh=2.5e-2) {
  pAUC = area(rowpAUCs(x, fac="mol.biol", p=0.1))
  return(sum(pAUC > pAUCthresh))
}


biocLite("BiocCaseStudies")
library(BiocCaseStudies)
x <- ALLset1[sample(nrow(ALLset1), 1000), ]


resample(x, "nrsel.ttest")
resample(x, "nrsel.pAUC")
