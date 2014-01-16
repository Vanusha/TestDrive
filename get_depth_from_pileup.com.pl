#!/usr/bin/perl -w

use strict;

die"Usage:
	perl [script] [pileup]\n"
	unless @ARGV == 1;
my $pileup=$ARGV[0];

open F,"<$pileup"
	or die"cannot open $pileup:$!";
open W,">pileup_depth_20_10_4.txt"
	or die"cannot open:$!";

my $lg20;
my $lg10;
my $lg4;

while(<F>){
	my @lines=split;
	if($lines[3] >20){
		$lg20++;
		$lg10++;
		$lg4++;
	}elsif($lines[3] >10){
		$lg10++;
		$lg4++;
	}elsif($lines[3] >4){
		$lg4++;
	}
}

print W ">20x:$lg20\n";
print W ">10x:$lg10\n";
print W ">4x:$lg4\n";
