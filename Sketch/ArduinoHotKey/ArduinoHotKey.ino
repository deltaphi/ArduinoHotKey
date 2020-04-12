/*
  ArduinoHotKey Sketch.
*/

#include "Keyboard.h"

#define NUM_BUTTONS (4)
#define BUTTON_INDEX_OFFSET (3)
#define BUTTON_DISTANCE (2)

#define BUTTON_PRESSED(x) (x == LOW)

#define USE_SERIAL_DEBUG (0)

uint8_t buttonState[NUM_BUTTONS];

constexpr buttonIndexToPin(const uint8_t buttonIndex) {
  return BUTTON_INDEX_OFFSET + (BUTTON_DISTANCE * buttonIndex);
}

void setup() {
#if (USE_SERIAL_DEBUG == 1)
  Serial.begin(9600);
  Serial.println("ArduinoHotKey ready.");
#endif
  
  // Start Keyboard library
  Keyboard.begin();

  // Configure all IO pins.
  for (uint8_t i = 0; i < NUM_BUTTONS; ++i) {
    buttonState[i] = HIGH;
    pinMode(buttonIndexToPin(i), INPUT);
  }

}

void releaseAllWithDelay() {
  delay(100);
  Keyboard.releaseAll();
}

/**
 * \brief Add processing for actual button presses here.
 * \param buttonIndex The number of the button that was pressed/released.
 * \param buttonValue LOW when the button was pressend, HIGH when the button is released.
 */
void processEdge(uint8_t buttonIndex, uint8_t buttonValue) {
#if (USE_SERIAL_DEBUG == 1)
  Serial.print(F("Button "));
  Serial.print(buttonIndex);
  Serial.print(F(" was "));
  if (BUTTON_PRESSED(buttonValue)) {
    Serial.println(F("pressed."));
  } else {
    Serial.println(F("released."));  
  }  
#endif

  switch (buttonIndex) {
    case 0:
      if (BUTTON_PRESSED(buttonValue)) {
        // button pressed
        //Keyboard.write('!');
        Keyboard.press(KEY_LEFT_GUI);
        Keyboard.press(KEY_F4);
        releaseAllWithDelay();
      }
      break;
    case 1:
      if (BUTTON_PRESSED(buttonValue)) {
        Keyboard.press(KEY_LEFT_SHIFT);
      } else {
        Keyboard.release(KEY_LEFT_SHIFT);
      }
      break;

    case 2:
      if (BUTTON_PRESSED(buttonValue)) {
        Keyboard.press(KEY_LEFT_GUI);
        Keyboard.press(KEY_LEFT_CTRL);
        Keyboard.press(KEY_LEFT_ARROW);
        releaseAllWithDelay();
      }
      break;
      
    case 3:
      if (BUTTON_PRESSED(buttonValue)) {
        Keyboard.press(KEY_LEFT_GUI);
        Keyboard.press(KEY_LEFT_CTRL);
        Keyboard.press(KEY_RIGHT_ARROW);
        releaseAllWithDelay();
      }
      break;
  }
}

void loop() {
  // Iterate all configured IO pins.
  for (uint8_t i = 0; i < NUM_BUTTONS; ++i) {
    // Read pin value.
    uint8_t value = digitalRead(buttonIndexToPin(i));
    if (value != buttonState[i]) {
      // On state change, perform an action.
      processEdge(i, value);
      buttonState[i] = value;
    }
  }
  
}
