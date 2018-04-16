#!/bin/bash
# VCF file as input for known variants
# noDup bam files and filteredSnps.vcf as input
# Generate before/after plots
# Do I need to use a subroutine? 
knownVariant='filteredSnps.vcf'
#noDupPath='noDup/'
recalData='recal_data.table'
postRecalData='post_recal_data.table'
pdfOut='recalibration_plots.pdf'
bamOut='recal_reads.bam'
baseCommand='nice -n19 java -jar /usr/local/programs/GenomeAnalysisTK-3.8-0/GenomeAnalysisTK.jar'
#step12='-T BaseRecalibrator -R genotype.vcf' 
#step3='-T AnalyzeCovariates -R genotype.vcf'
#step4='-T PrintReads -R genotype.vcf'
#$baseCommand $step12 -I $noDupPath -knownSites $knownVariant -o $recalData
#$baseCommand $step12 -I $noDupPath -knownSites $knownVariant -BSQR $recalData -o $postRecalData
#$baseCommand $step3 -before $recalData -after $postRecalData -plots $pdfOut
#$baseCommand $step4 -I $noDupPath -BSQR $recalData -o $bamOut
#1>recalibrate.log 2>recalibrate.err &

step1Sub(){
for bamFile in noDup/*.bam
	do
		stepOne='-T BaseRecalibrator -R genotype.vcf'
		$baseCommand $stepOne -I $bamFile -knownSites $knownVariant -o $recalData
	done
}	
step2Sub(){
for bamFile in noDup/*.bam
	do
		stepTwo='-T BaseRecalibrator -R genotype.vcf'
		$baseCommand $stepTwo -I $bamFile -knownSites $knownVariant -BSQR $recalData -o $postRecalData
	done
}		
step3Sub(){
	step3='-T AnalyzeCovariances -R genotype.vcf'
	$baseCommand $step3 -before $recalData -after $postRecalData -plots $pdfOut
}
step4Sub(){
for bamFile in noDup/*.bam
	do		
		step4='-T PrintReads -R genotype.vcf'
		$baseCommand $step4 -I $bamFile -BSQR $recalData -o $bamOut
	done
}
step1Sub 1>step1.log 2>step1.err &
