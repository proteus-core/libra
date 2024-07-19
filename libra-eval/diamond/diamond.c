#include "diamond.h"
#include "marker.h"

int diamond(/* secret */ int a, int b)
{
  int result;

  /* Begin of sensitive region */ MARK(1);

  /* A series of secret-dependent branches */
  if (a == b)
  {
    result = 0;
  }
  else if (a < b)
  {
    result = 3;
  }
  else
  {
    result = 7;
  }

  /* End of sensitive region */ MARK(2);

  /* A secret-independent branch */
  if (b == 10)
  {
    result *= 4;
  }

  return result;
}
