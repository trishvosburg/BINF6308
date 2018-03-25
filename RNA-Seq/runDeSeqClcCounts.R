# Load DESeq2 Libary
library("DESeq2")

# Load counts, column data, annotations
load("clcCountsBlast2GoAnnotations.RData")

# New DESeq2 dataset from matrix
# rawCounts contains un-normalized counst by gene for each of the 24 samples
# 4 treatment groups and six replicates per group
# Design specifies conditions we want to evaluate
ddsAll<-DESeqDataSetFromMatrix(countData = rawCounts, colData=colData, design =~ Vibrio + Menthol)
# Relevel sets control treatment
ddsAll$Menthol<-relevel(ddsAll$Menthol, ref="NoMenthol")
ddsAll$Vibrio<-relevel(ddsAll$Vibrio, ref="NoVibrio")

# Remove low counts
# Only keep rows where sum of read counts is greater than 10
# Prefiltering speeds processing and reduces memory use
nrow(counts(ddsAll))
ddsAll<-ddsAll[rowSums(counts(ddsAll)) > 10, ]
nrow(counts(ddsAll))

# Can run differential expression analysis using DESeq
ddsAll<-DESeq(ddsAll)

# Use function resultsNames to get names
resultsNames(ddsAll)

# Get results as data frames with adjusted p-value less than 0.05 and save as data frame
resVibrio<-results(ddsAll, alpha=0.05, name="Vibrio_Vibrio_vs_NoVibrio")
resMenthol<-results(ddsAll, alpha=0.05, name="Menthol_Menthol_vs_NoMenthol")
dfVibrio<-as.data.frame(resVibrio)
dfMenthol<-as.data.frame(resMenthol)

# Check data frames
head(dfVibrio)
head(dfMenthol)

# Select the columns we need from results
# We need log3 fold change and adjusted p-value from both
dfVibrio<-subset(subset(dfVibrio, select=c(log2FoldChange, padj)))
dfMenthol<-subset(subset(dfMenthol, select=c(log2FoldChange, padj)))
head(dfVibrio)
head(dfMenthol)

# Merge on rownames so we can determine which genes are differentially expressed in the same or opposite directons
# by=0 indicates merge on rowname, suffixes indicate how to differentiate columns with the same name
dfBoth<-merge(dfMenthol, dfVibrio, by=0, suffixes=c(".Menthol", ".Vibrio"))
rownames(dfBoth)<-dfBoth$Row.names
head(dfBoth)

# Remove redundant Row.names column
dfBoth<-subset(dfBoth, select = -c(Row.names))
head(dfBoth)

# Merge gene-level descriptions
dfBothAnnot<-merge(dfBoth, geneDesc, by=0, all.x=TRUE)
rownames(dfBothAnnot)<-dfBothAnnot$Row.names
dfBothAnnot<-subset(dfBothAnnot, select = -c(Row.names))
head(dfBothAnnot, n=10)

# Save summarized scripts
save(ddsAll, dfBothAnnot, resVibrio, resMenthol, file="summarizedDeResults.RData")
