module Lab4t2(CLOCK_50, SW, KEY, LEDR, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
	input CLOCK_50; // 50 Mhz internal clock
	input [9:0] SW; // 10 external switches
	input [3:0] KEY; // 4 external keys
	output [9:0] LEDR; // 10 built in LEDs
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; // 6 Hex displays

	logic Ready;
	logic [3:0] Result;
	
	Lab4Task2 t2 (.Start(KEY[3]), .Reset(KEY[0]), .clk(CLOCK_50), .Input(SW[7:0]), .Ready, .Done(LEDR[9]), .Found(LEDR[0]));
	
	seg7 h0 (.hex(Result), .leds(HEX0));
	seg7 h1 (.hex(4'b0000), .leds(HEX1));
	seg7 h2 (.hex(4'b0000), .leds(HEX2));
	seg7 h3 (.hex(4'b0000), .leds(HEX3));
	seg7 h4 (.hex(4'b0000), .leds(HEX4));
	seg7 h5 (.hex(4'b0000), .leds(HEX5));
	
endmodule 