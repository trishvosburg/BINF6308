#!/bin/sh
nice -n 19 java -jar /usr/local/programs/Trimmomatic-0.36/trimmomatic-0.36.jar PE \
-threads 1 -phred33 \
SRR6728088_1.fastq \
SRR6728088_2.fastq \
Vibrio.R1.paired.fastq \
Vibrio.R1.unpaired.fastq \
Vibrio.R2.paired.fastq \
Vibrio.R2.unpaired.fastq \
HEADCROP:0 \
ILLUMINACLIP:/usr/local/programs/Trimmomatic-0.36/adapters/NexteraPE-PE.fa:2:30:10 \
LEADING:20 TRAILING:20 SLIDINGWINDOW:4:30 MINLEN:36 \
1>Vibrio.trim.log 2>Vibrio.trim.err &



