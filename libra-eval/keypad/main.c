#include "keypad.h"
#include "marker.h"

int main(void)
{
  keypad_init();

#if defined LEGACY

  (void) keypad_poll(KEY_STATE_1 ); MARK(101);
  (void) keypad_poll(KEY_STATE_2 ); MARK(102);
  (void) keypad_poll(KEY_STATE_3 ); MARK(103);
  (void) keypad_poll(KEY_STATE_4 ); MARK(104);
  (void) keypad_poll(KEY_STATE_5 ); MARK(105);
  (void) keypad_poll(KEY_STATE_6 ); MARK(106);
  (void) keypad_poll(KEY_STATE_7 ); MARK(107);
  (void) keypad_poll(KEY_STATE_8 ); MARK(108);
  (void) keypad_poll(KEY_STATE_9 ); MARK(109);
  (void) keypad_poll(KEY_STATE_10); MARK(110);
  (void) keypad_poll(KEY_STATE_11); MARK(111);

#elif defined EXPERIMENT_1_1

  keypad_poll(KEY_STATE_1);

#elif defined EXPERIMENT_1_2

  keypad_poll(KEY_STATE_2);

#elif defined EXPERIMENT_1_3

  keypad_poll(KEY_STATE_3);

#elif defined EXPERIMENT_1_4

  keypad_poll(KEY_STATE_4);

#elif defined EXPERIMENT_1_5

  keypad_poll(KEY_STATE_5);

#elif defined EXPERIMENT_1_6

  keypad_poll(KEY_STATE_6);

#elif defined EXPERIMENT_1_7

  keypad_poll(KEY_STATE_7);

#elif defined EXPERIMENT_1_8

  keypad_poll(KEY_STATE_8);

#elif defined EXPERIMENT_1_9

  keypad_poll(KEY_STATE_9);

#elif defined EXPERIMENT_1_10

  keypad_poll(KEY_STATE_10);

#elif defined EXPERIMENT_1_11

  keypad_poll(KEY_STATE_11);

#else

#error "Invalid experiment identifier"

#endif

  return 0;
}
