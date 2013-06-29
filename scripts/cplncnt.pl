#!/usr/local/bin/perl
use Tie::File;
use File::Copy;

my($ifname) = 'RSMInTest.dat';
my($lnCount) = 0;

tie @array, 'Tie::File', $ifname or die;
$lnCount = @array;

@array[0] = $lnCount-1;

untie @array;
