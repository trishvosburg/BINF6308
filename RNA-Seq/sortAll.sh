#!/bin/sh
#sortAll should output to bam directory
samPath="sam/"
suffix=".sam"
outPath="bam/"
for leftInFile in $samPath*$suffix
do
	pathRemoved="${leftInFile/$samPath/}"
	sampleName="${pathRemoved/$suffix/}"
	samtools sort \
	$samPath$sampleName$suffix \
	-o $outPath$sampleName.sorted.bam \
	1>$sampleName.sort.log 2>$sampleName.sort.err 

done
