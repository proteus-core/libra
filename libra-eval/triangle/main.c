#include "triangle.h"
#include "marker.h"

int main(void)
{
#if defined LEGACY

  (void) triangle(1, 2);
  MARK(101);

  (void) triangle(2, 1);
  MARK(102);

#elif defined EXPERIMENT_1_1

  (void) triangle(1, 2);

#elif defined EXPERIMENT_1_2

  (void) triangle(3, 2);

#else

#error "Invalid experiment identifier"

#endif


  return 0;
}
