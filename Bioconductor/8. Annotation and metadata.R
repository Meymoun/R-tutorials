
# make a subset of the ALL data
# select tumor with BCR/ABL and ALL1/AF4 translocation

library("ALL")
data("ALL")
types = c("ALL1/AF4", "BCR/ABL")
bcell = grep("^B", as.character(ALL$BT))
ALL_af4bcr <- ALL[, intersect(bcell,
                               which(ALL$mol.biol %in% types))]
ALL_af4bcr$mol.biol = factor(ALL_af4bcr$mol.biol)


# non-specific filter in order to remove probe sets that are likely to be noninformative
# the default measure for the variance filtering step is the IQR
# good when the sample sizes are approximately similar
# not the case for the BCR/ABL, ALL1/AF4 subset

# look at the range between the 0.1 and 0.9 quantile
qrange <- function(x) 
  diff(quantile(x, c(0.1, 0.9)))
library("genefilter")
filt_af4bcr <- nsFilter(ALL_af4bcr, require.entrez=TRUE,
                         require.GOBP=TRUE, var.func=qrange, var.cutoff=0.5)
ALLfilt_af4bcr <- filt_af4bcr$eset


library("Biobase")
library("annotate")
library("hgu95av2.db")

# two-group comparison to select the top 100 genes
rt <- rowttests(ALLfilt_af4bcr, "mol.biol")


## 
# Exercise 8.1
# Plot histograms of the t-statistic and of the p-values,

hist(rt$statistic, breaks=100, col="skyblue")
hist(rt$p.value, breaks=100, col="mistyrose")


# Exercise 8.2
# Create an ExpressionSet ALLsub with the 400 probe sets with smallest pvalues.

# doesn't create an environment
#ALLsub <- rt[order(rt$p.value),][1:400,]

# facit:
sel <- order(rt$p.value)[1:400]
ALLsub <- ALLfilt_af4bcr[sel,]

# Exercise 8.3
# How many probe sets in ALL and how many probe sets in ALLsub map to the
# same EntrezGene ID?
# facit: 

EG <- as.character(hgu95av2ENTREZID[featureNames(ALL)])
EGsub <- as.character(hgu95av2ENTREZID[featureNames(ALLsub)])

table(table(EG))

table(table(EGsub))


# Exercise 8.4
# Plot the expression profile of the CD44 gene, as in the left panel of Figure 8.2.
# facit: 

syms <- as.character(hgu95av2SYMBOL[featureNames(ALLsub)])
whFeat <- names(which(syms =="CD44"))
ordSamp <- order(ALLsub$mol.biol)

CD44 <- ALLsub[whFeat, ordSamp]
plot(as.vector(exprs(CD44)), main=whFeat,
       col=c("sienna", "tomato")[CD44$mol.biol],
       pch=c(15, 16)[CD44$mol.biol], ylab="expression")

# Exercise 8.5
# Produce a barplot, as in the right panel of Figure 8.2, that indicates for
# each chromosome the number of genes probed by ALLsub that are on that
# chromosome.

# mapping between probe sets and chromosome identifiers
z <- toTable(hgu95av2CHR[featureNames(ALLsub)])

# table of frequencies
chrtab <- table(z$chromosome)

# plot in numeric order
chridx <- sub("X", "23", names(chrtab))
chridx <- sub("Y", "24", chridx)
barplot(chrtab[order(as.integer(chridx))])


# create a HTML table for the list of genes in ALLsub
library("annaffy")
library("hgu95av2.db")
anncols = aaf.handler(chip="hgu95av2.db")[c(1:3, 8:9, 11:13)]
anntable = aafTableAnn(featureNames(ALLsub),
                         "hgu95av2.db", anncols)
saveHTML(anntable, "ALLsub.html",
           title="The Features in ALLsub")
localURL = file.path("file:/", getwd(), "ALLsub.html")


browseURL(localURL)

# detach a package
# detach("package:hgu95av2.db")


# hgu95av2.db is an annotation package, info about the genes incl. EntrezGene identifiers

# Exercise 8.6
# Select some pairs of probe sets that are mapped to the same gene and plot
# their expression values against each other. You can use Figures 8.3 and 8.4
# as examples.

probeSetsPerGene = split(names(EG), EG)
j = probeSetsPerGene$"7013"

# plot the data for the first and seventh probe set from EntrezGene id 7013
plot(t(exprs(ALL_af4bcr)[j[c(1,7)], ]), asp=1, pch=16,
     col=ifelse(ALL_af4bcr$mol.biol=="ALL1/AF4", "black",
                "grey"))

# heatmap

library("lattice")
mat = exprs(ALL_af4bcr)[j,]

## error: unable to find an inherited method for function ‘rowMedians’ for signature ‘"numeric"’
mat = mat - rowMedians(mat)
ro = order.dendrogram(as.dendrogram(hclust(dist(mat))))
co = order.dendrogram(as.dendrogram(hclust(dist(t(mat)))))
at = seq(-1, 1, length=21) * max(abs(mat))
lp = levelplot(t(mat[ro, co]),
                 aspect = "fill", at = at,
                 scales = list(x = list(rot = 90)),
                 colorkey = list(space = "left"))
print(lp)


# 8.3 Categories and overrepresentation

# Exercise 8.7
# Create a data.frame chr with two columns gene_id and chromosome which for
# each EntrezGene ID contains the chromosome to which it is mapped.

ps_chr = toTable(hgu95av2CHR)
ps_eg = toTable(hgu95av2ENTREZID)
chr = merge(ps_chr, ps_eg)
chr = unique(chr[, colnames(chr)!="probe_id"])

table(table(chr$gene_id))

# remove the conflicted mappings
chr = chr[!duplicated(chr$gene_id), ]


# Exercise 8.8
# Create a contingency table for the association of EntrezGene IDs with their chromosome
# mapping and with being differentially expressed in the ALLfilt_af4bcr
# data (remember the vector EGsub that you have created earlier). Use the
# functions fisher.test and chisq.test to test for association. (You may need
# to consult the man pages regarding its parameter simulate.p.value to make
# fisher.test work for these data.)

isdiff = chr$gene_id %in% EGsub
tab = table(isdiff, chr$chromosome)

fisher.test(tab, simulate.p.value=TRUE)
chisq.test(tab)

# Chromosomal location
# Exercise 8.9
# How many probe sets in ALLsub are on the sense strand? 
# + annotated in CHRLOC

chrloc <- toTable(hgu95av2CHRLOC[featureNames(ALLsub)])

table(table(chrloc$probe_id))
strds = with(chrloc,
             unique(cbind(probe_id, sign(start_location))))
table(strds[,2])

# 8.4 Working with GO
# GO terms can be linked by two relationships: "is a" and "part of"
# e.g a nuclear chromosome is a chromosome, and a nucleus is part of a cell

library("GO.db")

# to find the children of GO:0008094:
as.list(GOMFCHILDREN["GO:0008094"])

# all descendants (children, grandchildren, and so on)
as.list(GOMFOFFSPRING["GO:0008094"])


# 8.4.1 functional analyses
# test to check if genes are associated with a GO term
# conditional testing, more about it in ch 14
# another approach for the same thing: GSEA in ch 13

library("GOstats")

affyUniverse = featureNames(ALLfilt_af4bcr)

uniId = hgu95av2ENTREZID[affyUniverse]
entrezUniverse = unique(as.character(uniId))


params = new("GOHyperGParams",
               geneIds=EGsub, universeGeneIds=entrezUniverse,
               annotation="hgu95av2", ontology="BP",
               pvalueCutoff=0.001, conditional=FALSE,
               testDirection="over")
#mfhyper = hyperGTest(params)

## hyperGTest doesn't work, probably a bug in the package

#hist(pvalues(mfhyper), breaks=50, col="mistyrose")


# Exercise 8.10
# Look at the GO categories that appear to be significantly overrepresented.
# You could use a p-value cutoff of 0.001 
# (Hint: the summary method for GOHyperGResult will help a lot.) Is there a pattern?

sum = summary(mfhyper, p=0.001)
head(sum)

# Exercise 8.11
# Use the GOTERM annotation object to retrieve a more comprehensive
# description of some of the categories.

GOTERM[["GO:0032945"]]

# biomaRt

library("biomaRt")
head(listMarts())

# additional info from ensembl (also possible with uniprot)
# access the databases with the package biomaRt
mart = useMart("ensembl")

# check for available datasets
head(listDatasets(mart))

# our dataset is from human arrays, therefore update the mart object to hsapiens_gene_ensembl
ensembl = useDataset("hsapiens_gene_ensembl",
                     mart=mart)

# For the Ensembl database biomaRt offers a set of convenience functions for
# the most common tasks. The function getGene uses a vector of query IDs to
# look up names, descriptions, and chromosomal locations of corresponding genes.
# getGo can be used to fetch GO annotations and getSequences retrieves different
# kinds of sequence information. getSNP and getHomolog are useful to query SNP
# data or to map gene identifiers from one species to another.


# Exercise 8.12
# Fetch the sequences of 30 UTRs of our set of differentially expressed genes using
# getSequence. Take a look at its manual page to learn about the function’s parameters.
# Think about which type of gene IDs we have available for our set of genes.

utr = getSequence(id=EGsub, seqType="3utr",
                  mart=ensembl, type="entrezgene")

# get sequence
utr[1, ]

## ????

# get a list of available filters
head(listFilters(ensembl))

# should be, but group parameter doesn't work: 
# head(listFilters(ensembl, group="GENE:"))

# get a list of available attributes
head(listAttributes(ensembl))

# should be, but group parameter doesn't work: 
# head(listAttributes(ensembl, group="PROTEIN:"))

# Exercise 8.13
# For our set of differentially expressed genes, find associated protein domains. Such
# domains are stored for instance in the PFAM, Prosite, or InterPro databases. Try
# to find domain IDs for one or for all of these sources.

domains = getBM(attributes=c("entrezgene", "pfam",
                             "prosite", "interpro"), filters="entrezgene",
                value=EGsub, mart=ensembl)
interpro = split(domains$interpro, domains$entrezgene)
interpro[1]
## ???? doesn't work

library("hgu133a.db")

# to get a connection to the database
dbc = hgu133a_dbconn()

# extract data with the same subsetting or extraction functions as in environments
# get, mget, $ and [[
get("201473_at", hgu133aSYMBOL)
mget(c("201473_at","201476_s_at"), hgu133aSYMBOL)

hgu133aSYMBOL$"201473_at"
hgu133aSYMBOL[["201473_at"]]

# unlist simplifies to produce a vector
goCats = unlist(eapply(GOTERM, Ontology))

gCnums = table(goCats)[c("BP","CC", "MF")]


library("xtable")
xtable(as.matrix(gCnums), display=c("d", "d"),
         caption="Number of GO terms per ontology.",
         label="ta:GOprops")

# ???? doesn't work


library("DBI")

query = "select ontology from go_term"
goCats = dbGetQuery(GO_dbconn(), query)
gCnums2 = table(goCats)[c("BP","CC", "MF")]
identical(gCnums, gCnums2)


# search for GO terms containing the word chromosome
query = paste("select term from go_term where term",
              "like '%chromosome%'")
chrTerms = dbGetQuery(GO_dbconn(), query)
nrow(chrTerms)
head(chrTerms)


# find the GO identifier for “transcription factor binding” 
# and use that to get all Entrez Gene IDs with that annotation
query = paste("select go_id from go_term where",
              "term = 'transcription factor binding'")
tfb = dbGetQuery(GO_dbconn(), query)
tfbps = hgu133aGO2ALLPROBES[[tfb$go_id]]
table(names(tfbps))


# Exercise 8.14
# How many GO terms have the words transcription factor in them?
query_tf = paste(paste("select term from go_term where term",
                       "like '%transcription factor%'"))
tf = dbGetQuery(GO_dbconn(), query_tf)

nrow(tf)
head(tf)


# 8.7.1 Mapping symbols
# problem: when a publication gives the symbol or name of a gene, 
# but not the systematic database identifier
# solution: findEGs maps from symbols to Entrez Gene IDs


# first: see if the symbol is currently in use
# then: for those that were not found to search in the alias table, 
# to see if there are updated names
# Each of the first two queries within the findEGs function returns the
# symbol (the second columns of a1 and a2) and an identififer that is internal to
# the SQLite database (the first columns). The last query uses those internal
# IDs to extract the corresponding EntrezGene IDs.

queryAlias = function(x) {
  it = paste("('", paste(x, collapse="', '"), "'", sep="")
  paste("select _id, alias_symbol from alias",
        "where alias_symbol in", it, ");")
}
queryGeneinfo = function(x) {
  it = paste("('", paste(x, collapse="', '"), "'", sep="")
  paste("select _id, symbol from gene_info where",
        "symbol in", it, ");")
}
queryGenes = function(x) {
  it = paste("('", paste(x, collapse="', '"), "'", sep="")
  paste("select * from genes where _id in", it, ");")
}
findEGs = function(dbcon, symbols) {
  rs = dbSendQuery(dbcon, queryGeneinfo(symbols))
  a1 = fetch(rs, n=-1)
  stillLeft = setdiff(symbols, a1[,2])
  if( length(stillLeft)>0 ) {
    rs = dbSendQuery(dbcon, queryAlias(stillLeft))
    a2 = fetch(rs, n=-1)
    names(a2) = names(a1)
    a1 = rbind(a1, a2)
  }
  rs = dbSendQuery(dbcon, queryGenes(a1[,1]))
  merge(a1, fetch(rs, n=-1))
}


# The three columns in the return are the internal ID, the symbol, and the
# EntrezGene ID (gene_id).
findEGs(dbc, c("ALL1", "AF4", "BCR", "ABL"))


# 8.7.2 Other capabilities
# reverse a mapping, you have an annotation that goes from Affymetrix ID to symbol, 
# and you would like to have the mapping from symbols to Affymetrix IDs

s1 = revmap(hgu133aSYMBOL)
s1$BCR

toTable(hgu133aGO["201473_at"])
