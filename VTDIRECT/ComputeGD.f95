PROGRAM ComputeGD
USE REAL_PRECISION
		IMPLICIT NONE
		!local variables
		REAL(KIND = R8)::x1
		REAL(KIND = R8)::x2
		REAL(KIND = R8):: f1
		REAL(KIND = R8):: f2
		REAL(KIND = R8):: g
		REAL(KIND = R8):: h
		REAL(KIND = R8)::t, ts, alpha

		OPEN(110, FILE="convGD.dat", STATUS='OLD')
		alpha = 4
		do x1=0,1,0.002
			do x2=0,1,0.002
				f1 = 4*x1
!				if(x2<=0.4) then
					t = (x2-0.2)/0.02
					ts = t**2
					g=4-3*(exp(-ts))
!				else 
!					t = (x2-0.7)/0.2
!					ts = t**2
!					g=4-2*(exp(-ts))
!				end if
				if(f1<=g) then 
					h = 1 - (f1/g)**alpha 
				else
					h = 0
				end if
				f2 = g*h
				if(f1<1.1 .and. f2<1.1) then
					write(110,*)x1, x2, f1, f2
				end if
			end do
		end do
		
		CLOSE(110)
END PROGRAM ComputeGD
