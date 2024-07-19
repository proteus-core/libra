#include "fork.h"
#include "marker.h"

int fork(/* secret */ int a, int b)
{
  int result = 3;

  /* Begin of sensitive region */ MARK(1);

  if (a < b)
  {
    result = a + 2;
  }

  /* End of sensitive region */ MARK(2);

  return result;
}
