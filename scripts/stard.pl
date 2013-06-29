#!/usr/local/bin/perl
use Tie::File;
use POSIX;

#$source = $_[0];
$source = $ARGV[0];
$i = 0; $j = 0;
@array = {};
@volume = {};
@nVolume = {}; #normalized length
@points = {}; #s_i in S_N
@discr = {};
$NDV = 2;
$cumVolume = 0;

print "source = ",$source,"\n";
tie @array, 'Tie::File', $source or die;
if($#array > 1) {
	for $i (0..$#array-1){
		@curr = split(" ",$array[$i]);
		@next = split(" ",$array[$i+1]);
		$volume[$i] = sqrt( pow(abs($next[$NDV]-$curr[$NDV]),2)+pow(abs($next[$NDV+1]-$curr[$NDV+1]),2));
		$cumVolume = $cumVolume + $volume[$i];
	}
	print "cumVol = ",$cumVolume,"\n";
	for $i (0..$#array-1){
		$points[$i] = 0.0;
		if($i==0){
			$points[$i] = $volume[$i] / $cumVolume;	
		}else{
			$points[$i] = $points[$i-1] + $volume[$i]/$cumVolume;	
		}
#			print "vol[i] = ",$volume[$i],"\t",$points[$i],"\n";
	}
	for $i (0..$#array-1){
		$discr[$i] = abs(($i+1)/($#array) - $points[$i]);
		print "$i = ",$discr[$i],"\n";
	}
		@discr = sort { $b <=> $a } @discr;
		$stard = $discr[0];
		print "star discrepancy = ",$stard,"\n";
}else{
	print "Star discrepancy not computed for #(solutions) <= 2\n";
}
untie @array;
