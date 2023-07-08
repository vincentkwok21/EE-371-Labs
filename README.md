# EE-371-Labs
Labs for the UW class EE371.
All labs use LabsLand, a virtual FPGA simulator that runs like a normal FPGA. There are also options to include a GPIO and display screen for visual
outputs

A basic summary of each lab is included below:


Lab 1: FSM diagram review, create a parking lot occupancy counter. Increases displayed value when a car enters and decrements displayed value when a car exits, able to differentiate between cars and pedestrians as well as invalid sequences.

Lab 2: Introducing using RAM, be able to create RAM files that are capable of reading and writing as well as switching the targetted RAM that is being written and read from. Introduces multiple ways to introduce RAM modules in SystemVerilog

Lab 3: Introduces creating a musical output with FPGA using audio codec. We were tasked to play audio off a .mif file and
convert our own sounds to .mif files using python script. Then we made a infite impulse response averaging filter using a fifo buffer to reduce noise.

Lab 4: Introduces ASMD design to model datapath and controller modules in System Verilog on FPGA. Implement common programming algorithms The first task involves a counter. Given a 8 bit sequence input, display the number of ones. The second task required implementation of a binary search alogrithm which searches a 32X8 RAM module for the value specified by a 8 bit value given by the user.

Lab 5: This lab documentation was unfinished as it was not needed to be completely finished but it introduces using VGA terminals to create graphics. By using Bresenham's line algorithm, a line can be drawn on a pixel display, which we demoed to be able to do lines from any slope and direction.
