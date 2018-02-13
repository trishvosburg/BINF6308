#!/bin/bash
pairedTrimmedPath="Paired/"
leftSuffix=".R1.fastq"
rightSuffix=".R2.fastq"
outPath="sam/"
for leftInFile in $pairedTrimmedPath*$leftSuffix
do
	pathRemoved="${leftInFile/$pairedTrimmedPath/}"
	sampleName="${pathRemoved/$leftSuffix/}"
	echo nice -n 19 gsnap \
	-A sam \
	-s AiptasiaGmapIIT.iit \
	-D . \
	-d AiptasiaGmapdb \
	#1> 
	$outPath$sampleName$leftSuffix \
	$outPath$sampleName$rightSuffix \
	$sampleName.aligned.sam
	# 2>$sampleName.aligned.err 
done
