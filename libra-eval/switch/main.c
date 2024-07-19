#include "switch.h"
#include "marker.h"

int main(void)
{
#if defined LEGACY

  (void) switch_case(0x0001); MARK(101);
  (void) switch_case(0x0002); MARK(102);
  (void) switch_case(0x0003); MARK(103);
  (void) switch_case(0x0004); MARK(104);
  (void) switch_case(0x0005); MARK(105);
  (void) switch_case(0x0006); MARK(106);
  (void) switch_case(0x0007); MARK(107);
  (void) switch_case(0x0008); MARK(108);
  (void) switch_case(0x0009); MARK(109);
  (void) switch_case(0x000a); MARK(110);
  (void) switch_case(0x000b); MARK(111);
  (void) switch_case(0x000c); MARK(112);
  (void) switch_case(0x000d); MARK(113);
  (void) switch_case(0x000e); MARK(114);
  (void) switch_case(0x000f); MARK(115);
  (void) switch_case(0x0010); MARK(116);

  /* None of the cases (there is no default) */
  (void) switch_case(0x0000); MARK(117);

#elif defined EXPERIMENT_1_1

  (void) switch_case(0x0001);

#elif defined EXPERIMENT_1_2

  (void) switch_case(0x0002);

#elif defined EXPERIMENT_1_3

  (void) switch_case(0x0003);

#elif defined EXPERIMENT_1_4

  (void) switch_case(0x0004);

#elif defined EXPERIMENT_1_5

  (void) switch_case(0x0005);

#elif defined EXPERIMENT_1_6

  (void) switch_case(0x0006);

#elif defined EXPERIMENT_1_7

  (void) switch_case(0x0007);

#elif defined EXPERIMENT_1_8

  (void) switch_case(0x0008);

#elif defined EXPERIMENT_1_9

  (void) switch_case(0x0009);

#elif defined EXPERIMENT_1_10

  (void) switch_case(0x000a);

#elif defined EXPERIMENT_1_11

  (void) switch_case(0x000b);

#elif defined EXPERIMENT_1_12

  (void) switch_case(0x000c);

#elif defined EXPERIMENT_1_13

  (void) switch_case(0x000d);

#elif defined EXPERIMENT_1_14

  (void) switch_case(0x000e);

#elif defined EXPERIMENT_1_15

  (void) switch_case(0x000f);

#elif defined EXPERIMENT_1_16

  (void) switch_case(0x0010);

#elif defined EXPERIMENT_1_17

  /* None of the cases (there is no default) */
  (void) switch_case(0x0000);

#else

#error "Invalid experiment identifier"

#endif


  return 0;
}
