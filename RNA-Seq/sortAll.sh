#!/bin/sh
#sortAll should output to bam directory
samPath="sam/"
suffix=".sam"
outPath="bam/"
for leftInFile in $samPath*$suffix
do
	pathRemoved="${leftInFile/$samPath/}"
	sampleName="${pathRemoved/$suffix/}"
	echo samtools sort \
	$samPath$sampleName$suffix \
	#1>$outPath$sampleName.sorted.bam \
	#$sampleName.sort.log 2>$sampleName.sort.err 

done
