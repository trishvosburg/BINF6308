#!/bin/bash
fastqPath="/scratch/AiptasiaMiSeq/fastq/"
leftSuffix=".R1.fastq"
for leftInFile in $fastqPath*$leftSuffix
do
	echo $leftInFile
	pathRemoved="${leftInFile/$fastqPath/}"
	echo $pathRemoved
	suffixRemoved="${pathRemoved/$leftSuffix/}"
	echo $suffixRemoved
done

