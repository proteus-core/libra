#include "marker.h"
#include "sharevalue.h"

#define S SPECIAL_SHARE

#if defined LEGACY

static int ids1[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
static int ids2[] = {1, S, 3, S, 5, S, 7, S, 9, S};
static int ids3[] = {S, S, S, S, S, S, S, S, S, S};

#else

/* Make sure the data section always begins with the same data */
int dummy[] = {
  0xcafebabe, 0xcafebabe, 0xcafebabe, 0xcafebabe,
  0xcafebabe, 0xcafebabe, 0xcafebabe, 0xcafebabe,
  0xcafebabe, 0xcafebabe, 0xcafebabe, 0xcafebabe,
  0xcafebabe, 0xcafebabe, 0xcafebabe, 0xcafebabe,
};

#endif

static int qty[]  = {10, 9, 8, 7, 6, 5, 4, 3, 2, 100};

int main(void)
{
#if defined LEGACY

  (void) share_value(ids1, qty, sizeof(ids1)/sizeof(ids1[0]));
  MARK(101);

  (void) share_value(ids2, qty, sizeof(ids2)/sizeof(ids2[0]));
  MARK(102);

  (void) share_value(ids3, qty, sizeof(ids3)/sizeof(ids3[0]));
  MARK(103);

#elif defined EXPERIMENT_1_1

  static int ids1[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
  (void) share_value(ids1, qty, sizeof(ids1)/sizeof(ids1[0]));

#elif defined EXPERIMENT_1_2

  static int ids2[] = {1, S, 3, S, 5, S, 7, S, 9, S};
  (void) share_value(ids2, qty, sizeof(ids2)/sizeof(ids2[0]));

#elif defined EXPERIMENT_1_3

  static int ids3[] = {S, S, S, S, S, S, S, S, S, S};
  (void) share_value(ids3, qty, sizeof(ids3)/sizeof(ids3[0]));

#else

#error "Invalid experiment identifier"

#endif


  return 0;
}
