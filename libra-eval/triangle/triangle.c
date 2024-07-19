#include "triangle.h"
#include "marker.h"

int triangle(/* secret */ int a, int b)
{
  int result = 3;

  /* Begin of sensitive region */ MARK(1);

  if (a < b)
  {
    result = 7;
  }

  /* End of sensitive region */ MARK(2);

  return result;
}
