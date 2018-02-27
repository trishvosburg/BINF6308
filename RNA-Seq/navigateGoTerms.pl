#!/bin/perl
use warnings;
use strict;

# Purpose: to understand BioPerl OntologyIO module, which can read
#gene onotology OBO format

# Add write filehandle so tab-separated output is written to bioProcess.tsv

# Declare which module to be used
use Bio::OntologyIO;

# Instantiate Bio::OntologyIO with arguments format and file and assign to $parser
# Constructs whole hierarchy of GO terms
my $parser = Bio::OntologyIO->new(
	-format => "obo",
	-file   => "go-basic.obo"
);

# Create output file
my $outfile = 'bioProcess.tsv';
my $outFh;

# If you can't open the outfile, die
unless ( open( $outFh, ">", $outfile ) ) {
	die join( ' ', "Can't open outfile", $outfile, $! );
}

# Keeps returning top level terms until it reaches end of file
# Use the parser to find the biological process terms only
while ( my $ont = $parser->next_ontology() ) {

	# If the GO term is biological_process,
	if ( $ont->name() eq "biological_process" ) {

		# for each leaf, get the GO name and GO identifier
		foreach my $leaf ( $ont->get_leaf_terms ) {
			my $go_name = $leaf->name();
			my $go_id   = $leaf->identifier();

			# add to outfile
			print $outFh join( "\t", $go_id, $go_name ), "\n";
		}
	}

}
