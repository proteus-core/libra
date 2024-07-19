#include "mulmod16.h"
#include "marker.h"

int main(void)
{
#if defined LEGACY

  (void) mulmod16(0, 9114);
  MARK(101);

  (void) mulmod16(7906, 0);
  MARK(102);

  (void) mulmod16(7, 8);
  MARK(103);

  (void) mulmod16(267, 13853);
  MARK(104);

  (void) mulmod16(13853, 267);
  MARK(105);

#elif defined EXPERIMENT_1_1

  (void) mulmod16(0, 1);

#elif defined EXPERIMENT_1_2

  (void) mulmod16(1, 0);

#elif defined EXPERIMENT_1_3

  (void) mulmod16(1, 1);

#elif defined EXPERIMENT_1_4

  (void) mulmod16(3, 7);

#else

#error "Invalid experiment identifier"

#endif


  return 0;
}
