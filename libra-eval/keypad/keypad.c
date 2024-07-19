#include "keypad.h"
#include "marker.h"

static key_state_t key_state = 0;
static int         pin_idx   = 0;
static int         keymap[NB_KEYS] =
  {'1','4','7','0','2','5','8','F','3','6','9','E','A','B','C','D'};

/* Put the pin in a dedicated section so that it can be found when evaluating
 * the correctness of the hardened forms.
 */
static volatile char pin[PIN_LEN];

void keypad_init(void)
{
  key_state = 0;
  pin_idx   = 0;
}

/*
 * The start-to-end timing of this function only reveals the number of times the
 * if statement was executed (i.e. the number of keys that were down), which is
 * also explicitly returned. By carefully interrupting the function each for
 * loop iteration, an untrusted ISR can learn the value of the secret PIN code.
 */
int keypad_poll(key_state_t new_key_state)
{
  int key_mask = 0x1;

  /* Store down keys in private PIN array. */
  for (int key = 0; key < NB_KEYS; key++)
  {
    int is_pressed  = (new_key_state & key_mask);
    int was_pressed = (key_state & key_mask);

    /* Begin of sensitive region */ MARK(1);

    if ( is_pressed /* INTERRUPT SHOULD ARRIVE HERE */
         && !was_pressed && (pin_idx < PIN_LEN))
    {
      pin[pin_idx++] = keymap[key];
    }
    /* .. OR HERE. */

    /* End of sensitive region */ MARK(2);

    key_mask = key_mask << 1;
  }

  key_state = new_key_state;

  return (PIN_LEN - pin_idx);
}
