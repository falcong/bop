#!/usr/local/bin/perl
#use strict;
#use warnings;
use Tie::File;
use File::Copy;

my($ifname) = 'input.txt';
my(@array) = {};
my(@b) = (0,0);
my(@t) = (0,0);
my($lno) = 0;
my($i) = 0;
my($dummy) = 0;
my($tol) = 0.0000000000001;

#print $#ARGV, "\n";
my($source) = 'RSMOutTest.dat';
#my($source) = $ARGV[0];
copy($source,$ifname) or die "Copy failed: $!";

tie @array, 'Tie::File', $ifname or die;
open OUT, ">", "outskyline.dat" or die;

#if($#ARGV<1){
	print OUT $dummy, "\n";
#}

while(@array){
	$temp = shift(@array);
	@b = split(" ",$temp);
	$i = 0;
	while ($i <= $#array) {
		$temp = $array[$i];
		@t = split(" ",$temp);
		if(@t){
		if( ( (($b[2]<$t[2]) or (abs($b[2]-$t[2])<=$tol) ) and ($b[3]<$t[3])) or 
			  ( ($b[2]<$t[2]) and (($b[3]<$t[3]) or (abs($b[3]-$t[3])<=$tol))) 
			) { #RyuTP
#		if( (($b[2]<=$t[2]) and ($b[3]>$t[3])) or (($b[2]<$t[2]) and ($b[3]>=$t[3])) ) { #DrCTP
			splice @array,$i,1;
		}
		elsif( ((($t[2]<$b[2]) or (abs($t[2]-$b[2])<=$tol)) && ($t[3]<$b[3])) || 
				   ( ($t[2]<$b[2]) && (($t[3]<$b[3]) or (abs($t[3]-$b[3])<=$tol))) 
				 ) { #RyuTP
#		elsif( (($t[2]<=$b[2]) && ($t[3]>$b[3])) || (($t[2]<$b[2]) && ($t[3]>=$b[3])) ) { #DrCTP
			@b = @t;
			splice @array,$i,1;
		}
		else{
			$i++;}
		}
	}

	print OUT $b[0], " ", $b[1], " ", $b[2]," ",$b[3], "\n";
	$numND = $numND+1;
	$i = 0;
	while($i <= $#array){
		$temp = $array[$i];
		@t = split(" ",$temp);
		if( (@t) && ( (($b[2]<$t[2]) or (abs($b[2]-$t[2])<=$tol)) && ($b[3]<$t[3]) ) || 
								(	($b[2]<$t[2]) && (($b[3]<$t[3]) or (abs($b[3]-$t[3])<=$tol)) ) 
			) { #RyuTP
#		if( (@t) && ( ($b[2]<=$t[2] && $b[3]>$t[3]) || ($b[2]<$t[2] && $b[3]>=$t[3]) ) ) { #DrCTP
			splice @array,$i,1;
		}
		else {
		$i++;}
	}
}
untie @array;
close(OUT);

#if($#ARGV<1){
	tie @array,'Tie::File', 'outskyline.dat' or die;
	$array[0] = @array-1;
	chomp($array[$#array]);
	untie @array;
#}

