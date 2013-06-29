#!/usr/local/bin/perl

use Tie::File;
$ifname = "weights.dat";
$ofname = "weight.dat";
@array = {};

tie @array, 'Tie::File', $ifname or die;

while(@array) {
	$wt = shift(@array);

	open OUT, ">", $ofname or die "$!\n";
	print OUT $wt;
	system("/s/shubhgd/mathsoft/NOMAD/nomad.3.5.1/examples/interfaces/FORTRAN/test/test.exe"); #for RyuTP variable problem
#	system("/s/shubhgd/mathsoft/NOMAD/nomad.3.5.1/examples/interfaces/FORTRAN/testHD/test.exe"); #for 20 variable problem

}
untie @array;
