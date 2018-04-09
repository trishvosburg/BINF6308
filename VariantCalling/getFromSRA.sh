#!/bin/bash
#Variable with file containing SRA accessions SRR_Acc_List.txt
filename="SRR_Acc_List.txt"
#Read file line by line and get the accession number
getAll(){
	while read -r line
	do
		#Get FASTQ
		fastq-dump $line --split-3 --gzip
	done < "$filename"
}
#Call function in background
getAll 1>get.log 2>get.err &
