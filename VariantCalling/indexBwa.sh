#!/bin/bash
# p indicates prefix of output database, prefix in this case is vShiloni
# a is the alogrithm for constructing BWT index
# "is" used for constructing suffix array, moderately fast
# default algorithm due to simplicity
nice -n19 bwa index -p vShiloni -a is vShiloni.fasta \
# Write stdout log and err files
1>bwaIndex.log 2>bwaIndex.err & 
