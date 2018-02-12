#!/bin/bash
#indexAll should output to bam directory
pairedTrimmedPath="/Paired"
leftSuffix=".R1.fastq"
rightSuffix=".R2.fastq"
outPath= "bam/"
for LeftInFile in $pairedTrimmedPath*$leftSuffix
do
	pathRemoved="${leftInFile/$pairedTrimmedPath/}"
	sampleName="${pathRemoved/$leftSuffix/}"
	echo nice -n19 \
	samtools index Aip02.sorted.bam \
	-o Aip02.index.bam \
	$outPath$sampleName$leftSuffix \
	$outPath$sampleName$rightSuffix \
	1>$sampleName.index.log 2>$sampleName.index.err 
done
