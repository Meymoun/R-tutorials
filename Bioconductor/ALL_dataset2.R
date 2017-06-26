## subset consisting of samples from BCR/ABL + tumors harboring the t9;22 translocation and
## ALL1/AF4 + tumors with t4;11 translocations

## select index of B cells in column BT
bcell = grep("^B", as.character(ALL$BT))

types = c("ALL1/AF4", "BCR/ABL")

## select molecular types that matches types
moltyp = which(ALL$mol.biol %in% types)

## find intersect, B cells and moltyp
ALL_af4bcr = ALL[, intersect(bcell, moltyp)]

## reduce factor levels
ALL_af4bcr$mol.biol = factor(ALL_af4bcr$mol.biol)
ALL_af4bcr$BT = factor(ALL_af4bcr$BT)

varCut = 0.5
filt_af4bcr = nsFilter(ALL_af4bcr, require.entrez = TRUE,
                       require.GOBP = TRUE, remove.dupEntrez = TRUE,
                       var.func = IQR, var.cutoff = varCut)

# eSet is the column where the dataset we want to extract is
ALLfilt_af4bcr = filt_af4bcr$eset