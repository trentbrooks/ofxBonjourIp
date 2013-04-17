## ofxBonjourIp ##
This addon uses Bonjour just to find ip addresses of ios devices on the same network and that's it. Example broadcasts itself and looks for other devices (only 1 atm). To test run example on your device (iphone/ipad) and in the simulator, or on desktop.

Not setup for network comms- Bonjour streams are ugly. Use OSC, UDP or TCP instead (more OF friendly).

Works with ios and osx. Uses CFNetServices (https://developer.apple.com/library/mac/#documentation/CoreFoundation/Reference/CFNetServiceRef/Reference/reference.html) instead of NSNetServices, as this is recommended for C and C++ applications. So no need to rename .cpp files to .mm or anything. Ios examples needs the CFNetwork framework added to your project (see ofxBonjourIp.h for instructions).

-Trent Brooks