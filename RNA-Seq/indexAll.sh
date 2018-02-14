#!/bin/sh
bamPath='bam/'
suffix='.aligned.sorted.bam'
outPath="bam/"
for leftInFile in $bamPath*$suffix
do
	pathRemoved="${leftInFile/$bamPath/}"
	sampleName="${pathRemoved/$suffix/}"
	samtools index \
	$bamPath$sampleName$suffix \
	1>$sampleName.index.log 2>$sampleName.index.err 
done
