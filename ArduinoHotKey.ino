/*
 * ArduinoHotKey Sketch.
 * 
 * Hotkey-Keyboard for up to 8 Buttons on an Arduino Pro Nano (Atmega32)
 * 
 * Requires the HID-Project library:
 *  https://www.arduinolibraries.info/libraries/hid-project
 *  
 */

#include "HID-Project.h"

// -------------------------
// Tweak your paramters here
// -------------------------

#define NUM_BUTTONS (8)
#define BUTTON_INDEX_OFFSET (2)
#define BUTTON_DISTANCE (1)

#define BUTTON_PRESSED(x) (x == LOW)

#define USE_SERIAL_DEBUG (0)

// ----------------------------------------------------------
// Stop Tweaking paramters here and continue tweaking actions
// below.
// ----------------------------------------------------------


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


// -------------------------
// Tweak your actions here
// -------------------------

  switch (buttonIndex) {
    /* Top row */
    case 7:
      singleButtonConsumer(buttonValue, MEDIA_PREVIOUS);
      break;
    case 4:
      singleButtonConsumer(buttonValue, MEDIA_STOP);
      break;
    case 2:
      singleButtonConsumer(buttonValue, MEDIA_PLAY_PAUSE);
      break;
    case 0:
      singleButtonConsumer(buttonValue, MEDIA_NEXT);
      break;

    /* Bottom Row */
    case 6:
      if (BUTTON_PRESSED(buttonValue)) {
        // button pressed
        // Skype Global Mute/Unmute Hotkey
        Keyboard.press(KEY_LEFT_CTRL);
        Keyboard.press(KEY_F4);
        releaseAllWithDelay();
      }
      break;
    case 5:
      if (BUTTON_PRESSED(buttonValue)) {
        // Microsoft Teams Global Mute/Unmute Hotkey
        Keyboard.press(KEY_LEFT_CTRL);
        Keyboard.press(KEY_LEFT_SHIFT);
        Keyboard.press(KEY_M);
        releaseAllWithDelay();
      }
      break;

    case 3:
      // Volume Down
      singleButtonConsumer(buttonValue, MEDIA_VOL_DOWN);
      break;
      
    case 1:
      // Volume Up
      singleButtonConsumer(buttonValue, MEDIA_VOL_UP);
  }
  // -------------------------------
  // Stop tweaking your actions here
  // -------------------------------
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
