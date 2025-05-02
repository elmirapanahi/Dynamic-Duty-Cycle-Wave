# Dynamic-Duty-Cycle-Wave
Microcontroller  / sixth semester of my undergraduate program

This is a program to generate pulses on pin PortB.5 of ATmega 64 with a constant frequency of 1 kHz and an initial duty cycle of 20%.
Every 1 second, increases the duty cycle by 5% until it reaches 80%.
After that, decreases it by 5% every second until it reaches 20% again.
Thus, the duty cycle continuously oscillates between 20% and 80%.
Assuming the clock frequency is 4.096 MHz.
