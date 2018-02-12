#!/bin/bash
#sortAll should output to bam directory
pairedTrimmedPath="/Paired/"
leftSuffix=".R1.fastq"
rightSuffix=".R2.fastq"
outPath="sam/"
for leftInFile in $pairedTrimmedPath*$leftSuffix
do
	pathRemoved="${leftInFile/$pairedTrimmedPath/}"
	sampleName="${pathRemoved/$leftSuffix/}"
	echo samtools sort \
	Aip02.sam \
	-o Aip02.sorted.bam
	$outPath$sampleName$leftSuffix \
	$outPath$sampleName$rightSuffix \
	#1>$sampleName.sort.log 2>$sampleName.sort.err 

done
