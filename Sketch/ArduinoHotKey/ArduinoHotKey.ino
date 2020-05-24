/*
  ArduinoHotKey Sketch.
*/

#include "HID-Project.h"

#define NUM_BUTTONS (8)
#define BUTTON_INDEX_OFFSET (2)
#define BUTTON_DISTANCE (1)

#define BUTTON_PRESSED(x) (x == LOW)

#define USE_SERIAL_DEBUG (0)

uint8_t buttonState[NUM_BUTTONS];

constexpr uint8_t buttonIndexToPin(const uint8_t buttonIndex) {
  return BUTTON_INDEX_OFFSET + (BUTTON_DISTANCE * buttonIndex);
}

void setup() {
#if (USE_SERIAL_DEBUG == 1)
  Serial.begin(115200);
  Serial.println("ArduinoHotKey ready.");
#endif
  
  // Start Keyboard library
  Consumer.begin(); // Media Keys
  Keyboard.begin(); // 'regular' Boot Keyboard

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

void singleButton(uint8_t keyValue, uint8_t keyCode) {
  if (BUTTON_PRESSED(keyValue)) {
    Keyboard.press(keyCode);
  } else {
    Keyboard.release(keyCode);
  }
}

void singleButtonConsumer(uint8_t keyValue, uint8_t keyCode) {
  if (BUTTON_PRESSED(keyValue)) {
    Consumer.press(keyCode);
  } else {
    Consumer.release(keyCode);
  }
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
    /* Top row */
    case 7:
      singleButtonConsumer(buttonValue, MEDIA_PREVIOUS  );
      break;
    case 4:
      singleButtonConsumer(buttonValue, MEDIA_STOP    );
      break;
    case 2:
      singleButtonConsumer(buttonValue, MEDIA_PLAY_PAUSE    );
      break;
    case 0:
      singleButtonConsumer(buttonValue, MEDIA_NEXT  );
      break;

    /* Bottom Row */
    case 6:
      if (BUTTON_PRESSED(buttonValue)) {
        // button pressed
        //Keyboard.write('!');
        Keyboard.press(KEY_LEFT_GUI);
        Keyboard.press(KEY_F4);
        releaseAllWithDelay();
      }
      break;
    case 5:
      if (BUTTON_PRESSED(buttonValue)) {
        Keyboard.press(KEY_LEFT_SHIFT);
      } else {
        Keyboard.release(KEY_LEFT_SHIFT);
      }
      break;

    case 3:
      if (BUTTON_PRESSED(buttonValue)) {
        Keyboard.press(KEY_LEFT_GUI);
        Keyboard.press(KEY_LEFT_CTRL);
        Keyboard.press(KEY_LEFT_ARROW);
        releaseAllWithDelay();
      }
      break;
      
    case 1:
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
