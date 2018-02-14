#!/bin/sh
pairedTrimmedPath="Paired/"
leftSuffix=".R1.fastq"
rightSuffix=".R2.fastq"
outPath="sam/"
for leftInFile in $pairedTrimmedPath*$leftSuffix
do
	pathRemoved="${leftInFile/$pairedTrimmedPath/}"
	sampleName="${pathRemoved/$leftSuffix/}"
	nice -n 19 gsnap \
	-A sam \
	-s AiptasiaGmapIIT.iit \
	-D . \
	-d AiptasiaGmapDb \
	#Aip02.R1.paired.fastq one input file
	#Aip02.R2.paired.fastq one input file
	$pairedTrimmedPath$sampleName$leftSuffix \
	$pairedTrimmedPath$sampleName$rightSuffix \
	1>$outPath$sampleName.aligned.sam \
	2>$sampleName.aligned.err 
done
