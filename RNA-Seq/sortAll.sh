#!/bin/sh
#sortAll should output to bam directory

#!/bin/sh
samtools sort \
Aip02.sam \
-o Aip02.sorted.bam \
1>Aip02.sort.log 2>Aip02.sort.err &
#!/bin/bash
fastqPath="/scratch/AiptasiaMiSeq/fastq/"
leftSuffix=".R1.fastq"
rightSuffix=".R2.fastq"
pairedOutPath="Paired/"
unpairedOutPath="Unpaired/"
for leftInFile in $fastqPath*$leftSuffix
do
	pathRemoved="${leftInFile/$fastqPath/}"
	sampleName="${pathRemoved/$leftSuffix/}"
	nice -n 19 java -jar /usr/local/programs/Trimmomatic-0.36/trimmomatic-0.36.jar PE \
	-threads 1 -phred33 \
	$fastqPath$sampleName$leftSuffix \
	$fastqPath$sampleName$rightSuffix \
	$pairedOutPath$sampleName$leftSuffix \
	$unpairedOutPath$sampleName$leftSuffix \
	$pairedOutPath$sampleName$rightSuffix \
	$unpairedOutPath$sampleName$rightSuffix \
	HEADCROP:0 \
	ILLUMINACLIP:/usr/local/programs/Trimmomatic-0.36/adapters/TruSeq3-PE.fa:2:30:10 \
	LEADING:20 TRAILING:20 SLIDINGWINDOW:4:30 MINLEN:36 \
	1>$sampleName.trim.log 2>$sampleName.trim.err 

done

