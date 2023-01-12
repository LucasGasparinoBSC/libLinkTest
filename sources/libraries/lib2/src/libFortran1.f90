module libFortran1
	use iso_c_binding
	implicit none
	interface
		subroutine genData(n,a,b) bind(c)
			import c_int, c_float
			implicit none
			integer(kind=c_int)             , intent(in)  :: n
			real(kind=c_float), dimension(n), intent(out) :: a
			real(kind=c_float), dimension(n), intent(out) :: b
		end subroutine genData
	end interface
	contains
		subroutine genMatrix(n,M)
			implicit none
			integer(4)             , intent(in)  :: n
			real(4), dimension(n,n), intent(out) :: M
			integer(4)                           :: i, j
			real(4), dimension(n)                :: a, b
			call genData(n,a,b)
#ifdef USE_ACC
			!$acc parallel loop collapse(2)
#endif
			do i = 1, n
				do j = 1, n
					M(i,j) = a(i) * b(j)
				end do
			end do
		end subroutine genMatrix
end module libFortran1