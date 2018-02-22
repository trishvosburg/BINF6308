#!/bin/perl
use warnings;
use strict;

use Bio::Seq;
use Bio::SeqIO;
use Bio::SearchIO;
use Bio::Search::Result::GenericResult;
use Data::Dumper;

# initialize Bio::SearchIO to variable
my $blastXml = Bio::SearchIO->new(
	-file   => 'Trinity-GG.blastp.xml',
	-format => 'blastxml'
);
my $output = Bio::SeqIO->new(
	-file => '>aipSwissProt.tsv',
	-format => 'tab',
);
print "Trinity Swissprot SwissProtDesc eValue";


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
			my $hitAcc = ($hit->accession);
			# trim down subject descriptions to what's after Full= and before [ or ;
			my $subjectDescription = $hit->description;
			if ( $subjectDescription =~ /Full=(.*?);/ ) {
				$subjectDescription = $1;
			}
			if ($subjectDescription =~ /Full=(.*?)\[/ ) {
				  $subjectDescription = $1;
			}
			#print $subjectDescription, "\t";
			#print $hit->significance, "\n";
			my $hitSig = ($hit->significance);
			$output->write_seq($queryDescShort);
			$output->write_seq($hitAcc);
			$output->write_seq($subjectDescription);
			$output->write_seq($hitSig);
			
		}
	}
}

