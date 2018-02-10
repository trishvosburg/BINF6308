#!/usr/bin/sh
nice -n19 \
samtools index Aip02.sorted.bam \
-o Aip02.index.bam \
1>Aip02.index.log 2>Aip02.index.err &


