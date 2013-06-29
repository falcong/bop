#!/usr/bin/perl -w
use File::Copy;
use strict;
use warnings;
my($ifname) = "RSMOutTest.dat";
my($ofname) = "temp1.dat";

my %duplicates;
open IDATA, "<", $ifname or die "can't open input file \n";
open ODATA, ">", $ofname or die "can't open temp1.dat \n";

while (<IDATA>) {
	if (!$duplicates{$_}) {
		print ODATA $_;
		#print $_;
	}
	$duplicates{$_}++;
}

system("cp temp1.dat RSMOutTest.dat");
system("rm temp1.dat");
