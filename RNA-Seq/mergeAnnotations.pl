#!/bin/perl
use Bio::SearchIO;

# initialize Bio::SearchIO to variable
my $blastXml = Bio::SearchIO->new(
	-file => 'Trinity-GG.blastp.xml',
	-format => 'blastxml'
);
# Will keep getting search results until it reaches end of XML file
while (my $result = $blastXml->next_result() ) {
	print $result, "\n";
}
# next_result returns an object
