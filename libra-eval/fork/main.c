#include "fork.h"
#include "marker.h"

int main(void)
{

#if defined LEGACY

  fork(2, 3); MARK(101);
  fork(3, 2); MARK(102);

#elif defined EXPERIMENT_1_1

  (void) fork(2, 3);

#elif defined EXPERIMENT_1_2

  (void) fork(4, 3);

#else

#error "Invalid experiment identifier"

#endif

  return 0;
}
