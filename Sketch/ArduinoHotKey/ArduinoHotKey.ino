/*
  ArduinoHotKey Sketch.
*/

#include "Keyboard.h"

#define NUM_BUTTONS (1)
#define BUTTON_INDEX_OFFSET (2)

#define BUTTON_PRESSED(x) (x == LOW)

uint8_t buttonState[NUM_BUTTONS];

void setup() {
  // Start Keyboard library
  Keyboard.begin();

  // Configure all IO pins.
  for (uint8_t i = 0; i < NUM_BUTTONS; ++i) {
    buttonState[i] = HIGH;
    pinMode(i + BUTTON_INDEX_OFFSET, INPUT);
  }
}

/**
 * \brief Add processing for actual button presses here.
 * \param buttonIndex The number of the button that was pressed/released.
 * \param buttonValue LOW when the button was pressend, HIGH when the button is released.
 */
void processEdge(uint8_t buttonIndex, uint8_t buttonValue) {
  switch (buttonIndex) {
    case 0:
      if (BUTTON_PRESSED(buttonValue)) {
        // button pressed
        //Keyboard.write('!');
        Keyboard.press(KEY_LEFT_GUI);
        Keyboard.press(KEY_F4);
        delay(500);
        Keyboard.releaseAll();
      }
      break;
  }
}

void loop() {
  // Iterate all configured IO pins.
  for (uint8_t i = 0; i < NUM_BUTTONS; ++i) {
    // Read pin value.
    uint8_t value = digitalRead(i + BUTTON_INDEX_OFFSET);
    if (value != buttonState[i]) {
      // On state change, perform an action.
      processEdge(i, value);
      buttonState[i] = value;
    }
  }
}
