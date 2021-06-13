# Blink Led - State Machine

<p align="center">
  <img src="https://user-images.githubusercontent.com/62313672/121821638-9dc0e500-cc70-11eb-9f96-79a433654568.gif" width="50%">
</p>

</br>

## Context

Hi! This is my final project from the course  "Introductory to digital system", at university.

The aim of the course was to understand computer architecture, i.e, logical arithmetic unity, types of memories, input/output and use its set of instructions through the [assembly langague](https://en.wikipedia.org/wiki/Assembly_language).

Throughout the semester we learned about the microchip ATmega328p architecture, how to use its [set of intructions](https://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-0856-AVR-Instruction-Set-Manual.pdf) to perform math, store and retrieve data from the stack, EEPROM and SRAM, manipulate its general purpose registers, control external ports and use the interrupt verctor.

</br>

## Project

Regarding the assembly language, it wasn't so complex, we had to program a finite-state machine in which a LED could blink with three different frequencies, 1 hz, 0.5 hz and 0.25 hz.

In a previous assignment we developed a short script that takes approximately 1 second from start to end, using only basic instructions such as, load bytes to memory, increment a variable and loops. That script was our base to get the three different frequencies required to the LED blinking states.

</br>

#### Final circuit design:
It is necessary to use a switch debounce circuit to avoid detecting more than one click when the button is pressed.

The image below shows a common circuit and what happens when the button is pressed:


<p align="center">
  <img src="https://user-images.githubusercontent.com/62313672/121822466-97813780-cc75-11eb-9a5d-435d7b95ccc6.jpg" width="50%">
</p>

</br>

To implemented the debounce circuit we used:
- 19 kΩ registor
- HD74LS14, Schmitt Trigger Inverters
- Button
- 1 µF capacitor

And this was the final circuit:

<p align="center">
  <img src="https://user-images.githubusercontent.com/62313672/121821753-6a328a80-cc71-11eb-9f87-74b368f7d2e8.png" width="60%">
</p>
