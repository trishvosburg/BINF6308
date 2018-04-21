#!/bin/bash
# VCF file as input for known variants
# noDup bam files and filteredSnps.vcf as input
# Generate before/after plots 
# -I noDup/bam (each one) is now $bamParam
knownVariant='filteredSnps.vcf'
recalData='recal_data.table'
postRecalData='post_recal_data.table'
pdfOut='recalibration_plots.pdf'
bamOut='recal_reads.bam'
bam="$(ls -q noDup/*.bam)"
inPath='noDup/'
replacement='-I noDup/'
bamParam="${bam//$inPath/$replacement}"
baseRecal(){
	baseCommand='nice -n19 java -jar /usr/local/programs/GenomeAnalysisTK-3.8-0/GenomeAnalysisTK.jar'
	step12='-T BaseRecalibrator -R vShiloni.fasta' 
	step3='-T AnalyzeCovariates -R vShiloni.fasta'
	step4='-T PrintReads -R vShiloni.fasta'
	#$baseCommand $step12 $bamParam -knownSites $knownVariant -o $recalData
	#$baseCommand $step12 $bamParam -knownSites $knownVariant -BQSR $recalData -o $postRecalData
	#$baseCommand $step3 -before $recalData -after $postRecalData -plots $pdfOut
	$baseCommand $step4 $bamParam -BQSR $recalData -o $bamOut
}
baseRecal 1>recalibrate.log 2>recalibrate.err &

