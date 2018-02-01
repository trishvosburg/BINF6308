#!/usr/bin/perl
use warnings;
use strict;
use diagnostics;

use Bio::Seq;
use Bio::SeqIO;
use Getopt::Long;
use Pod::Usage;

#GLOBALS
my $left        = '';
my $right       = '';
my $interleaved = '';
my $qual        = 0;
my $usage       = "\n$0 [options] \n
Options:
	-left 			Left reads
	-right 			Right reads
	-qual 			Quality score minimum
	-interleaved 	Filename for interleaved output
	-help 			Show this message
\n";

#check the flags
GetOptions(
	'left=s'        => \$left,
	'right=s'       => \$right,
	'interleaved=s' => \$interleaved,
	'qual=i'        => \$qual,
	'help'          => sub { pod2usage($usage); },
) or pod2usage($usage);

unless ( -e $left and -e $right and $qual and $interleaved) {
	unless (-e $left) {
		print "Specify file for left reads\n";
	}
	
	unless (-e $right) {
		print "Specify file for right reads\n";
	}
	
	unless ($interleaved) {
		print "Specify file for interleaved output\n";
	}
	
	unless ($qual) {
		print "Specify quality score cutoff\n";
	}
	die "Missing required options\n";
}

	my $leftTrimmed  = $left->get_clear_range(20);
	my $rightTrimmed = $right->get_clear_range(20);
	$leftTrimmed->desc( $left->desc() );
	$rightTrimmed->desc($left->desc() );
	$interleaved->write_seq($leftTrimmed);
	$interleaved->write_seq($rightTrimmed);
	
=cut
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



