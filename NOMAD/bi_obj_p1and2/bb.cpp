// Deb Discontinuous, alpha=2, q=4
#include <cmath>
#include <string>
#include <iostream>
#include <fstream>
#include <cstdlib>
using namespace std;

#define ALPHA  0.25

int main ( int argc , char ** argv ) {

  double x1 , x2;

  if ( argc == 2 ) {

    ifstream in ( argv[1] );

    in >> x1 >> x2;

    if ( in.fail() ) {
      cout << 1e20 << " " << 1e20 << endl;
      in.close();
      return 1;
    }

    in.close();
  }

  else if ( argc == 3 ) {
    x1 = atof(argv[1]);
    x2 = atof(argv[2]);
  }
  else  {
    cout << 1e20 << " " << 1e20 << endl;
    return 1;
  }

  double f1  = 4*x1;
	double px2 = 0.0;
	if(x2<=0.4)
		px2 = (x2-0.2)/0.02;
	else
		px2 = (x2-0.7)/0.2;
	double ppx2 = pow(px2,2);
	double eppx2 = exp(-ppx2);
	double g = 0.0;
	if(x2<=0.4)		
		g   = 4-3*eppx2;
	else 
		g   = 4-2*eppx2;			
	double h = 0.0;
  double f1g = f1 / g;
	if(f1 <= g) {
			h = 1 - pow(f1g,ALPHA);
	}else {
			h = 0;
	}
  double f2  = g * h;

  cout.precision(12);

  cout << f1 << " " << f2 << endl;
  
  return 0;
}

