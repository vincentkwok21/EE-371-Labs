`timescale 1 ps / 1 ps

/*****
*
*	Task 2
*
*	code to handle task 2, creates code to play note from memory
*	
*	takes in 1 bit CLOCK_50 for clock, as well as reset and write
*	outputs 24 bit dout, representing sample from memory
*
*****/
module task2 (CLOCK_50, reset, write, dout);
	input logic CLOCK_50, reset, write;
	output logic [23:0] dout;
	
	logic [15:0] addr;
	
	// initializes ram that stores the note, data and wren are not needed since its read only
	ram ramInit (.address(addr), .clock(CLOCK_50), .data(1'd0), .wren(1'b0), .q(dout));
	
	// hits block every time write is given
	always @(posedge write) begin
		if (reset)
			addr = 1'd0;
		else if (addr == 16'b1011101101111111) // resets address when it hits the end
			addr = 1'd0;
		else
			addr = addr + 1'b1; // increments address every write
	end

endmodule 


module task2_testbench();
	logic CLOCK_50, reset, write;
	logic [23:0] dout;

	task2 dut (.*);
	
	// Set up a simulated clock.   
	parameter CLOCK_PERIOD=100; 

	initial begin   
		CLOCK_50 <= 0;  
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock 
	end  
	
	
	initial begin
	
	CLOCK_50 = 1'b0; reset = 1'b0; write = 1'b0; @(posedge CLOCK_50);
	write = 1'b0; @(posedge CLOCK_50);
	write = 1'b1; @(posedge CLOCK_50);
	write = 1'b0; @(posedge CLOCK_50);
	write = 1'b1; @(posedge CLOCK_50);
	write = 1'b0; @(posedge CLOCK_50);
	write = 1'b1; @(posedge CLOCK_50);
	write = 1'b0; @(posedge CLOCK_50);
	write = 1'b1; @(posedge CLOCK_50);
	write = 1'b0; @(posedge CLOCK_50);
	write = 1'b1; @(posedge CLOCK_50);
	write = 1'b0; @(posedge CLOCK_50);
	write = 1'b1; @(posedge CLOCK_50);
	write = 1'b0; @(posedge CLOCK_50);
	write = 1'b1; @(posedge CLOCK_50);
	write = 1'b0; @(posedge CLOCK_50);
	write = 1'b1; @(posedge CLOCK_50);
	write = 1'b0; @(posedge CLOCK_50);
	write = 1'b1; @(posedge CLOCK_50);
	write = 1'b0; @(posedge CLOCK_50);
	write = 1'b1; @(posedge CLOCK_50);
	write = 1'b0; @(posedge CLOCK_50);
	write = 1'b1; @(posedge CLOCK_50);
	write = 1'b0; @(posedge CLOCK_50);
	write = 1'b1; @(posedge CLOCK_50);
	write = 1'b0; @(posedge CLOCK_50);
	write = 1'b1; @(posedge CLOCK_50);
	write = 1'b0; @(posedge CLOCK_50);
	write = 1'b1; @(posedge CLOCK_50);
	write = 1'b0; @(posedge CLOCK_50);
	
	
	
	$stop; // End the simulation.  
	end
	
endmodule 