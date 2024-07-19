#include "ifthenloop.h"
#include "marker.h"

int main(void)
{

#if defined LEGACY

  (void) ifthenloop(1, 2);
  MARK(101);

  (void) ifthenloop(2, 1);
  MARK(102);

#elif defined EXPERIMENT_1_1

  (void) ifthenloop(1, 2);

#elif defined EXPERIMENT_1_2

  (void) ifthenloop(3, 2);

#else

#error "Invalid experiment identifier"

#endif

  return 0;
}
