#!/bin/sh
#indexAll should output to bam directory
bamPath="bam/"
suffix=".sorted.bam"
outPath="bam/"
for LeftInFile in $bamPath*$suffix
do
	pathRemoved="${leftInFile/$bamPath/}"
	sampleName="${pathRemoved/$suffix/}"
	samtools index \
	$bamPath$sampleName$suffix \
	-o $outPath$sampleName.index.bai \
	1>$sampleName.index.log 2>$sampleName.index.err 
done
