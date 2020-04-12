# ArduinoHotKey - An Arduino-Based USB Hotkey-Keyboard

This project started because I needed a dedicated button to mute/unmute myself in Voicecalls.
Mute/Unmute functionality is avilable as a Hotkey-Combination, but why pressm ore buttons than necessary?
This project will let you use an Arduino with an Atmega32u4 Processor (e.g., Arduino Pro Micro) to sond arbitrary Key sequences to a USB host device (such as your PC or Mac).
It can send all key sequences that the Arduino Keyboard Library can produce.

## Software

A simple Arduino sketch that can read a number of digital inputs and procude arbitrary key sequences on button press.
Customize the Code to configure the key sequence of your needs.

## Hardware

A simple PCB based around a bunch of Cherry MX PCB-mount switches and an Arduino Pro Micro. Includes Hardware-Deboundinc to be extra-fancy.
