#!/usr/bin/perl
use warnings;
use strict;
use diagnostics;

use Bio::Seq;
use Bio::SeqIO;

#Need three Bio::SeqIO objects
#One for each fastq
my $seqio_obj_L = Bio::SeqIO->new(
	-file   => 'Sample.R1.fastq',
	-format => 'fastq'
);
my $seqio_obj_R = Bio::SeqIO->new(
	-file   => 'Sample.R2.fastq',
	-format => 'fastq'
);

#Create Bio::SeqIO for Interleaved.fastq (output)

my $seqio_obj_out = Bio::SeqIO->new(
	-file   => '>Interleaved.fastq',
	-format => 'fastq'
);

#Create $left, inside while loop create right read SeqIO
while ( my $seq_obj_L = $seqio_obj_L->next_seq ) {
	my $seq_obj_R = $seqio_obj_R->next_seq;
	my $left      = $seq_obj_L;
	my $right     = $seq_obj_R;

 #Bio:SeqIO for a fastq file returns a Bio::Seq:Quality, method:
 #Returns the longest sequence that has quality values above the given threshold
	my $leftTrimmed  = $left->get_clear_range(20);
	my $rightTrimmed = $right->get_clear_range(20);

	#to copy description from one Bio::Seq to another:
	$leftTrimmed->desc( $left->desc() );
	$rightTrimmed->desc( $right->desc() );

	#Write output file
	my $seq_obj_out = Bio::Seq->new(
		-seq        => "",
		-display_id => "",
		-desc       => "",
	);

}

