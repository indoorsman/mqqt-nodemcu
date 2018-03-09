# NodeMCU

## Download Image

* https://nodemcu.readthedocs.io/en/master/en/build/

## Write image

* https://nodemcu.readthedocs.io/en/master/en/flash/
* https://github.com/espressif/esptool (pip install esptool)


## Upload image to nodeMCU (http://daker.me/2016/08/flashing-lolin-v3-nodemcu-firmware.html)

* Download Image
* Download software for write image
	* esptool.py --port /dev/ttyUSB0 --baud 9600 write_flash --flash_mode qio --flash_size 32m --flash_freq 40m 0x00000 nodemcu-dev-16-modules-2018-03-06-00-26-38-integer.bin

## IDE to code

* List -  http://www.esp8266.com/viewforum.php?f=22
* ESPlorer - https://esp8266.ru/esplorer

## Settings

* Baud 115200


## Links

* https://learn.adafruit.com/diy-esp8266-home-security-with-lua-and-mqtt/programming-the-esp8266-with-lua
* https://learn.adafruit.com/adafruit-huzzah-esp8266-breakout/using-nodemcu-lua

## Chanels MQQT

* /ledsON -> Receive as parameter the port number
* /ledsOFF -> Receive as parameter the port number

## Movie

* https://www.youtube.com/watch?v=YyJ7ebBESNo