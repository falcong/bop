// Deb Discontinuous, alpha=2, q=4
#include <cmath>
#include <string>
#include <iostream>
#include <fstream>
#include <cstdlib>
using namespace std;

#define ALPHA  2.0
#define Q      4.0
#define PIT2   6.2831853071796
#define PI 		 3.14159265359

int main ( int argc , char ** argv ) {

  double x[20];

  if ( argc == 2 ) {

    ifstream in ( argv[1] );

		for(int i = 0; i<20; i++){
			in >> x[i];
		}

    if ( in.fail() ) {
      cout << 1e20 << " " << 1e20 << endl;
      in.close();
      return 1;
    }

    in.close();
  }

  else if ( argc > 2 ) {
		for(int i = 0; i < 20; i++){
    	x[i] = atof(argv[i+1]);
		}
  }
  else  {
    cout << 1e20 << " " << 1e20 << endl;
    return 1;
  }

  double f1  = x[0];
	double SumXi = 0.0;
	for(int i=1;i<20;i++) {
		SumXi = SumXi + pow(x[i],2) - 10*cos(4*PI*x[i]);
	}
  double g   = 1 + 10.0 * 19 + SumXi;
  double f2  = g * (1-pow((x[0]/g),2));


  cout.precision(12);
  cout << f1 << " " << f2 << endl;
  return 0;
}

