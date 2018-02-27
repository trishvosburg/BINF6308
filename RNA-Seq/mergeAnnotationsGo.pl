#!/bin/perl
use warnings;
use strict;

# Purpose: merge the annotations from tsv file by putting data in 2D hash

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


# Put names and IDs from bioProcess into a hash
# Check: hash is working!
open( BP, "<", "bioProcess.tsv" ) or die $!;
my %BP;
my $go_name;
my $go_id;
while (<BP>) {
	chomp;
	my ($go_name, $go_id) = split ("\t", $_);
	$BP{$go_name}=$go_id;
}

# Open tsv file with filehandle, or die
open( SP, "<", "aipSwissProt.tsv" ) or die $!;

# Loop through tsv file and chomp to get rid of any excess characters
while (<SP>) {
	chomp;
	my ( $trinity, $swissProt, $description, $eValue ) =
	  split( "\t", $_ );
	if ( defined $spToGo{$swissProt} ) {
		foreach my $go ( sort keys %{ $spToGo{$swissProt} } ) {
			if (defined $BP{$go}) {
				foreach $go_name (sort keys %{$BP{$go}}) {
				print join( "\t", $trinity, $swissProt, $description, $go_name, $go_id ), "\n";
				}
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
