#!/usr/local/bin/perl
use Tie::File;
my($ifname) = "outskyline.dat";
$NDV = 2;
tie @array, 'Tie::File', $ifname or die;
print "size = ",$#array,"\n";
sub byF1 { 
	@first = split( " ", $a );
  @second = split( " ", $b );
#	$compare = ( $first[2] <=> $second[2] || $first[3] <=> $second[3]);  f1 then f2
	$compare = $first[$NDV] <=> $second[$NDV]; #only f1 --- 
    if ( $compare != 0 ) { return ( $compare ); } 
}

@array = sort byF1 @array;
untie @array;
