`timescale 1 ps / 1 ps

/***
*
*	Lab2task3 module, used two instantiate dual 32x3 ram file
* 	creates one ram module from mif file (task 3), and one empty ram from task 2
* 	SW9 toggles between rams, with off being the task 2 ram
*	SW[8:4] controls wraddress, SW[3:1] controls Din, SW[0] controls wren
*	takes in CLOCK_50, SW, KEY as inputs
*	outputs HEX display
*
*
***/
module Lab2task3 (CLOCK_50, SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input logic CLOCK_50; // 50 Mhz internal clock
	input logic [9:0] SW; // 10 external switches
	input logic [3:0] KEY; // 4 external keys
	output logic [9:0] LEDR; // 10 built in LEDs
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; // 6 Hex displays
	
	logic [2:0] Din, DoutT2, DoutT3, DataOut;
	
	logic [4:0] wraddress, count;
	logic whichMem, wren;
	
	assign Din = SW[3:1];
//	assign count = SW[8:4];
	
	
	// sets up clock divider for a rate of 0.75 Hz
	logic [31:0] div_clk; 
	
	parameter whichClock = 25; // 0.75 Hz clock 
	clock_divider cdiv (.clock(CLOCK_50),  
                       .reset(reset),  
                       .divided_clocks(div_clk));

	// creates a new clock to be used to increment count
	logic slowClk; 
	assign slowClk = div_clk[whichClock];
	
	// Muxes to select between the output of task 2 and task 3 memory registers				  
	mux2_1 Doutmux (.out(DataOut[0]), .i0(DoutT2[0]), .i1(DoutT3[0]), .sel(SW[9]));
	mux2_1 Doutmux2 (.out(DataOut[1]), .i0(DoutT2[1]), .i1(DoutT3[1]), .sel(SW[9]));
	mux2_1 Doutmux3 (.out(DataOut[2]), .i0(DoutT2[2]), .i1(DoutT3[2]), .sel(SW[9]));
	
	// instantiates task 2
	task2RAM t2 (.address(count), .CLOCK_50(CLOCK_50), .data(Din), .wren(~SW[9] & SW[0]), .q(DoutT2));
	
	// instantiates task 3
	ram32x3port2 t3 (.clock(CLOCK_50), .data(Din), .rdaddress(count), .wraddress(SW[8:4]), .wren(SW[9] & SW[0]), .q(DoutT3));

	seg7 h5 (.hex({3'b000, SW[8]}), .leds(HEX5)); // Hex 5, displays wraddress
	seg7 h4 (.hex(SW[7:4]), .leds(HEX4));			 // Hex 4, displays wraddress
	seg7 h3 (.hex({3'b000, count[4]}), .leds(HEX3)); // Hex3, displays rdaddress
	seg7 h2 (.hex(count[3:0]), .leds(HEX2)); // Hex 2, displays rdaddress
	seg7 h1 (.hex(SW[3:1]), .leds(HEX1));	// Hex 1, displays Data in
	seg7 h0 (.hex(DataOut), .leds(HEX0)); // Hex 0, displays data out
	
	// increments count
	always_ff @(posedge slowClk) begin
		if(~KEY[0]) begin
			count = 5'b00000;
		end else begin
			count = count + 1'b1;
		end
	end
	
	
endmodule 


module Lab2task3_testbench();
	logic         clock;   
	logic  [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;    
	logic  [9:0]  LEDR;     
	logic  [3:0]  KEY; 
	logic  [9:0]  SW; 
	
	logic [4:0] address;
	logic [2:0] data;
	logic whichMem, wren;
	
	assign SW[3:1] = data[2:0];
	assign SW[8:4] = address;
	assign SW[0] = wren;
	assign SW[9] = whichMem;
	
	Lab2task3 L2T3 (.CLOCK_50(clock), .SW, .KEY, .LEDR, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5);
	
	
	// Set up a simulated clock.   
	parameter CLOCK_PERIOD=100; 

	initial begin   
		clock <= 0;  
		forever #(CLOCK_PERIOD/2) clock <= ~clock; // Forever toggle the clock 
	end  
	
	integer i;
		
	// Test the design. 
	initial begin 
		address[4:0] = 5'b00000; data[2:0] = 3'b000; wren = 1'b0; whichMem = 1'b1; @(posedge clock);
		
		// Runs through all addresses of the ram module from task 3 to show its been initialized
		for(i = 0; i < 32; i++) begin
			address = address + 1'b1; @(posedge clock);			
			
		end
		
	
		// Runs through all addresses of task 2 ram module to show its empty
		
		whichMem = 1'b0;
		
		for(i = 0; i < 32; i++) begin
			address = address + 1'b1; @(posedge clock);			
			
		end
		
		address[4:0] = 5'b00001; data[2:0] = 3'b111; wren = 1'b0; whichMem = 1'b0; @(posedge clock);
		address[4:0] = 5'b00001; data[2:0] = 3'b111; wren = 1'b1; whichMem = 1'b0; @(posedge clock);
		address[4:0] = 5'b00001; data[2:0] = 3'b111; wren = 1'b0; whichMem = 1'b0; @(posedge clock);
																											@(posedge clock);
		address[4:0] = 5'b00001; data[2:0] = 3'b111; wren = 1'b0; whichMem = 1'b1; @(posedge clock);
		address[4:0] = 5'b00001; data[2:0] = 3'b111; wren = 1'b0; whichMem = 1'b1; @(posedge clock);
		address[4:0] = 5'b00001; data[2:0] = 3'b111; wren = 1'b0; whichMem = 1'b0; @(posedge clock);
																											@(posedge clock);

																									
	
	$stop; // End the simulation.  
	end   
	

endmodule 