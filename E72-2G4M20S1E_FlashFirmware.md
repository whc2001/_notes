https://github.com/egony/cc2652p_E72-2G4M20S1E/wiki/Home-EN

https://www.youtube.com/watch?v=0XOozGlbU7U

## NOTE: Newer E72-2G4M20S1E already has Serial Bootloader enabled and can be flashed using BSL downloader directly without the need of JTAG.

# Flash with JTAG (J-Link + OpenOCD)

#### NOTE: This method may also be performed using the Raspberry Pi GPIO (change `jlink.cfg` to `raspberrypi2-native.cfg` according to the YouTube tutorial above), but I didn't succeed.

A genuine J-Link or a Chinese counterfeit should all work for this configuration. Connect according to the table and image below.

|Module Pin|JTAG Pin|Remark|
|-|-|-|
|JTAG_TMS|TMS||
|JTAG_TCK|TCK||
|DIO_16 (TDO)|TDO|TDO to TDO, unlike UART|
|DIO_17 (TDI)|TDI|TDI to TDI, unlike UART|
|VCC|VTref|VCC of External Power|
|GND|GND|GND of External Power|

![屏幕截图 2021-05-19 232023](https://user-images.githubusercontent.com/16266909/118839121-d3d0aa80-b8f8-11eb-9d07-8a71d0770ee5.png)

Install [OpenOCD](http://openocd.org/). On Windows, install WinUSB driver to J-Link using Zadig. 

Copy `scripts/board/ti_cc26x2_launchpad.cfg` to another directory, open with text editor. 
Comment out the line referencing configuration file of XDS110 debugger, change to config of J-Link.

```
#
# TI CC26x2 LaunchPad Evaluation Kit
#

# source [find interface/xds110.cfg]    # Comment this line
source [find interface/jlink.cfg]    # Add this line
adapter speed 5500    # Change to smaller if experiencing unstable connection , 4000 is generally acceptable
transport select jtag
source [find target/ti_cc26x2.cfg]
```

Run `openocd -f path/to/modified/ti_cc26x2_launchpad.cfg`, it should connect to the module without any ERROR log. A log saying something similar to `hardware has XX breakpoints, XX watchpoints` indicates a successful connection to the module.

Add some command to the same config file to flash the firmware:

```
#
# TI CC26x2 LaunchPad Evaluation Kit
#
#source [find interface/xds110.cfg]
source [find interface/jlink.cfg]
adapter speed 5500
transport select jtag
source [find target/ti_cc26x2.cfg]

init
program path/to/your/firmware.hex verify    # Change to your firmware file location
```

Run the same command again, the firmware should be flashed automatically. Don't forget to **POWER CYCLE** the device after the flashing process to get the firmware running.

# Flash with UART Bootloader

Connect according to the table and image below.

|Module Pin|USB to TTL UART Pin|Remark|
|-|-|-|
|DIO_12 (RX)|TX||
|DIO_13 (TX)|RX||
|VCC|3V3||
|GND|GND||
|DIO_15||Button to GND for Bootloader Triggering|
|nRESET||Button to GND for Reset|

![屏幕截图 2021-05-19 232951](https://user-images.githubusercontent.com/16266909/118840613-252d6980-b8fa-11eb-847d-0c22c238f373.png)

The bootloader triggering procedure is similar to ESP8266. Keep DIO_15 (GPIO0 on ESP8266) connected to ground, connect nRESET to ground once, then release DIO_15. 

If you connect buttons like the image above: hold `Bootloader` button, tap `Reset` button, then release `Bootloader` button.

Use [cc2538-bsl](https://github.com/JelmerT/cc2538-bsl), run: `cc2538-bsl -p COMx -w path/to/your/firmware.hex` (change the serial port number and firmware path according to your setup) and wait for the operation to finish. 

If error appears saying `Timeout waiting for ACK/NACK after 'Synch (0x55 0x55)'`, there is no response from the module. Check if you connected everything correctly and try the bootloader entering button sequence once again.
