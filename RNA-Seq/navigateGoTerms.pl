#!/bin/perl
use warnings;
use strict;

# Purpose: to understand BioPerl OntologyIO module, which can read 
	#gene onotology OBO format

# Declare which module to be used
use Bio::OntologyIO;

# Instantiate Bio::OntologyIO with arguments format and file and assign to $parser
# Constructs whole hierarchy of GO terms
my $parser = Bio::OntologyIO->new(
	-format => "obo",
	-file => "go-basic.obo"
);

# Keeps returning top level terms until it reaches end of file
while (my $ont = $parser->next_ontology() ) {
	print "read ontology ", $ont->name(), "with ",
		scalar ($ont->get_root_terms), " root terms, and ",
		scalar ($ont->get_leaf_names), " leaf terms \n";
}