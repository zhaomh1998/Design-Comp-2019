# Flash bootloader to mega328P
### Flash Arduino ISP
Flash the code to Arduino Mega, then make the following connection:
### Connect programming circuit
Mega ---- 328P

10 ---- RST

50 ---- 12(MISO)

51 ---- 11(MOSI)

53 ---- 13(SCK)

GND ---- GND

5V ---- VCC

Then, connect a 100uF capacitor from Mega's RST (-) to Mega's 5V (+)

### Burn Bootloader
In Arduino IDE, choose board choose `Arduino Pro or Pro Mini`, then under programmer choose `Arduino as ISP`, then click `Burn Bootloader`.

### Done
Remember to change the programmer back to `AVRISP MKII`
