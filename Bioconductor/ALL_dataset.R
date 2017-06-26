## data subsetting 
## compare 2 groups: BCR/ABL "philadelphia chromosome" and NEG (no cytogenetic abnormality found)

## grep function finds patterns in strings
## select index of B cells in column BT
bcell = grep("^B", as.character(ALL$BT))

## which are the samples are of molecular type BCR/ABL or NEG
types = c("NEG", "BCR/ABL")

## returns logical vector, values to be matched %in% values to be matched agains
moltyp = which(as.character(ALL$mol.biol) %in% types)

## find the intersect between B cells and moltyp (BCR/ABL or NEG)
ALL_bcrneg = ALL[, intersect(bcell, moltyp)]

## reduce the set of factor levels
ALL_bcrneg$mol.biol = factor(ALL_bcrneg$mol.biol)
ALL_bcrneg$BT = factor(ALL_bcrneg$BT)

biocLite("hgu95av2.db")
library("hgu95av2.db")

## nonspecific filtering
## nsFilter from the genefilter package
## feature.exclude = "^AFFX", excludes probes (by their prefix AFFX)
## the 0.5 quantile of the IQR values is chosed as a cutoff

varCut = 0.5
filt_bcrneg = nsFilter(ALL_bcrneg, require.entrez = TRUE,
                       require.GOBP = TRUE, remove.dupEntrez = TRUE,
                       var.func = IQR, var.cutoff = varCut,
                       feature.exlude = "^AFFX")

# shows what's filtered away? 
filt_bcrneg$filter.log

# eSet is the column where the dataset we want to extract is
ALLfilt_bcrneg = filt_bcrneg$eset



