#include "kruskal.h"
#include "marker.h"

/* noinline ? */
static int find(int x, int par[]) 
{
  if (par[x] != x)
  {
    return find(par[x], par);
  }

  return x;
}

int kruskal(/* secret */ int g[], int mst[], int par[], int len)
{
  for (int i=0; i < len; ++i)
  {
    mst[i] = -1;
    par[i] = i;
  }

  /* TODO: This statement should be the first of the function */
  MARK(100);

  int idx = 0;

  for (int i=1; i < len; i += 2)
  {
    int src = find(g[i], par);
    int tgt = find(g[i + 1], par);

    /* Begin of sensitive region */ MARK(1);

     /* The security concern is that the following branch leaks the number of
      * graph’s vertices via a timing side channel [23].
      *
      * NOTE: Since idx is confidential, there is also a secret-dependent memory
      *       access. The file "kruskal_s.c" fixes this (by always accessing all
      *       possible memory locations) and the hardened forms are based on
      *       kruskal_s.c.
      */
    if (src != tgt)
    {
      mst[++idx] = src;
      mst[++idx] = tgt;
      par[src] = tgt;
    }

    /* End of sensitive region */ MARK(2);
  }

#if 0
  mst[0] = idx / 2 + 1;
#endif
  mst[0] = idx / 2;

  return mst[0];
}
