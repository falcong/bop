#!/bin/sh
../tmain
perl ./copylncnt.pl RSMInTest.dat
cd $NOMAD_HOME/examples/interfaces/FORTRAN/test/
g++ -ansi -Wall -O3  -I/s/shubhgd/mathsoft/NOMAD/nomad.3.5.1/src -I. -c test.cpp
g++ -o test.exe *.o /s/shubhgd/mathsoft/NOMAD/nomad.3.5.1/lib/nomad.a -lm -ansi -Wall -O3 /usr/local/lib/gcc-lib/i686-suse-linux-gnu/4.0.3/libf95.a
cd /s/shubhgd/mathsoft/VTDIRECT95/serial
perl ./execnomad.pl
perl ./rmdups.pl
perl ./extractsol.pl
#perl ./cpsol.pl
perl ./rmdups.pl
rm madsresults.dat
perl ./copylncnt.pl RSMOutTest.dat
../tskyline
perl ./rmlncnt.pl RSMInTest.dat
cp RSMInTest.dat RSMOutTest.dat
perl ./skyline.pl
perl ./rmlncnt.pl outskyline.dat
perl ./sortskyline.pl
perl ./nextcandidate.pl
cp blank.dat RSMOutTest.dat
cp blank.dat dist.dat
