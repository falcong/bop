#!/usr/local/bin/perl
use Tie::File;
use POSIX;

my(@array)={};
my(@prev)={};
my(@curr)={};
my(@next)={};
my($ifname) = "outskyline.dat";

tie @array, 'Tie::File', $ifname or die;

$argmax = 0;$maxd = 0.0;

for $i (0..$#array){
	
	if($i == 0) {@prev = (0,0,0,0);}
	elsif($i == $#array) {@next = (0,0,0,0);}
	else{
		@prev = $array[$i-1]
		@curr = $array[$i];
		@next = $array[$i+1];
	}

	$dist = sqrt( (abs($curr[2]-$prev[2])**2)+(abs($curr[3]-$prev[3])**2) )+sqrt((abs($next[2]-$curr[2])**2)+(abs($next[3]-$curr[3])**2));

	if($dist>$maxd) {
		$maxd = $dist;
		$argmax = $i;
	}
}

if($#array <= 2){
	$wp = $wq = 0.5;
}
else {
		$cp = 1/( (abs($next[2]-$curr[2])) + (abs($curr[3]-$next[3])) );
		$wp = $cp * (abs($next[2]-$curr[2]));
		$cp = 1/((abs($prev[2]-$curr[2]))+(abs($curr[3]-$prev[3])));
		$wq = $cp * (abs($prev[2]-$curr[2]));
}


untie @array;

