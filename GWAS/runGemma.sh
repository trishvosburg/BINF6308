#!/bin/bash
# Use gemma to:
# Calculate a standard relatedness matrix
# Perform Eigen-Decomposition of the relatedness matrix
# Perform association tests with Univariate Linear Mixed Models and Wald test
# Basic usage: calculate an estimated relatedness matrix with either PLINK binary ped format or BIMBAM format
# ./gemma -bfile [prefix] -gk [num] -o [prefix]
# -bfile -> prefix of dataset
# -gk 2 -> standard relatedness matrix
# -eigen -> eigen-decomposition
# -lmm 1 -> Wald test 
###
relatedness='famEpilepsyRelatedness'
eigen='famEpilepsyEigen'
wald='famEpilepsyWald'
baseCommand='gemma -bfile famEpilepsy'
$baseCommand -gk 2 -o $relatedness 
$baseCommand -k $relatedness -eigen -o $eigen
$baseCommand -lm 2 $wald
1>gemma.log 2>gemma.err &
