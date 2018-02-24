#!/usr/bin/perl
use warnings;
use strict;

# Purpose: to get a sample of a large FASTA file (transcriptome data)
	# to understand how Blast2Go works without running something for
	# several days. Can test code on small sample -> work out any bugs 
	# before running on large file

use Bio::Seq;
use Bio::SeqIO;
use Getopt::Long;
use Pod::Usage;

# Declare globals
my $fastaIn    = 'Trinity-GG.fasta.transdecoder.pep';
my $fastaOut   = 'subset.pep';
my $sampleRate = 1000;
my $usage      = "\n$0 [options] \n
Options:
	-fastaIn    FASTA input file [$fastaIn]
	-fastaOut   FASTA Output Prefix [$fastaOut]
	-sampleRate Number of output files [$sampleRate]
	-help       Show this message
\n";

# Call subroutine to generate input from user
# If they type help, call pod2usage to show help message written above
#fastaIn and fastaOut get =s because they're strings, sampleRate gets =i because it's a number
GetOptions(
	'fastaIN=s'    => \$fastaIn,
	'fastaOut=s'   => \$fastaOut,
	'sampleRate=i' => \$sampleRate,
	help           => sub { pod2usage($usage); },
) or pod2usage($usage);

# Does the input file exist? If not, die
if ( not( -e $fastaIn ) ) {
	die "The input file $fastaIn specified by -fastaIn does not exist\n";
}

# Bio::Seq IO to read input file
my $input = Bio::SeqIO->new(
	-file   => $fastaIn,
	-format => 'fasta'
);

# Bio::SeqIO to write output file
my $output = Bio::SeqIO->new(
	-file   => ">$fastaOut",
	-format => 'fasta'
);
# Declare counter to count # of sequences
my $seqCount = 0;
# Loop through sequences with next_seq
# Add to counter for each sequence
# % operator to get remainder after dividing sequence count by sample rate
# if remainder equals zero, it's a multiple of the sample rate, so write it to the output file
while ( my $seq = $input->next_seq ) {
	$seqCount++;
	if ( ( $seqCount % $sampleRate ) == 0 ) {
		$output->write_seq($seq);
	}
}
