#include "modexp2.h"
#include "marker.h"

int main(void)
{
#if defined LEGACY

  (void) modexp2(10, 1);
  MARK(101);

  (void) modexp2(10, 15);
  MARK(102);

  (void) modexp2(10, 42);
  MARK(103);

  (void) modexp2(10, 142);
  MARK(104);

#elif defined EXPERIMENT_1_1

  (void) modexp2(10, 0x00);

#elif defined EXPERIMENT_1_2

  (void) modexp2(10, 0x01);

#elif defined EXPERIMENT_1_3

  (void) modexp2(10, 0x0A);

#elif defined EXPERIMENT_1_4

  (void) modexp2(10, 0xFA);

#elif defined EXPERIMENT_1_5

  (void) modexp2(10, 0x14A);

/* Here starts a different public partition, not becasue of different public
 * inputs but because the RISC-V code to load immediates < 1024 is
 * different then the code to load immediates > 1024.
 */
#elif defined EXPERIMENT_2_1

  (void) modexp2(10, 0xC02A);

#elif defined EXPERIMENT_2_2

  (void) modexp2(10, 0xFBC02A);

#elif defined EXPERIMENT_2_3

  (void) modexp2(10, 0x26FBC02A);

#elif defined EXPERIMENT_2_4

  (void) modexp2(10, 0x12345678);

#else

#error "Invalid experiment identifier"

#endif


  return 0;
}
