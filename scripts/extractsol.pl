#!/usr/local/bin/perl
use File::Copy;
use Tie::File;
$ifname = "madsresults.dat";
$ofname = "temp.dat";
@array = {};
@array1 = {};
$NDV = 2;
tie @array, 'Tie::File', $ifname or die;
open OUT, ">", $ofname or die "$!\n";		

$nrec = $#array/7;
$st = 1;
for $i(0..$nrec) {
	@rec = split(/[ \(\)=]+/,$array[$st]);
	print @rec,"\n";
	for $i(1..$NDV){
		print OUT " ",$rec[$i];
	}
	print OUT "\n";
	$st = $st + 7;
}
close OUT;
untie @array;

system("mv temp.dat RSMOutTest.dat");

