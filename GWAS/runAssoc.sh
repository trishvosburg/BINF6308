#!/bin/bash
# Run PLINK association analysis on epilepsy dataset
# Since these are canine samples, use -chr-set 38
# Adjust for multiple testing and write output with an epilepsy.txt prefix
plink --bfile famEpilepsy -chr-set 38 --assoc --adjust --out epilepsy.txt

