#ifndef KEYPAD_H
#define KEYPAD_H

#include <stdint.h>

#define PIN_LEN     4
#define NB_KEYS     16

typedef uint16_t key_state_t;

/* The following sequence of key states covers all the possible execution paths
 * in the keypad_poll function.
 */
#define KEY_STATE_1  0x00
#define KEY_STATE_2  0x01
#define KEY_STATE_3  0x01
#define KEY_STATE_4  0x00
#define KEY_STATE_5  0x02
#define KEY_STATE_6  0x00
#define KEY_STATE_7  0x04
#define KEY_STATE_8  0x00
#define KEY_STATE_9  0x08
#define KEY_STATE_10 0x00
#define KEY_STATE_11 0x10

void keypad_init(void);

int keypad_poll(key_state_t new_key_state);

#endif
