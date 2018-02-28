#!/bin/perl
use warnings;
use strict;

# Purpose: if the GO id from navigateGoTerms is in the aip file, add all the output
# (trinityID, SwissProtID, SwissProt description, GO terms, and GO descriptions)
# to trinitySPGo.tsv

# Add read filehandle to so it reads bioProcess.tsv from navigateGoTerms.pl
# Puts IDs and names as hash -> ID as key, name as value
# Modify output so it prints trinityID, SwissProtID, SwissProt description, GO Terms, and GO descriptions
# for biological process terms associated with the trinity IDs
# write to trinitySPGo.tsv

# Open tsv file from Blast2Go with filehandle, or die
open( SP_TO_GO, "<", "spToGo.tsv" ) or die $!;

# Declare hash
my %spToGo;

# Loop through tsv file and chomp to get rid of any excess characters
while (<SP_TO_GO>) {
	chomp;

# Split each line in $_ from the tsv file with tabs, assign to $swissprot and $go
	my ( $swissProt, $go ) = split( "\t", $_ );

	# Store in hash as keys. Increment counter as value
	$spToGo{$swissProt}{$go}++;
}

# Open outfile or die
my $outfile = 'trinitySPGo.tsv';
my $outFh;
unless ( open( $outFh, ">", $outfile ) ) {
	die join( ' ', "Can't open outfile", $outfile, $! );
}

# open bioProcess or die
open( BP, "<", "bioProcess.tsv" ) or die $!;

# Declare globals
my %BP;
my $go_name;
my $go_id;

# Put names and IDs from bioProcess into a hash, chomp
while (<BP>) {
	chomp;

	# Split on tabs, go_id as key and go_name as value
	my ( $go_id, $go_name ) = split( "\t", $_ );
	$BP{$go_id} = $go_name;
}

# Open tsv file with filehandle, or die
open( SP, "<", "aipSwissProt.tsv" ) or die $!;

# Loop through tsv file and chomp to get rid of any excess characters
while (<SP>) {
	chomp;

	# split aipSwissProt on tabs and declare variables from columns
	my ( $trinity, $swissProt, $description, $eValue ) =
	  split( "\t", $_ );

	# if the swissProtID exists in the spToGo hash,
	if ( defined $spToGo{$swissProt} ) {

# for each go_id in the bioProcess hash, sort from the swissProtID that exists in the sp hash
		foreach my $go_id ( sort keys %{ $spToGo{$swissProt} } ) {

			# if the go_id is defined in the bioProcess hash,
			if ( defined $BP{$go_id} ) {

				# declare go_name
				my $go_name = $BP{$go_id};

				# add everything to the outfile
				print $outFh join( "\t",
					$trinity, $swissProt, $description, $go_id, $go_name ),
				  "\n";
			}
		}
	}
}

=cut
# Test hash with foreach loop
# Loop over $swissProt (first key) and sort to make sure everything is in order
foreach my $swissProt ( sort keys %spToGo ) {

	# Loop over $go (second key) and sort to do the same, 
	# Must de-reference hash references to use them with keys!
	foreach my $go ( sort keys %{ $spToGo{$swissProt} } ) {
		    # Print the keys separated by tabs
		print join( "\t", $swissProt, $go ), "\n";
	}
}
