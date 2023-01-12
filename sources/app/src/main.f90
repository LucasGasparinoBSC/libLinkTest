program main
    use libFortran2
    implicit  none
    integer(4), parameter :: n = 10000
    real(4)               :: s
    print*, "Before call to doubleInnerProduct"
    call doubleInnerProduct(n,s)
    print*, "s := ", s
end program main