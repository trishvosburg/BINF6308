# Load libraries
library("DESeq2")
library("RColorBrewer")
library("pheatmap")
 
# Load summarized DE results
load ("summarizedDeResults.RData")

# Plot dispersion
plotDispEsts(ddsAll)

# Get subsets of genes up-regulated or down-regulated for each favtor using p-value cutoff 0.05
logThreshold=0
alpha=0.05
upVibrio<-subset(dfBothAnnot, (padj.Vibrio < alpha) & (log2FoldChange.Vibrio > logThreshold))
downVibrio<-subset(dfBothAnnot, (padj.Vibrio < alpha) & (log2FoldChange.Vibrio < logThreshold))
upMenthol<-subset(dfBothAnnot, (padj.Menthol < alpha) & (log2FoldChange.Menthol > logThreshold))
downMenthol<-subset(dfBothAnnot, (padj.Menthol < alpha) & (log2FoldChange.Menthol < logThreshold))
listAll<-list(UpVibrio=row.names(upVibrio), DownVibrio=row.names(downVibrio), 
              UpMenthol=row.names(upMenthol), DownMenthol=row.names(downMenthol))

# Plot log2 fold change vs mean normalized counts
# Each point on the graph represents one gene, red indicates an adjusted p-value of 0.05 or lower
# Vibrio volcano plot
plotMA(resVibrio, ylim=c(-4,4), alpha=0.05)
# Menthol volcano plot
plotMA(resMenthol, ylim=c(-4,4), alpha=0.05)

# RLog transformation on counts to construct sample distance matrix
# Provides a measure of how similar overall gene expression patterns are for each sample
rldAll<-rlog(ddsAll, blind=FALSE)
sampleDists<-dist(t(assay(rldAll)))
sampleDistMatrix<-as.matrix(sampleDists)
rownames(sampleDistMatrix)<-paste(rldAll$Vibrio, rldAll$Menthol, sep="-")
colnames(sampleDistMatrix)<- NULL
colors<-colorRampPalette(rev(brewer.pal(9, "Blues")))(255)

# Cluster samples based on overall gene expression patterns
pheatmap(sampleDistMatrix, 
         clustering_distance_rows = sampleDists,
         clustering_distance_cols = sampleDists,
         col=colors)

# Perform principal component analyis (PCA) to determine percentage of variation explained by each variable
# 40% explained by Vibrio and 13% by Menthol exposure
plotPCA(rldAll, intgroup=c("Vibrio","Menthol"))

# Venn diagram showing overlap between Vibrio Up, Vibrio Down, Menthol Up, and Menthol Down
upVibrio$count<-rep(1,nrow(upVibrio))
downVibrio$count<-rep(1, nrow(downVibrio))
upMenthol$count<-rep(1, nrow(upMenthol))
downMenthol$count<-rep(1, nrow(downMenthol))
vibrioCount<-merge(upVibrio, downVibrio, by=0, all=TRUE, suffixes=c("Up", "Down"))
mentholCount<-merge(upMenthol, downMenthol, by=0, all=TRUE, suffixes=c("Up", "Down"))
rownames(vibrioCount)<-vibrioCount$Row.names
rownames(mentholCount)<-mentholCount$Row.names
vibrioCount<-subset(vibrioCount, select = -c(Row.names) )
mentholCount<-subset(mentholCount, select = -c(Row.names) )
bothCount<-merge(vibrioCount, mentholCount, by=0, all=TRUE, suffixes=c("Vibrio", "Menthol"))
rownames(bothCount)<-bothCount$Row.names
bothCount<-subset(bothCount, select = c(countUpVibrio, countDownVibrio, countUpMenthol, countDownMenthol) )

# Change NAs to zero
bothCount$countUpVibrio[is.na(bothCount$countUpVibrio)] <- 0
bothCount$countDownVibrio[is.na(bothCount$countDownVibrio)] <- 0
bothCount$countUpMenthol[is.na(bothCount$countUpMenthol)] <- 0
bothCount$countDownMenthol[is.na(bothCount$countDownMenthol)] <- 0

# Show Venn diagram
library("limma")
vennDiagram(vennCounts(bothCount), names=c("UpVibrio","DownVibrio","UpMenthol", "DownMenthol"), 
            circle.col=c("red","green","blue","yellow"))


