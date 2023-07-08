# EE-371-Labs
Labs for the UW class EE371.
All labs use LabsLand, a virtual FPGA simulator that runs like a normal FPGA. There are also options to include a GPIO and display screen for visual
outputs

A basic summary of each lab is included below:


Lab 1: FSM diagram review, create a parking lot occupancy counter. Increases displayed value when a car enters and decrements displayed value when a car exits, able to differentiate between cars and pedestrians as well as invalid sequences. [Report](https://github.com/vincentkwok21/EE-371-Labs/blob/main/Lab1EE371/EE%20371%20Lab%201.pdf)

Lab 2: Introducing using RAM, be able to create RAM files that are capable of reading and writing as well as switching the targetted RAM that is being written and read from. Introduces multiple ways to introduce RAM modules in SystemVerilog. [Report](https://github.com/vincentkwok21/EE-371-Labs/blob/main/Lab2EE371/EE%20lab2.pdf)

Lab 3: Introduces creating a musical output with FPGA using audio codec. We were tasked to play audio off a .mif file and
convert our own sounds to .mif files using python script. Then we made a infite impulse response averaging filter using a fifo buffer to reduce noise. [Report](https://github.com/vincentkwok21/EE-371-Labs/blob/main/Lab3EE371/Lab%203/EE%20371%20Lab%203.pdf)

Lab 4: Introduces ASMD design to model datapath and controller modules in System Verilog on FPGA. Implement common programming algorithms The first task involves a counter. Given a 8 bit sequence input, display the number of ones. The second task required implementation of a binary search alogrithm which searches a 32X8 RAM module for the value specified by a 8 bit value given by the user. [Report](https://github.com/vincentkwok21/EE-371-Labs/blob/main/Lab4EE371/Lab%204%20Report%20EE%20371.pdf)

Lab 5: This lab documentation was unfinished as it was not needed to be completely finished but it introduces using VGA terminals to create graphics. By using Bresenham's line algorithm, a line can be drawn on a pixel display, which we demoed to be able to do lines from any slope and direction. [Report](https://docs.google.com/document/d/16dd7YjBd8TwkSAIh8qIr3GHYaSALW6QlMqiq55PwuFU/edit?usp=sharing)
