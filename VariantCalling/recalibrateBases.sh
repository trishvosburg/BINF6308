#!/bin/bash
# VCF file as input for known variants
# noDup bam files and filteredSnps.vcf as input
# Generate before/after plots
# Use 3 different subroutines? 
knownVariant='filteredSnps.vcf'
noDupPath='noDup/'
recalData='recal_data.table'
postRecalData='post_recal_data.table'
pdfOut='recalibration_plots.pdf'
bamOut='recal_reads.bam'
# stepone(){
#	for bamFile in noDup/*.bam
#	do
#		nice -n19 java -jar usr/local/programs/GenomeAnalysisTK-3.8-0/GenomeAnalysisTK.jar 
#		-T BaseRecalibrator -R genotype.vcf -I $noDupPath -L 20 -knownSites $knownVariant -o $recalData
#	done
#}
#stepOne 1>step1.log 2>step1.err &

baseCommand='nice -n19 java -jar usr/local/programs/GenomeAnalysisTK-3.8-0/GenomeAnalysisTK.jar'
step12='-T BaseRecalibrator -R genotype.vcf' 
step3='-T AnalyzeCovariates -R genotype.vcf'
step4='-T PrintReads -R genotype.vcf'
$baseCommand $step12 -I $noDupPath -L 20 -knownSites $knownVariant -o $recalData \
$baseCommand $step12 -I $noDupPath -L 20 -knownSites $knownVariant -BSQR $recalData -o $postRecalData \
$baseCommand $step3 -L 20 -before $recalData -after $postRecalData -plots $pdfOut
$baseCommand $step4 -I $noDupPath -L 20 -BSQR $recalData -o $bamOut \
1>recalibrate.log 2>recalibrate.err &
