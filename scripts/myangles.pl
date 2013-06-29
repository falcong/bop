#!/usr/local/bin/perl
use Tie::File;
use POSIX;
use File::Copy;
use Math::Trig;

$ifname = "outskyline.dat";
open OUT, ">drcangs.dat" or die "$!\n";
tie @array, 'Tie::File', $ifname or die;
for $i (0..$#array){
		@curr = split(" ",$array[$i]);
#		@next = split(" ",$array[$i+1]);
		$prod = (0-2)*($curr[2]-2)+(7-7)*($curr[3]-7);
#		$v1 = sqrt( pow(($curr[2]-2),2)+pow(($curr[3]-7),2) );
		$v1 = 2;
		$v2 = sqrt( pow(($curr[2]-2),2)+pow(($curr[3]-7),2));
		$vcos = $prod/($v1*$v2);
		print "vcos =  ", $vcos,"\n";
		$vangle = acos($vcos)/1.5707963267949;
		print OUT $vangle, "\n";
}
close OUT;
untie @array;
