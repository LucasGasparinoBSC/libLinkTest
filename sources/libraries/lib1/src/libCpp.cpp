#include "libCpp.hpp"

// Procedure to generate 2 random arrays with float values between 0 and 1
void genData(int n, float *a, float *b) {
#ifdef USE_ACC
    #pragma acc parallel loop
#endif
    for (int i = 0; i < n; i++) {
        a[i] = (float)rand() / (float)RAND_MAX;
        b[i] = (float)rand() / (float)RAND_MAX;
    }
}