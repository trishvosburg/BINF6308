# R script to select rows with Bonferroni-corrected p value of 0.05 or less
inFile<-read.table('epilepsy.txt.assoc.adjusted',header=TRUE)
#colnames(inFile)<-c("CHR","SNP","UNADJ","GC","BONF","HOLM","SIDAK_SS","SIDAK_SD","FDR_BH","FDR_BY")
#filter(inFile,BONF<=0.05)
filteredFile<-inFile[which(inFile[,5]<=0.05),]
write.table(filteredFile, file="filteredEpilepsyTable", col.names=FALSE,row.names=FALSE,quote=FALSE)
