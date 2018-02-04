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


my $R1 = Bio::SeqIO->new(
	-file   => "$left",
	-format => 'fastq'
);
my $R2 = Bio::SeqIO->new(
	-file   => "$right",
	-format => 'fastq'
);

my $Interleaved = Bio::SeqIO->new(
	-file   => ">$interleaved",
	-format => 'fastq'
);

while ( my $leftseq = $R1->next_seq ) {
	my $rightseq        = $R2->next_seq;
	my $leftTrimmed  = $leftseq->get_clear_range($qual);
	my $rightTrimmed = $rightseq->get_clear_range($qual);
	$leftTrimmed->desc( $leftseq->desc() );
	$rightTrimmed->desc($rightseq->desc() );
	$Interleaved->write_seq($leftTrimmed);
	$Interleaved->write_seq($rightTrimmed);
}



