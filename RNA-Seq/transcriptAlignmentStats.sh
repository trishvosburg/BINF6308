#!/bin/bash
xprsPath=$1
xprsExt='.err'
outFile='transAlignStats.csv'
searchText='overall alignment rate'
echo 'Sample,TranAlignPct' > $xprsPath$outFile
grep "$searchText" $xprsPath*$xprsExt | while read -r line;
do
	line="${line/$searchText/}"
	line="${line/$xprsPath/}"
	line="${line/$xprsExt/}"
	line="${line/:/,}"
	line="${line/\%/}"
	echo $line >> $xprsPath$outFile
done
