# Smart LED lighting
This repository contains everything necessary to create an Arduino controlled lighting with address LED strip. Based on [FastSPI LED effects by teldredge](http://funkboxing.com/wordpress/?p=1366), [Tweaking4all article](https://www.tweaking4all.com/hardware/arduino/adruino-led-strip-effects) and [AlexGyver refactoring work<sup>[RU]<sup/>](https://alexgyver.ru/ws2812b-fx/). I included more refactoring and better COM-port control. Though, effects that I didn't like on my ride and a photoresistor were excluded. I've done this mostly for myself, but feel free to fork and edit as you wish!

## Project structure
- **FastLED-stm32patch** - library to control the WS2812 and similar address LED strips
- **led_strip_arduino** - Arduino sketch
  - *led_strip_arduino.ino* - main file, which contains all the global variables, constants, loop and setup methods
  - *effect_handler.ino* - this file contains methods for changing effects with the LED strip settings and performing them
  - *parser.ino* - there is a parsing method that receives a command from the serial port and transforms it into action
  - *strip_effects.ino* - this file contains all the effect methods
  - *utils.ino* - this file contains service methods just to keep code shorter and cleaner
  - *memory_manager.ino* - there are several methods to save and retrieve strip settings from EEPROM
- **scheme.jpg** - here is a scheme of the device, which represents how to connect everything to an Arduino Nano
- **led_strip_controller** - Android application written in Dart & Flutter which allows you to control your strip from your phone with Android 4.2 or higher via USB.
- **README.md** - the file you're reading right now :D

## Android app features
- Automatic USB connection
- Switching between 5 LED strip modes
- Toggling automatic LED strip mode switching
- Controlling color in RGB space

## App building note
Old Flutter 3.0.0 was used due to compatibility issues. This app was required to be capable of launching and running on a Honda Civic 2018 infotainment system, which has 512 MB of RAM and runs on Android 4.2.2. If needed, update Dart SDK constraints in `pubspec.yaml` to use newer version of Flutter (tested and debugged on a phone using Flutter 3.19.6).

## Scheme
![SCHEME](https://github.com/chapsan2001/smart_led_lighting/blob/master/scheme.png)

## Power consumption note
One LED consumes up to 0.06 amps, so if your LED strip is long, make sure your power supply can handle it and don't forget to include the diode in the circuit. It will prevent powering the strip from the USB, which supplies power to the Arduino. Also, make sure that voltage drop is not significant (use Schottky diodes), because EEPROM is used in the Arduino sketch, which is sensitive to voltage.
