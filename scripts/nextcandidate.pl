#!/usr/local/bin/perl
use Tie::File;
use POSIX;
use File::Copy;
	my($tol)=0.000000000001;
	my($tol1)=0.01;
	my(@X)=();
	my(@XL)=();
	my(@XU)=();
	my(@array)={};
	my($cp) = 0;
	my($cq) = 0;
	my($wp) = 0.0;
	my($wq) = 0.0;
	my(@prev)=();
	my(@curr)=();
	my(@next)=();
	my($i)=0;
	my($argmax) = 0;
	my($dist) = 0;
	my($maxd) = 0;
	my($ifname) = "outskyline.dat";
	my($NDV) = 2;
	my(@xlb) = (0.0,0.0); #--RyuTP
	my(@xub) = (1.0,1.0); #--RyuTP

#	my(@xlb) = (0.5,0.2); #DrCTP
#	my(@xub) = (1.0,2.0); #DrCTP
 
	system("perl -pi -e \"s/^\n//\" outskyline.dat");
	tie @array, 'Tie::File', $ifname or die;

	$delta = 0.2;

	if($#array < 0 ){
		$wp = $wq = ($xlb[0]+$xub[0])/2;
		@X = ($xlb[1]+$xub[1])/2;
	}elsif( $#array == 0){
		@X = split(" ",$array[0]);	
		$wp = $wq = 0.5;
	}elsif($#array == 1){
		@X = split(" ",$array[0]);	
		@X1 = split(" ",$array[1]);	

		$a = abs($X[$NDV+1]-$X1[$NDV+1]);
		$b = abs($X[$NDV]-$X1[$NDV]);
		if(($a+$b) <= $tol) {
			$wp = $wq = 0.5;	
		}else {
			$cq = 1/( $a+$b  );
			$wp = $wq = $cq * $a;
		}
	}
	else {
		@visited=();
		@deltaXc=();
		$fname = "dist.dat";
		$FOUND = 0;
		$n=0;
		for $i (1..$#array-1){
			$visited[$i]=0;
			$deltaXc[$i]=0;
			@curr = split(" ",$array[$i]);
#			print "curr = ",@curr,"\n";
			open DATA, "<Xc.dat" or die "can't open file!\n";
			while(<DATA>){
				@line = split(" ",$_);
	#			print "curr and Xc = ",@curr,"\t",@line,"\n";
				$cnt=0;
				for $j (0..$NDV-1) {
					$diff = $line[$j]-$curr[$j];
					$absdiff = abs($diff);
		#			print "NDV, diff and absdiff ",$NDV, " ",$tol, " ",$diff," ",$absdiff,"\n";
					if(abs($line[$j]-$curr[$j])<=$tol1){
			#			print "match \n";
						$cnt++;
					}
				}
				if($cnt==$NDV){
				#	print "visited X\n";
					$visited[$i] = 1;
					$deltaXc[$i] = $line[$NDV];
					break;
				}
			}
			close DATA;
		}
		#print "visited arr = ",@visited, "and deltaxc = ",@deltaXc,"\n";
		open DISTF,">>","dist.dat" or die "cant open dist file";
		for $i (1..$#array-1){
				@prev = split(" ",$array[$i-1]);
				@curr = split(" ",$array[$i]);
				@next = split(" ",$array[$i+1]);
				$dist = sqrt( pow(abs($curr[$NDV]-$prev[$NDV]),2)+pow(abs($curr[$NDV+1]-$prev[$NDV+1]),2) )+sqrt( pow(abs($next[$NDV]-$curr[$NDV]),2)+pow(abs($next[$NDV+1]-$curr[$NDV+1]),2));
				print DISTF $i, " ",$dist,"\n";
	}
	close DISTF;
	&SortDistMap();
	system("perl -pi -e \"s/^\n//\" dist.dat");
	tie @distmap, 'Tie::File', $fname or die;
	for $i(0..$#distmap){
	print "distmap=",$distmap[$i],"\n";}
	$i=0;
	while($FOUND==0) {
		@ln = split(" ",$distmap[$i]);
		$ind = $ln[0];	
		print "index = ",$ind,"visited? = ",$visited[$ind],"\n";
		if($visited[$ind] == 0){
			print "in not visited!\n";
			$FOUND = 1;
			$maxd = $ln[1];				
			$argmax = $ind;
			break;
		}else {
			print "visited!\n";
			#if(abs($delta-$deltaXc[$ind])<=$tol){
				$del = $deltaXc[$ind]*0.5;
				if($del>=0.001){
					$delta = $del;
					$FOUND = 1;
					$maxd = $ln[1];				
					$argmax = $ind;
					break;
				}
			#}
		}
		$i=$i+1;
	}
	untie @distmap;
	@prev = split(" ",$array[$argmax-1]);
	@next = split(" ",$array[$argmax+1]);
	@curr = split(" ",$array[$argmax]);

	print @prev,"\n",@curr,"\n",@next,"\n";

	for $i (0..$NDV-1) {
		$X[$i] = $curr[$i];
	}

	$a = abs($curr[$NDV+1]-$prev[$NDV+1]);
	$b = abs($curr[$NDV]-$prev[$NDV]);
	if(($a+$b) <= $tol) {
		$wp = 0.5;	
	}else {
		$cp = 1/(  $a+$b  );
		$wp = $cp * $a;
	}

	$a = abs($curr[$NDV+1]-$next[$NDV+1]);
	$b = abs($curr[$NDV]-$next[$NDV]);
	if(($a+$b) <= $tol) {
		$wq = 0.5;	
	}else {
		$cq = 1/( $a+$b  );
		$wq = $cq * $a;
	}
}
	untie @array;

	for $i (0..$NDV-1) {
		$XL[$i] = $X[$i]-$delta;
		if($XL[$i]<$xlb[$i]) {$XL[$i]=$xlb[$i];}
		$XU[$i] = $X[$i]+$delta;
		if($XU[$i]>$xub[$i]) {$XU[$i]=$xub[$i];}
	}

	open OUT, ">weights.dat" or die "$!\n";
	print OUT "0\n";
	print OUT $wp,"0\n";
	if($wp!=$wq){
		print OUT $wq,"0\n";
	}
	print OUT "1\n";
	close OUT;

	tie @array, 'Tie::File', 'delta.dat' or die;
	$array[0] = $delta;
	untie @array;
	
	print "X: ",@X, "\nLB = ", @XL, "\nUB= ", @XU, "\nwts= ",$wp,"\t",$wq,"\n";


	open OUT, ">>Xc.dat" or die "can't open Xc.dat\n";
	for $i (0..$NDV-1) {
		print OUT $X[$i]," ";
	}
	print OUT $delta,"\n";
	close OUT;

$elimit = 7;
tie @array, 'Tie::File', 'directTT.nml' or die;
$array[4] = "LB(1:2)=".$XL[0].",".$XL[1];
$array[5] = "UB(1:2)=".$XU[0].",".$XU[1];
$array[9] = "eval_lim=".$elimit;
$array[12] = "eps_fmin=0.1";
untie @array;

tie @array, 'Tie::File', '/s/shubhgd/mathsoft/NOMAD/nomad.3.5.1/examples/interfaces/FORTRAN/test/test.cpp' or die;

@array[71] = "\t\tx0[0] = ".$X[0].";";
@array[72] = "\t\tx0[1] = ".$X[1].";";
@array[77] = "\t\tlb[0] = ".$XL[0].";";
@array[78] = "\t\tlb[1] = ".$XL[1].";";
@array[83] = "\t\tub[0] = ".$XU[0].";";
@array[84] = "\t\tub[1] = ".$XU[1].";";

untie @array;

sub SortDistMap {
	$fname = "dist.dat";
	tie @distmap, 'Tie::File', $fname or die;
	sub byVal { 
		@first = split( " ", $b );
	  @second = split( " ", $a );
		$compare = ( $first[1] <=> $second[1] );        
	    if ( $compare != 0 ) { return ( $compare ); }
	}

	@distmap = sort byVal @distmap;
	untie @distmap;
}
