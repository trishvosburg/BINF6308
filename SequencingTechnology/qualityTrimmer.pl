#!/usr/bin/perl
use warnings;
use strict;
use diagnostics;

use Bio::Seq;
use Bio::SeqIO;


my $R1 = Bio::SeqIO->new(
	-file   => 'Sample.R1.fastq',
	-format => 'fastq'
);
my $R2 = Bio::SeqIO->new(
	-file   => 'Sample.R2.fastq',
	-format => 'fastq'
);

my $Interleaved = Bio::SeqIO->new(
	-file   => '>Interleaved.fastq',
	-format => 'fastq'
);

while ( my $left = $R1->next_seq ) {
	my $right        = $R2->next_seq;
	my $leftTrimmed  = $left->get_clear_range(20);
	my $rightTrimmed = $right->get_clear_range(20);
	$leftTrimmed->desc( $left->desc() );
	$rightTrimmed->desc($left->desc() );
	$Interleaved->write_seq($leftTrimmed);
	$Interleaved->write_seq($rightTrimmed);
}



