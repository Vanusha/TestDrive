#!/usr/bin/env perl

## Last revision at 2013.12.31

## This script converts NCBI chromosome FASTA sequence's annotation to
## NextGENe annotation format, and concatenate them into a final fasta file.

## This script has to be run in the same directory of v37 genome and all the
## gzipped file must be ungzipped!

## Applicable range: chr1~22, chrX, chrY, chrMT

use warnings;
use strict;

# create a working directory of genome
mkdir "working_genome" or die "Cannot create directory:$!\n";
my $destination = "working_genome/hg19_NCBI.fasta";

# generate an appropriate order of chromosomes
my %fileNo; my $n = 1;
foreach (1..22, "MT", "X", "Y") {
	$fileNo{$_} = $n; $n++;
}

# read the files, and sort them by the order
my @files = <hs_ref*.fa>;
my @sorted_files = sort { $fileNo{$a} <=> $fileNo{$b} } @files;

# read the content of files, and write them to file fasta file
open my $out, "> $destination" or die "Cannot write to $destination\n";
foreach my $file (@sorted_files) {
	my $chr; $chr = $1 if ($file =~ /chr([\w\d]+)\.fa$/);
  
	open my $in, "< $file" or die "Cannot read $file\n";

	while (<$in>) {
		if (/^>/) {
			print $out ">$chr\n";
		}
		else { print $out $_; }
	}
	close $in;	
}
close $out;


