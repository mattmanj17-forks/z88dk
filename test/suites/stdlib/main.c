

#include "stdlib_tests.h"

int main(int argc, char *argv[])
{
    int  res = 0;

    res += test_abs();
#ifndef __8080
    res += test_isqrt();
    res += test_isqrt2();
#endif
    res += test_strtol();
    res += test_unbcd();
#ifndef __8080
    res += test_qsort();
    res += test_qsort_newlib();
#endif
    res += test_bsearch();

    return res;
}
