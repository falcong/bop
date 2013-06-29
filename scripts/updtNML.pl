#!/usr/local/bin/perl
use Tie::File;
use POSIX;
tie @array, 'Tie::File', 'X0.dat' or die;
@XL=split(" ",$array[1]);
@XU=split(" ",$array[2]);
untie @array;
$ndv=12;
$elimit = 25;
tie @array, 'Tie::File', 'directTT.nml' or die;
for $i (0..$ndv-1){
	$strXL=$XL[$i].",";
	$strXU=$XU[$i].",";	
}
chop $strXL;
chop $strXU;
$str1="LB(1:".$ndv.")="$strXL;
$array[4] = str1;
$str1="UB(1:".$ndv.")="$strXU;
$array[5] = str1;
$array[9] = "eval_lim=".$elimit;
$array[12] = "eps_fmin=0.1";
untie @array;

