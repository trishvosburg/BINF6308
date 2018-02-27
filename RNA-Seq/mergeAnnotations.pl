#!/bin/perl
use warnings;
use strict;

# Purpose: match transcript IDs from assembly to SwissProt hits in blastp output file

use Bio::Seq;
use Bio::SeqIO;
use Bio::SearchIO;
use Bio::Search::Result::GenericResult;
use Data::Dumper;

# Initialize Bio::SearchIO to variable
my $blastXml = Bio::SearchIO->new(
	-file   => 'Trinity-GG.blastp.xml',
	-format => 'blastxml'
);

# Open outfile
my $outfile = 'aipSwissProt.tsv';
my $outFh;
unless ( open( $outFh, ">", $outfile ) ) {
	die join( ' ', "Can't open outfile", $outfile, $! );
}

# Add first line to outfile separated by tabs
print $outFh join( "\t", "Trinity", "SwissProt", "SwissProtDesc", "eValue" ),
  "\n";

# Will keep getting search results until it reaches end of XML file
# next_result returns an object
while ( my $result = $blastXml->next_result() ) {
	my $queryDesc = $result->query_description;

# get most specific hit (best for annotation), but only the part we need (isoform ID)
# if the query description matches any of the characters between the "::", capture as $1
# 1 opening parenthesis, so stored as $1. "?" means match with shortest distance.
	if ( $queryDesc =~ /::(.*?)::/ ) {
		my $queryDescShort = $1;
		my $hit            = $result->next_hit;
		if ($hit) {

			#print $queryDescShort, "\t";
			#print $hit->accession, "\t";
			my $hitAcc = ( $hit->accession );

		# trim down subject descriptions to what's after Full= and before [ or ;
			my $subjectDescription = $hit->description;
			if ( $subjectDescription =~ /Full=(.*?);/ ) {
				$subjectDescription = $1;
			}
			if ( $subjectDescription =~ /Full=(.*?)\[/ ) {
				$subjectDescription = $1;
			}

			#print $subjectDescription, "\t";
			#print $hit->significance, "\n";
			my $hitSig = ( $hit->significance );

			# Write output to output filehandle
			print $outFh join( "\t",
				$queryDescShort, $hitAcc, $subjectDescription, $hitSig ),
			  "\n";
		}
	}
}

