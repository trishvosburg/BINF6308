# Variable with the path containing eXpress files
xprsPath<-"xprs_gg"
# Variable with eXpress results filename
xprsFile<-"results.xprs"
# Vector of eXpress results files
files<-list.files(path=xprsPath, pattern=xprsFile, full.names=T, recursive=TRUE)
# Check contents
files

# Read first file separated by tabs
firstFile<-read.delim(files[1], sep="\t")
# Display top of first table
head(firstFile)
# Initialize variable with null to store merged table
merged<-NULL
# Iterate over vector of eXpress results files
for (file in files) {
  # Read results for the sample as tab-delimited
  nextSample<-read.delim(file, sep="\t")
  # Select the two columns we need
  nextSample<-nextSample[,c("target_id","uniq_counts")]
  # Rename uniq_counts column so it identifies the sample
  colnames(nextSample)<-c("transcript",file)
  # If this is the first results file (merged = null), copy to merged
  if (is.null(merged)){
    merged<-nextSample
  # Else merge the next sample
  } else {
    merged<-merge(merged, nextSample)
  }
}
head(merged)
# Get column names
uglyColumns=colnames(merged)
# Replace the path with an empty string
lessUglyColumns=gsub(paste0(xprsPath, '/'),"",uglyColumns)
lessUglyColumns
# Replace /results.xprs with an empty string
prettyColumns=gsub(paste0('/',xprsFile),"",lessUglyColumns)
prettyColumns
colnames(merged)<-prettyColumns
write.csv(merged, file="mergedCountTable.csv", row.names = FALSE)
