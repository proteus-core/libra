#include "marker.h"
#include "kruskal.h"

int main(void)
{
  /* 5 vertices, 7 edges */
  static int g1[] = {7, 1, 2, 2, 3, 4, 3, 4, 5, 1, 5, 1, 3, 4, 1};

  /* 7 vertices, 7 edges */
  static int g2[] = {7, 1, 2, 4, 3, 4, 5, 7, 5, 7, 1, 6, 2, 2, 4};

  int mst1[sizeof(g1)];
  int mst2[sizeof(g1)];
  int par[sizeof(g1)];

#if defined LEGACY

  /* EXPECTED = {4, 1, 2, 2, 3, 4, 3, 3, 5}; */
  (void) kruskal(g1, mst1, par, sizeof(g1)/sizeof(g1[0]));
  MARK(101);

  /* EXPECTED = {6, 1, 2, 4, 3, 3, 5, 7, 5, 5, 2, 6, 2}; */
  (void) kruskal(g2, mst2, par, sizeof(g2)/sizeof(g2[0]));
  MARK(102);

#elif defined EXPERIMENT_1_1

  /* EXPECTED = {4, 1, 2, 2, 3, 4, 3, 3, 5}; */
  (void) kruskal(g1, mst1, par, sizeof(g1)/sizeof(g1[0]));

#elif defined EXPERIMENT_1_2

  /* EXPECTED = {6, 1, 2, 4, 3, 3, 5, 7, 5, 5, 2, 6, 2}; */
  (void) kruskal(g2, mst2, par, sizeof(g2)/sizeof(g2[0]));

#else

#error "Invalid experiment identifier"

#endif


  return 0;
}
