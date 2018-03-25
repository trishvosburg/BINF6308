#!/bin/sh
nice -n 19 \
spades.py --pe1-1 Vibrio.R1.paired.fastq --pe1-2 Vibrio.R2.paired.fastq \
--memory 50 --threads 8 \
-o vibrioAssembly \
1>Vibrio.log 2>Vibrio.err &

