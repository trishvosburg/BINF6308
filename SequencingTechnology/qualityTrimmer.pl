#!/usr/bin/perl
use warnings;
use strict;
use diagnostics;

use Bio::Seq;
use Bio::SeqIO;

#need three Bio::SeqIO objects
#One for Sample.R1.fastq
my $seqio_obj_R1 = Bio::SeqIO->new(-file => 'Sample.R1.fastq',
							-format => 'fastq');		
# Create $left 
while (my $seq_obj_R1 = $seqio_obj_R1->next_seq){
	my $left=$seq_obj_R1;

#One for Sample.R2.fastq
my $seqio_obj_R2 = Bio::SeqIO->new(-file => 'Sample.R2.fastq',
							-format => 'fastq');
# Create $right
while (my $seq_obj_R2 = $seqio_obj_R2->next_seq){
	my $right=$seq_obj_R2;

#Bio:SeqIO for a fastq file returns a Bio::Seq:Quality, method:
#Returns the longest sequence that has quality values above the given threshold
my $leftTrimmed = $left->get_clear_range(20);
my $rightTrimmed = $right->get_clear_range(20);

#to copy description from one Bio::Seq to another:
$leftTrimmed->desc($left->desc());
$rightTrimmed->desc($right->desc());

#Create Bio::SeqIO for Interleaved.fastq (output)
my $seq_obj_out = Bio::Seq->new(

);
my $seqio_obj_out = Bio::SeqIO->new(
			-file => '>Interleaved.fastq',
			-format => 'fastq'
);

