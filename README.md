# Smart LED lighting
This repository contains everything necessary to create an Arduino controlled lighting with address LED strip. Based on [FastSPI LED effects by teldredge](http://funkboxing.com/wordpress/?p=1366), [Tweaking4all article](https://www.tweaking4all.com/hardware/arduino/adruino-led-strip-effects) and [AlexGyver refactoring work<sup>[RU]<sup/>](https://alexgyver.ru/ws2812b-fx/). I included more refactoring, Bluetooth control, better COM-port control. Though, effects that I didn't like on my table and a photoresistor were excluded. I've done this mostly for myself, but feel free to fork and edit as you wish!

## Project structure
- **FastLED-stm32patch** - library to control the WS2812 and similar address LED strips
- **led_strip_arduino** - Arduino sketch
  - *led_strip_arduino.ino* - main file, which contains all the global variables, constants, loop and setup methods
  - *effect_handler.ino* - this file contains methods for changing effects with the LED strip settings and performing them
  - *parser.ino* - there is a parsing method that receives a command from serial port and transforms it into action
  - *strip_effects.ino* - this file contains all the effect methods
  - *utils.ino* - this file contains service methods just to keep code shorter and cleaner
- **scheme.jpg** - here is a scheme of the device, which represents how to connect everything to an Arduino (in my case, Nano)
- **led_strip_controller** - Android application written in Dart & Flutter which allows you to control your strip from your phone with Android 8 or higher via Bluetooth (USB control is in development). APK will be released soon.
- **README.md** - the file you're reading right now :D

## Few words about memory
I am using an Arduino Nano, which has 30720 bytes of available flash memory and 2048 bytes of SRAM. Here is a table of memory consumption with certain features enabled or disabled.

|                           | Flash       | SRAM       |
|---------------------------|-------------|------------|
| No Bluetooth<br>No button | 12722 bytes | 1332 bytes |
| Bluetooth<br>No button    | 13208 bytes | 1332 bytes |
| No Bluetooth<br>Button    | 13036 bytes | 1336 bytes |
| Bluetooth<br>Button       | 13522 bytes | 1336 bytes |

There are 148 LEDs in my strip. One LED consumes 6 bytes of SRAM.

## Scheme
![SCHEME](https://github.com/chapsan2001/smart_led_lighting/blob/master/scheme.png)
