#!/bin/bash
# samtools faidx indexes reference sequence (vShiloni) and creates a .fai file
samtools faidx vShiloni.fasta
# run picard tool CreateSequenceDictionary, which creates a sequence dictionary for vShiloni
# R is input reference file, O is output SAM file with sequence dictionary
java -jar /usr/local/bin/picard.jar CreateSequenceDictionary \
R=vShiloni.fasta O=vShiloni.dict \
# Write stdout log and err and call function in background
1>prepRef.log 2>prepRef.err &
