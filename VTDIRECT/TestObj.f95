		MODULE TestObj_MOD
		USE REAL_PRECISION
		CONTAINS

		SUBROUTINE TestObj(X, OBJ)
		IMPLICIT NONE
		REAL(KIND = R8), DIMENSION(:), INTENT(IN):: X
		REAL(KIND = R8), INTENT(OUT):: OBJ

		!local variables
		INTEGER::i
		INTEGER::iflag
		INTEGER:: ierr ! Error status for file I/O.
		REAL(KIND = R8)::tol
		REAL(KIND = R8)::x1
		REAL(KIND = R8)::x2
		REAL(KIND = R8)::x1_t
		REAL(KIND = R8)::x2_t
		REAL(KIND = R8):: f1
		REAL(KIND = R8):: f2
		REAL(KIND = R8):: f1_t
		REAL(KIND = R8):: f2_t
		REAL(KIND = R8):: g
		REAL(KIND = R8):: h
		REAL(KIND = R8)::wt
		REAL(KIND = R8)::Pi
		Pi = 3.14159265359
		tol = 1.0e-13
		iflag = 0

		OPEN(65, FILE="weight.dat", STATUS='OLD')
		READ(65,*) wt
		CLOSE(65)

		x1 = X(1)
		x2 = X(2)

		OPEN(75, FILE="RSMInTest.dat", STATUS='OLD')
		DO
			READ(75,*,IOSTAT=ierr) x1_t,x2_t,f1_t,f2_t
			IF(ierr > 0) THEN
				WRITE(*,*) 'Read failed'
				EXIT
			ELSE IF (ierr < 0) THEN
				f1 = fun1(x1)
		
				g = fun2(x2)
	
				h = fun3(f1,g)

				f2 = g*h

!				WRITE(*,*) 'Evaluate ', x1, x2, f1, f2

				EXIT
			ELSE 
				IF( (abs(x1-x1_t)<=tol) .AND. (abs(x2-x2_t) <= tol)) THEN
					f1 = f1_t
					f2 = f2_t
					iflag = 1
!					WRITE(*,*) 'off the shelf ', x1, x2, f1, f2					
					EXIT
				END IF
			END IF
		END DO
		CLOSE(75)

		
		OBJ = wt*f1+(1-wt)*f2

		IF(iflag == 0) THEN
			OPEN(85, FILE="RSMInTest.dat", STATUS='OLD', POSITION='APPEND')
			WRITE(85,*) X,f1,f2
			CLOSE(85)
		END IF

		CONTAINS

 	  FUNCTION fun1(x1) RESULT(f1)
		IMPLICIT NONE
				REAL(KIND = R8), INTENT(IN) :: x1
				REAL(KIND = R8) :: f1
!				f1=4*x1 
				f1 = 1 - Exp(-4*x1)*(Sin(5*Pi*x1)**4)
		RETURN 
		END FUNCTION fun1

		FUNCTION fun2(x2) RESULT(g)
		IMPLICIT NONE
				REAL(KIND = R8), INTENT(IN):: x2
				REAL(KIND = R8) :: g, t, ts
				IF(x2 <= 0.4_R8) THEN
					t = (x2-0.2)/0.02
					ts = t**2
					g=4-3*(exp(-ts))
				ELSE
					t = (x2-0.7)/0.2
					ts = t**2
					g=4-2*(exp(-ts))
				END IF	
		RETURN 
		END FUNCTION fun2

		FUNCTION fun3(f1,g) RESULT(h)
		IMPLICIT NONE
    		REAL(KIND = R8), INTENT(IN):: f1
    		REAL(KIND = R8), INTENT(IN):: g
				REAL(KIND = R8) :: h
				REAL(KIND = R8) :: alpha
!				alpha = 0.25
				alpha = 4
				IF(f1 <= g) THEN
					h = 1 - (f1/g)**alpha 
				ELSE
					h = 0
				END IF
		RETURN 
		END FUNCTION fun3

		END SUBROUTINE TestObj

		END MODULE TestObj_MOD

