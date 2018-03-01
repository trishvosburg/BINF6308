#!/bin/bash
echo "PairsOut,Sample" > pairsOut.csv
echo "PairsIn,Sample" > pairsIn.csv
outPath="Paired/"
inPath="/scratch/AiptasiaMiSeq/fastq/"
leftSuffix=".R1.fastq"
grep "\@M0" $outPath*$leftSuffix|\
cut -d':' -f1|\
sort|\
uniq -c|\
sed -e "s|^ *||;s| |,|;s|$outPath||;s|$leftSuffix||" >> pairsOut.csv
grep "\@M0" $inPath*$leftSuffix|\
cut -d':' -f1|\
sort|\
uniq -c|\
sed -e "s|^ *||;s| |,|;s|$inPath||;s|$leftSuffix||" >> pairsIn.csv
