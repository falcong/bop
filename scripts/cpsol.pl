#!/usr/local/bin/perl
use File::Copy;
use Tie::File;

#$ifname = "temp.dat";
#$ifname1 = "RSMOutTest.dat";
#$ofname = "temp1.dat";
#$tol = 0.00000000000000001;
#@array = {};
#$NDV = 20;

#open OUT, ">", $ofname or die "$!\n";		
#tie @array, 'Tie::File', $ifname or die;

#while(@array){
#	$tmp = shift(@array);
#	@ln = split(" ",$tmp);
	#print $ln[0]," ",$ln[1],"\n";
#	open DATA, "<", $ifname1 or die "can't open file!\n";
#	while(<DATA>){
#		@line = split(" ",$_); 
#		$cnt = 0;
#		for $i(0..$NDV-1){
#			if(abs($line[$i]-$ln[$i]) <= $tol) {
#				$cnt=$cnt+1;
#			}
#		}
#		print "cnt = ",$cnt, " and ", @ln, " and ", @line,"\n";
#		if($cnt==($NDV)){
#			print " matched \n";
#			print OUT $_; 
#			break; 
#		} 
#	}
#	close DATA;
#}

#close OUT;
#untie @array;

#system("cp temp1.dat RSMOutTest.dat");
#system("rm temp.dat temp1.dat");



