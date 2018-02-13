#!/bin/bash
#sortAll should output to bam directory
pairedTrimmedPath="Paired/"
leftSuffix=".R1.fastq"
rightSuffix=".R2.fastq"
outPath="bam/"
for leftInFile in $pairedTrimmedPath*$leftSuffix
do
	pathRemoved="${leftInFile/$pairedTrimmedPath/}"
	sampleName="${pathRemoved/$leftSuffix/}"
	echo samtools sort \
	Aip02.sam \
	#1>$outPath$sampleName \
	#$outPath.sorted.bam \
	#$sampleName.sort.log 2>$sampleName.sort.err 

done
