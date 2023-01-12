#include "libCpp.hpp"

void genData(int n, float *a, float *b) {
#ifdef USE_ACC
    #pragma acc parallel loop
#endif
    for (int i = 0; i < n; i++) {
        a[i] = (float) i;
        b[i] = (float) i*i;
    }
}