#include "bsl.h"
#include "marker.h"

int main(void)
{

#if defined LEGACY

  static char password[BSL_PASSWORD_LENGTH] = "0123456789ABCDEF";

  BSL430_unlock_BSL(password);
  MARK(101);

  password[2] = 'X';
  BSL430_unlock_BSL(password);
  MARK(102);

  password[7] = 'X';
  password[8] = 'X';
  BSL430_unlock_BSL(password);
  MARK(103);

  password[10] = 'X';
  password[11] = 'X';
  BSL430_unlock_BSL(password);
  MARK(104);

  password[2] = '2';
  password[7] = '7';
  password[8] = '8';
  password[10] = 'A';
  password[11] = 'B';
  BSL430_unlock_BSL(password);
  MARK(105);

#elif defined EXPERIMENT_1_1

  static char password[BSL_PASSWORD_LENGTH] = "----------------";
  BSL430_unlock_BSL(password);

#elif defined EXPERIMENT_1_2

  static char password[BSL_PASSWORD_LENGTH] = "0-23456789ABCDEF";
  BSL430_unlock_BSL(password);

#elif defined EXPERIMENT_1_3

  static char password[BSL_PASSWORD_LENGTH] = "012-456789A-CDEF";
  BSL430_unlock_BSL(password);

#elif defined EXPERIMENT_1_4

  static char password[BSL_PASSWORD_LENGTH] = "012-456-89ABCD-F";
  BSL430_unlock_BSL(password);

#elif defined EXPERIMENT_2_1

  /* Correct password forms a public partition by itself because of the
   * branching on classified data in BSL430_unlock_BSL().
   */

  static char password[BSL_PASSWORD_LENGTH] = "0123456789ABCDEF";
  BSL430_unlock_BSL(password);

#else

#error "Invalid experiment identifier"

#endif

  return 0;
}
