#!/bin/sh
# nice -n 19: tells server to give this lower priority than critical system functions
# java -jar command to run following java jar file
# PE indicates paired end reads
# Threads gives # of threads to run program
# -phred 33 indicates quality encoding method used for reads
nice -n 19 java -jar /usr/local/programs/Trimmomatic-0.36/trimmomatic-0.36.jar PE \
-threads 1 -phred33 \
# L and R reads:
/scratch/AiptasiaMiSeq/fastq/Aip02.R1.fastq \
/scratch/AiptasiaMiSeq/fastq/Aip02.R2.fastq \
# Output files:
Aip02.R1.paired.fastq \
Aip02.R1.unpaired.fastq \
Aip02.R2.paired.fastq \
Aip02.R2.unpaired.fastq \
# # of bases to remove from the beginning regardless of quality
HEADCROP:0 \
# Specifies file of adapter sequences and # mismatches allowed
ILLUMINACLIP:/usr/local/programs/Trimmomatic-0.36/adapters/TruSeq3-PE.fa:2:30:10 \
LEADING:20 TRAILING:20 SLIDINGWINDOW:4:30 MINLEN:36 \
1>Aip02.trim.log 2>Aip02.trim.err &



