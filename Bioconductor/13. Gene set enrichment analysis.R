# Ch 13 Gene set enrichment analysis
# focused on two-sample problems, where the data can be divided into 2 groups
# and we want to understand the set of differentially expressed genes between the groups

library("ALL")
data("ALL")

bcell <- grep("^B", as.character(ALL$BT))

moltyp <- which(as.character(ALL$mol.biol) %in% c("NEG", "BCR/ABL"))

ALL_bcrneg <- ALL[, intersect(bcell, moltyp)]
ALL_bcrneg$mol.biol <- factor(ALL_bcrneg$mol.biol)

library("genefilter")

ALLfilt_bcrneg <- nsFilter(ALL_bcrneg, var.cutoff = 0.5)$eset

names(ALLfilt_bcrneg)


# Exercise 13.1
# a) How many samples are in our subset? How many are BCR/ABL and how many NEG?
# b) How many probe sets have been selected for our analysis?

# a)
table(ALLfilt_bcrneg$mol.biol)

# b)



# 13.2.2 Using KEGG
# mapping of genes to pathways

#biocLite("GSEABase")
library("GSEABase")

gsc = GeneSetCollection(ALLfilt_bcrneg,
                          setType=KEGGCollection())
Am = incidence(gsc)
dim(Am)

# select only the probes in the database
nsF = ALLfilt_bcrneg[colnames(Am),]

# t-test for the expression in NEG vs BCR/ABL
rtt = rowttests(nsF, "mol.biol")
rttStat = rtt$statistic


# Exercise 13.3
# How many test statistics are positive? How many are negative? How many have
# a p-value less than 0.01?

# remove all gene sets that have fewer than ten genes in them

selectedRows = (rowSums(Am)>10)
Am2 = Am[selectedRows, ]

tA = as.vector(Am2 %*% rttStat)
tAadj = tA/sqrt(rowSums(Am2))
names(tA) = names(tAadj) = rownames(Am2)

# Q-Q plot
qqnorm(tAadj)

#biocLite("KEGG")
library("KEGG.db")

# look at the pathway with a remarkably low observed value (less than -5)
## smPW = tAadj[tAadj < (-5)]
# the data has been updated on the server because of that we get 3 hits instead of 1 (in the tutorial) but for the sake of the tutorial we only choose the one they chose
# 03040
smPW = tAadj[tAadj < (-5)][3]
## alternative way to get the pwName because KEGGPATHID2NAME didn't work (don)
#1 try one by one
# KEGGPATHID2NAME[[names(smPW)[x]]] and up to x=1,2,3
#2
#as.data.frame(KEGGPATHID2NAME)[which(as.data.frame(KEGGPATHID2NAME)$path_id %in% names(smPW)),]$path_name

#as.data.frame(KEGGPATHID2NAME)$path_id %in% names(smPW)) check if the names of smPW are existed in KEGGPATHID2NAME
# with which function you can find the row number of the hits which(as.data.frame
# call those rows and select the path_names of them $path_name 

#pwName = as.data.frame(KEGGPATHID2NAME)[which(as.data.frame(KEGGPATHID2NAME)$path_id %in% names(smPW)),]$path_name
pwName = KEGGPATHID2NAME[[names(smPW)]]
pwName

# Now we can produce some summary plots based on the genes annotated at this
# pathway. The mean plot presents a comparison of the average expression value
# for each of our two groups, for each gene in the specified pathway.

KEGGmnplot(names(smPW), nsF, "hgu95av2", nsF$"mol.biol",
           pch=16, col="darkblue")

# Exercise 13.4
# Many of the points in Figure 13.2 appear to lie above the diagonal. Is this to be
# expected?”
# the genes in that pathway is not associated with either of the molecular subtypes

sel = as.integer(nsF$mol.biol)
KEGG2heatmap(names(smPW), nsF, "hgu95av2",
               col=colorRampPalette(c("white", "darkblue"))(256),
             ColSideColors=c("black", "white")[sel])


# Exercise 13.5
# What sorts of things do you notice in the heatmap? The gene labeled 41214_at
# has a very distinct pattern of expression. Can you guess what is happening? Hint:
# look at which chromosome it is on.


# 13.2.3 Permutation testing

# 1000 random permutations 

set.seed(123)
NPERM = 1000
pvals = gseattperm(nsF, nsF$mol.biol, Am2, NPERM)
pvalCut = 0.025
lowC = names(which(pvals[, 1]<=pvalCut))
highC = names(which(pvals[, 2]<=pvalCut))

getPathNames(lowC)

getPathNames(highC)

# Exercise 13.6
# What permutation-base p-value is the most extreme? What does the
# heatmap look like for this gene set?
apply(pvals, 2, min)
rownames(pvals)[apply(pvals, 2, which.min)]

# Exercise 13.7
# Compare the p-values from the parametric analysis to those from the
# permutation analysis.

permpvs = pmin(pvals[,1], pvals[,2])
pvsparam = pnorm(tAadj)
pvspara = pmin(pvsparam, 1-pvsparam)
plot(permpvs, pvspara, xlab="Permutation p-values",
       ylab="Parametric p-values")

# 13.2.4 Chromosome bands

# Exercise 13.8
# What does the manual page say is the interpretation of the MAP position
# 17p33.2?
# the gene is located on the p arm of chr 17, band 3, sub-band 3 and sub-sub-band 2


# Exercise 13.9
# Just as we did for the KEGG analysis, we need to remove probe sets that
# have no chromosome band annotation. Follow the approach used in the
# KEGG analysis and create a new ExpressionSet object nsF2. We will use it
# later in this chapter.

fnames = featureNames(ALLfilt_bcrneg)
if (is(hgu95av2MAP, "environment")) {
    chrLocs = mget(fnames, hgu95av2MAP)
    mapping = names(chrLocs[sapply(chrLocs,
                                 function(x) !all(is.na(x)))])

} else {
    mapping = toTable(hgu95av2MAP[fnames])$probe_id
    }


psWithMAP = unique(mapping)
nsF2 = ALLfilt_bcrneg[psWithMAP, ]


# relevant MAP positions

EGtable = toTable(hgu95av2ENTREZID[featureNames(nsF2)])
entrezUniv = unique(EGtable$gene_id)
chrMat = MAPAmat("hgu95av2", univ=entrezUniv)
rSchr = rowSums(chrMat)

# Exercise 13.10
# How many genes were selected? How many map positions?
dim(chrMat)

# The value returned by MAPAmat is a matrix where the rows are the chromosome
# bands and the columns are the genes.
# 4291 genes and 1090 map positions


# Exercise 13.11
# Further reduce chrMat so that only bands with at least five genes are retained.
# Produce a Q–Q plot and identify the interesting bands. Use Google or some
# other search engine to determine what might be interesting about these bands.
# Do an analysis similar to the one we performed on the KEGG pathways.
# Produce mean plots, heatmaps, and so on. Try to identify a set of interesting
# bands.

rtt2 = rowttests(nsF2, "mol.biol")
rttStat2 = rtt2$statistic

chrMat2 <- chrMat[rowSums(chrMat) <= 5, ] 

tA2 = as.vector(chrMat2 %*% rttStat2)
tAadj2 = tA2/sqrt(rowSums(chrMat2))
names(tA2) = names(tAadj2) = rownames(chrMat2)

# Q-Q plot
qqnorm(tAadj2)

# heatmap and mean plots etc


# Exercise 13.12
# Reorder the columns of chrMat so that they are in the same order as the
# corresponding features in the ExpressionSet object nsF2.

EGlist = mget(featureNames(nsF2), hgu95av2ENTREZID)
EGIDs = sapply(EGlist, "[", 1)
idx = match(EGIDs, colnames(chrMat))
chrMat2 = chrMat2[, idx]

Ams = Am2[union(lowC, highC),]
Amx = Ams %*% t(Ams)
minS = outer(diag(Amx), diag(Amx), pmin)
overlapIndex = Amx/minS

heatmap(overlapIndex)


# Exercise 13.13
# How many genes are in each of the four pathways, 04512, 04940, 04510,
# 04514? How many are in the overlap for each pair?

rowSums(Ams)[c("04512", "04940", "04510", "04514")]

Amx["04512", "04510"]

Amx["04940", "04514"]


# first: fit a linear model to each of the two gene sets seperately
# and observe that the corresponding p-values are less than 0.05. But when both
# are included in the model, only one remains significant.

P04512 = Ams["04512", ]
P04510 = Ams["04510", ]
lm1 = lm(rttStat ~ P04512)
summary(lm1)$coefficients

lm2 = lm(rttStat ~ P04510)
summary(lm2)$coefficients

# both
lm3 = lm(rttStat ~ P04510+P04512)
summary(lm3)$coefficients

# We next divide the genes into three groups: those that are in 04512
# only, those that are in both sets, and those that are in 04510 only

P04512.Only = ifelse(P04512 != 0 & P04510 == 0, 1, 0)
P04510.Only = ifelse(P04512 == 0 & P04510 != 0, 1, 0)
Both = ifelse(P04512 != 0 & P04510 != 0, 1, 0)
lm4 = lm(rttStat ~ P04510.Only + P04512.Only + Both)
summary(lm4)


# repeat for the others 

# ["04940", "04514"]

P04940 <- Ams["04940", ]
P04514 <- Ams["04514", ]

ex_lm1 <- lm(rttStat ~ P04940)
summary(ex_lm1)$coefficients

ex_lm2 <- lm(rttStat ~ P04514)
summary(ex_lm2)$coefficients

ex_lm3 <- lm(rttStat ~ P04940 + P04514)
summary(ex_lm3)$coefficients

P04940.Only <- ifelse(P04940 != 0 & P04514 == 0, 1, 0)
P04514.Only <- ifelse(P04940 == 0 & P04514 != 0,1,0)
Both2 <- ifelse(P04940 != 0 & P04514 != 0,1,0)

ex_lm4 <- lm(rttStat ~ P04940.Only + P04514.Only + Both2)
summary(ex_lm4)
