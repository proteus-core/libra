#include "diamond.h"
#include "marker.h"

int main(void)
{

#if defined LEGACY

  (void) diamond(1, 1);
  MARK(101);

  (void) diamond(1, 2);
  MARK(102);

  (void) diamond(2, 1);
  MARK(103);

  (void) diamond(2, 10);
  MARK(104);

#elif defined EXPERIMENT_1_1

  (void) diamond(2, 2);

#elif defined EXPERIMENT_1_2

  (void) diamond(1, 2);

#elif defined EXPERIMENT_1_3

  (void) diamond(3, 2);

#elif defined EXPERIMENT_2_1

  (void) diamond(10, 10);

#elif defined EXPERIMENT_2_2

  (void) diamond(9, 10);

#elif defined EXPERIMENT_2_3

  (void) diamond(11, 10);

#else

#error "Invalid experiment identifier"

#endif

  return 0;
}
