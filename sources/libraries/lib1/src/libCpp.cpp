#include "libCpp.hpp"
#include <iostream>

void genData(int n, float *a, float *b) {
    std::cout << "Generating data..." << std::endl;
    std::cout << "n = " << n << std::endl;
#ifdef USE_ACC
    #pragma acc parallel loop
#endif
    for (int i = 0; i < n; i++) {
        a[i] = (float) i;
        b[i] = (float) i*i;
    }
}