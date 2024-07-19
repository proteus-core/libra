#include "mulmod16.h"
#include "marker.h"

#define mulMask    0x0000FFFF
#define mulModulus 0x00010001

int mulmod16(/* secret */ int a, int b)
{
  int p;

  a &= mulMask;
  b &= mulMask;

  /* Begin of sensitive region */ MARK(1);

  if (a == 0)
  {
    a = mulModulus - b;
  }
  else if (b == 0)
  {
    a = mulModulus - a;
  }
  else
  {
    p = a * b;
    b = p & mulMask;
    a = p >> 16;
    a = b - a + (b < a ? 1 : 0);
  }

  /* End of sensitive region */ MARK(2);

  return a & mulMask;
}
