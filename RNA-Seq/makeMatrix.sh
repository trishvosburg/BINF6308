#!/bin/bash
xprsDir=$1
results="$(find $xprsDir -iname results.xprs)"
results="$(echo $results)"
nice -n19 /usr/local/programs/trinityrnaseq-2.2.0/\
util/abundance_estimates_to_matrix.pl --est_method eXpress \
--cross_sample_norm TMM \
--out_prefix $xprsDir \
--name_sample_by_basedir $results \
1>$xprs.log 2>$xprs.err &
