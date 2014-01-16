#!/usr/bin/env perl

## This script converts a plain text file (*.txt) of genotype information
## to the correct format of plink/haploview input (*.ped).
## It takes at least one argument: filename of the text file.
## The optional 2nd argument is the column separator other than "\t".

## The text file must have following first 6 columns:
## "Family ID", "Individual ID", "Paternal ID", "Maternal ID", "Sex"
## Unknown or missing genotype should be coded as "NA" or "na" or "0".

## The PED file is a white-space (space or tab) delimited file: first six columns
## are mandatory: 1) Family ID, 2) Individual ID, 3) Paternal ID, 4) Maternal ID,
## 5) Sex (1=male, 2=female, other=unknown),
## 6) Phenotype (quantitative trait or affection status)

## If "Phenotype" is affection status, it should be coded: -9=missing, 0=missing,
## 1=unaffected, 2=affected.

use warnings;
use strict;

my $file = $ARGV[0];       # the filename of the text file
my $output = $file;        # the filename of output ped file
$output =~ s/.txt$/.ped/;

my $separator = $ARGV[1];  # the optional separator
# If user hasn't designated the separator, take "\t" as default
$separator = "\t" unless $separator;  

open my $in, "< $file" or die "Cannot open input";
open my $out, "> $output" or die "Cannot create output";
my $line_count = 1;
while (<$in>) {
	next if /^#/;           # skip the # comment line
	chomp (my $line = $_);
	$line =~ s/\s+$//;      # remove any trailing space characters
	my ($famID, $indID, $pID, $mID, $sex, $pheno, @vars) = split /$separator/, $line;

	# check if any of these above six variables are undefined.
	if ( (not defined $famID) || (not defined $indID) || (not defined $pID)
		 || (not defined $mID) || (not defined $sex) || (not defined $pheno) ) {
		warn "Incorrect format of Line $line_count, check if it's due to wrong separator.\n";
		next;
	}

	print $out "$famID $indID $pID $mID $sex $pheno";
	foreach my $v (@vars) {
		if ($v ne 'NA' && $v ne 'na' && $v ne "0") {
			my ($a1, $a2) = split /\//, $v;
			print $out " $a1 $a2";
		}
		else { print $out " 0 0" }
	}
	print $out "\n";
	$line_count++;
}

close $in;
close $out;
