module libFortran2
    use libFortran1
    implicit none
    contains
        subroutine doubleInnerProduct(n,s)
            implicit none
            integer(4), intent(in)  :: n
            real(4),    intent(out) :: s
            integer(4)              :: i, j
            real(4),    allocatable :: M1(:,:), M2(:,:)
            print*, "Inside doubleInnerProduct"
            allocate(M1(n,n), M2(n,n))
            print*, "Before call to genMatrix"
            call genMatrix(n,M1)
            print*, "Before call to genMatrix"
            call genMatrix(n,M2)
            s = 0.0
#ifdef USE_ACC
            !$acc parallel loop collapse(2) reduction(+:s) present(M1,M2)
#endif
            do j = 1, n
                do i = 1, n
                    s = s + M1(i,j)*M2(i,j)
                end do
            end do
#ifdef USE_ACC
            !$acc end parallel loop
#endif
            deallocate(M1)
            deallocate(M2)
        end subroutine doubleInnerProduct
end module libFortran2