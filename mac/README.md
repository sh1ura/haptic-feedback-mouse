Companion program running on Mac.

1. Change the definition of serial port device, such as "/dev/wchusbserial1440", used to flash from Arduino IDE
2. Compile on a command line, `cc -o haptic haptic.m -framework Cocoa`
3. After connecting Arduino nano to USB, then run the binary, `./haptic`
