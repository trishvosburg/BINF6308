#!/usr/bin/perl
use warnings;
use strict;
use diagnostics;
use feature qw(say);

use Bio::Seq;
use Bio::SeqIO;
use Getopt::Long;
use Pod::Usage;

#username: vosburg.p

my $fastaIn = '';
my $usage   = "\n$0 [options] \n
Options:
	-fastaIn 		Fasta input file
	-help 			Show this message
\n";

#check the flags
GetOptions(
	'fastaIn=s' => \$fastaIn,
	'help'      => sub { pod2usage($usage); },
) or pod2usage($usage);

unless ( -e $fastaIn ) {
	unless ( -e $fastaIn ) {
		print "Specify file for left reads\n";
	}
	die "Missing required options\n";
}

#hash to store kmers
my %kMerHash = ();

#hash to store occurrences of last 12 positions
my %last12Counts = ();

# Bio::SeqIO to read input fasta file:
my $seqio_obj = Bio::SeqIO->new(
	-file   => "$fastaIn",
	-format => 'fasta'
);

while ( my $seq_obj = $seqio_obj->next_seq ) {
	my $sequence = $seq_obj->seq;
	callSequence( \$sequence );
}

sub callSequence {
	my ($sequence) = @_;

	#declare scalars to characterize sliding window
	#Set the size of the sliding window
	my $windowSize = 21;

	#Set the step size
	my $stepSize  = 1;
	my $seqLength = length($$sequence);

#for loop to increment the starting position of the sliding window
#starts at position zero; doesn't move past end of file; advance the window by step size
	for (
		my $windowStart = 0 ;
		$windowStart <= ( $seqLength - $windowSize ) ;
		$windowStart += $stepSize
	  )
	{

	   #Get a 21-mer substring from sequenceRef (two $ to deference reference to
	   #sequence string) starting at the window start for length $windowStart
		my $crisprSeq = substr( $$sequence, $windowStart, $windowSize );

#if the 21-mer ends in GG, create a hash with key=last 12 of k-mer and value is 21-mer
#Regex where $1 is the crispr, and $2 contains the last 12 of crispr.
		if ( $crisprSeq =~ /([ATGC]{9}([ATGC]{10}GG))$/ ) {

			#Put the crispr in the hash with last 12 as key, full 21 as value.
			$kMerHash{$2} = $1;
			$last12Counts{$2}++;

		}

	}
}

#Initialize the CRISPR count to zero
my $crisprCount = 0;

my $seqio_obj_out = Bio::SeqIO->new(
	-file   => '>$crisprs1.fasta',
	-format => 'fasta'
);

#Loop through the hash of last 12 counts
for my $last12Seq ( sort ( keys %last12Counts ) ) {

	#Check if count == 1 for this sequence
	if ( $last12Counts{$last12Seq} == 1 ) {

		#The last 12 seq of this CRISPR is unique in the genome.
		#Increment the CRISPR count.
		$crisprCount++;

		my $seq_obj_out = Bio::Seq->new(
			-seq        => "$kMerHash{$last12Seq}",
			-display_id => "crispr_$crisprCount",
			-desc       => "Crispr Count"
		);
		$seqio_obj_out->write_seq($seq_obj_out);
	}
}

