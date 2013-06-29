#!/usr/local/bin/perl
use Tie::File;
use POSIX;

my($ifname1) = "skyline.dat";
my($ifname2) = "outskyline.dat";
my(@md) = (); #min dist array for all points
tie @array1, 'Tie::File', $ifname1 or die;
print "size = ",$#array1,"\n";

tie @array2, 'Tie::File', $ifname2 or die;
print "size = ",$#array2,"\n";

$i = $j = $d = 0;
$min = 1000;
$sum = 0; $avg = 0; $GD = 0;
$NDV = 20;
$A1NDV = 0;

for $i (0..$#array2) {
	@arr2 = split(" ",$array2[$i]);
	for $j (0..$#array1) {
		@arr1 = split(" ",$array1[$j]);
		$d = sqrt( pow(abs($arr2[$NDV]-$arr1[$A1NDV]),2) + pow(abs($arr2[$NDV+1]-$arr1[$A1NDV+1]),2) );
		if($d<$min){
			$min = $d;
		}
	}
	$md[$i] = pow($min,2);
	$sum = $sum + $md[$i];
#	print "$i ",$md[$i],"\t",$sum,"\n";
	$min = 1000;
}
$sz = $#array2 + 1; 
$avg = $sum/$sz;
print $sz,"\t",$sum,"\t",$avg,"\n";
$GD = sqrt($avg);
print "generational distance = ",$GD,"\n";
untie @array1;
untie @array2;
