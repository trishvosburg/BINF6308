#!/bin/bash
# Make vcf directory
# For all the bam files in the noDup folder,
# Make paths for outfiles
# Use genome analysis toolkit's Haplotype Caller as the variant discovery tool
# emitRefConfidence dictates that the reference model is emitted with GVCF format
# Reference is vShiloni.fasta, -I is the bam input
# genotyping_mode DISCOVERY specifies how to determine the alternate alleles for genotyping
# variant_index_type specifies the type of index creator to use for VCF indices (LINEAR)
# variant_index_parameter dictates the parameter # to pass on to the VCF IndexCreator
# stand_call_conf is the minimum phred-scaled confidence threshold at which variants should be called (30)
# nct is the multi-threaded mode (16 in this case), the # of data threds to allocate to this analysis
mkdir -p vcf
findVariants(){
for bam in noDup/*.bam
do
vcfOut="${bam/noDup/vcf}"
vcfOut="${vcfOut/bam/vcf}"
nice -n19 java -jar /usr/local/programs/GenomeAnalysisTK-3.8-0/GenomeAnalysisTK.jar \
-T HaplotypeCaller --emitRefConfidence GVCF -R vShiloni.fasta -I $bam --genotyping_mode DISCOVERY \
-variant_index_type LINEAR -variant_index_parameter 128000 \
-stand_call_conf 30 -nct 16 -o $vcfOut
done
}
findVariants 1>findVariants.log 2>findVariants.err &
