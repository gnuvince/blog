#include <stdio.h>
#include <stdint.h>

/* Coerce a bit pattern to a sinle-precision float. */
int main(void) {
    int32_t n = 1234567890;
    float f = *((float *) &n);
    printf("The bits %x as a float represent: %.6f\n", n, f);
    return 0;
}
