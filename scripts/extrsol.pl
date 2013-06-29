#!/usr/local/bin/perl
use File::Copy;
use Tie::File;
$tol = 0.00000000000001;
$ifname = "temp.dat";
$ifname1 = "RSMOutTest.dat";
$ofname = "temp1.dat";
@array = {};

open OUT, ">", $ofname or die "$!\n";		
tie @array, 'Tie::File', $ifname or die;

while(@array){
	$ln = shift(@array);
	print $ln,"\n";
	open DATA, "<", $ifname1 or die "can't open file!\n";
	while(my $line = <DATA>){
		if($line =~/^$ln/) {print OUT $line; break; } 
	}
	close DATA;
}

close OUT;
untie @array;


#copy($ofname,$ifname1) or die "Copy failed: $!";
#system("rm temp.dat temp1.dat");
