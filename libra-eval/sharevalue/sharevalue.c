#include "sharevalue.h"
#include "lookup.h"
#include "marker.h"

int share_value(/* secret */ int ids[], int qty[], int len)
{
  int share_val = 0;
  int i = 0;

  while (i < len) 
  {
    int id = ids[i];

    /* Begin of sensitive region */ MARK(1);

    if (id == SPECIAL_SHARE)
    {
      int val = lookup_val(id) * qty[i];

      share_val = share_val + val;
    }

    /* End of sensitive region */ MARK(2);

    i++;
  }

  return share_val;
}
