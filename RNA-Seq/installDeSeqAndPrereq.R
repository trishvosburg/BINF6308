# Script installs packages and prerequisites to run DESeq2

# Set timezone
Sys.setenv(TZ="US/Eastern")

# Install knitr to support R markdown
install.packages("knitr")

# Install RColorBrewer to provide palette for plot colors
install.packages("RColorBrewer", quiet=TRUE)

# Install devtools to support package installation from GitHub
install.packages("devtools")

# Install pheatmap to produce heatmaps
install.packages("pheatmap", quiet=TRUE)

# Set source to BioConductor
source("http://bioconductor.org/biocLite.R")
# Update all packages
biocLite(ask=FALSE)

# Install DESeq2
biocLite("DESeq2", quiet=TRUE, ask=FALSE, suppressUpdates=TRUE)
# Install limma for Venn diagrams
biocLite("limma", ask=FALSE, suppressUpdates=TRUE)
