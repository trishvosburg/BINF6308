#!/bin/bash
samDir="sam/"
samSuffix=".sam"
echo -e "Sample,Total,Aligned,Concordant" > alignmentStats.csv
for samFile in $samDir*$samSuffix
do
	total="$(samtools view -c $samFile)"
	mapped="$(samtools view -F4 -c $samFile)"
	paired="$(samtools view -f2 -c $samFile)"
	sample="${samFile/$samDir/}"
	sample="${sample/$samSuffix/}"
	echo -e "$sample,$total,$mapped,$paired" >> alignmentStats.csv
done
