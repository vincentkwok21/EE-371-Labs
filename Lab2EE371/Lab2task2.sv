/***
*
*	Lab2task2 module, used t instantiate 32x3 ram file
*	SW[8:4] controls wraddress, SW[3:1] controls Din, SW[0] controls wren
*	takes in CLOCK_50, SW, KEY as inputs
*	outputs HEX display
*
*
***/

module Lab2task2 (CLOCK_50, SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input CLOCK_50; // 50 Mhz internal clock
	input [9:0] SW; // 10 external switches
	input [3:0] KEY; // 4 external keys
	output [9:0] LEDR; // 10 built in LEDs
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; // 6 Hex displays
	
	logic [2:0] DataOut;
	
	// instantiates ram
	task2RAM dut (.address(SW[8:4]), .CLOCK_50(CLOCK_50), .data(SW[3:1]), .wren(SW[0]), .q(DataOut));
		
	// instantiates hex display
	seg7 h5 (.hex({3'b000, SW[8]}), .leds(HEX5));
	seg7 h4 (.hex(SW[7:4]), .leds(HEX4));
	seg7 h1 (.hex(SW[3:1]), .leds(HEX1));
	seg7 h0 (.hex(DataOut), .leds(HEX0));
	
endmodule 