`timescale 1 ps / 1 ps

/*****
*
*	Task 3
*
*	code to handle task 3, creates a filter from a fifo buffer and accumulator
*	returns two outputs represented filtered samples for left and right
*	takes in 1 bit inputs for CLOCK_50, reset, read_ready, write_ready
*	takes in 24 bit inputs for din_left, din_right
*	outputs 24 bit values for dout_left, dout_right
*
*****/


module task3 #(parameter N = 3)(CLOCK_50, reset, read_ready, write_ready, din_left, din_right, dout_left, dout_right);
	input logic signed [23:0] din_left, din_right;
	input logic CLOCK_50, reset, read_ready, write_ready;
	output logic [23:0] dout_left, dout_right;
	
	// creates 24 bit signed variables to hold data from different stages
	logic signed [23:0] divided_left, divided_right, accumulated_left, accumulated_right, fifo_left, fifo_right;
	logic empty, full, rd, wr; 
	
	// logic to account for first N-1 samples sent into filter
	logic [N:0] counter;
	logic first_N = 1'b1;
	
	// combination block to handle dividing the input, as well as read and write signals for the buffer
	always_comb begin
		divided_left = din_left >>> N;
		divided_right = din_right >>> N;
		
		if(first_N)
			rd = 1'b0; // doesnt read until buffer is full
		else
			rd = read_ready & write_ready; // reads from buffer when read and write are ready
			
		wr = read_ready & write_ready; // writes from buffer when read and write are ready
	end
	
	// creates left and right fifo buffers
	fifo #(.DATA_WIDTH(24), .ADDR_WIDTH(N)) leftBuffer (.clk(CLOCK_50), .reset(reset), .rd(rd), 
						  .wr(wr), .empty(empty), .full(full), .w_data(divided_left), .r_data(fifo_left));
	fifo #(.DATA_WIDTH(24), .ADDR_WIDTH(N)) rightBuffer (.clk(CLOCK_50), .reset(reset), .rd(rd), 
							.wr(wr), .empty(empty), .full(full), .w_data(divided_right), .r_data(fifo_right));
	
	
	always_ff @(posedge CLOCK_50) begin
		if(reset) begin // on reset clears accumulator and first_n counter
			first_N = 1'b1;
			counter = 1'd0;
			
			accumulated_left <= 1'd0;
			accumulated_right <= 1'd0;
			
			dout_left <= 1'd0;
			dout_right <= 1'd0;
			
		end else if (read_ready & write_ready) begin // only updates dout and accumulator when read and write occurs
			if(~first_N) begin
				counter = counter + 1'b1;
				if(counter == N-1)
					first_N = 1'b0;
			end
			
			dout_left <= accumulated_left + divided_left - fifo_left;
			dout_right <= accumulated_right + divided_right - fifo_right;
			
			accumulated_left <= accumulated_left + dout_left;
			accumulated_right <= accumulated_right + dout_right;
		
		end 
	
	end

endmodule 


module task3_testbench();
	logic signed [23:0] din_left, din_right;
	logic CLOCK_50, reset, read_ready, write_ready;
	logic [23:0] dout_left, dout_right;

	task3 dut (.*);
	
	// Set up a simulated clock.   
	parameter CLOCK_PERIOD=100; 

	initial begin   
		CLOCK_50 <= 0;  
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock 
	end  
	
	
	initial begin
	
		din_left = 24'b0; din_right = 24'b0; reset = 1'b0; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
		
		din_left = 24'd100; din_right = 24'd100; @(posedge CLOCK_50);
		din_left = 24'd100; din_right = 24'd100; read_ready = 1'b1; write_ready = 1'b1; @(posedge CLOCK_50);
		din_left = 24'd100; din_right = 24'd100; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
		din_left = 24'd900; din_right = 24'd900; @(posedge CLOCK_50);
		din_left = 24'd900; din_right = 24'd900; read_ready = 1'b1; write_ready = 1'b1; @(posedge CLOCK_50);
		din_left = 24'd900; din_right = 24'd900; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
		din_left = 24'd1000; din_right = 24'd1000; @(posedge CLOCK_50);
		din_left = 24'd1000; din_right = 24'd1000; read_ready = 1'b1; write_ready = 1'b1; @(posedge CLOCK_50);
		din_left = 24'd1000; din_right = 24'd1000; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
		din_left = 24'd10000; din_right = 24'd10000; @(posedge CLOCK_50);
		din_left = 24'd10000; din_right = 24'd10000; read_ready = 1'b1; write_ready = 1'b1; @(posedge CLOCK_50);
		din_left = 24'd10000; din_right = 24'd10000; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
		din_left = 24'd100000; din_right = 24'd100000; @(posedge CLOCK_50);
		din_left = 24'd100000; din_right = 24'd100000; read_ready = 1'b1; write_ready = 1'b1; @(posedge CLOCK_50);
		din_left = 24'd100000; din_right = 24'd100000; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
		din_left = 24'd1000000; din_right = 24'd1000000; @(posedge CLOCK_50);
		din_left = 24'd1000000; din_right = 24'd1000000; read_ready = 1'b1; write_ready = 1'b1; @(posedge CLOCK_50);
		din_left = 24'd1000000; din_right = 24'd1000000; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
		din_left = 24'd100000; din_right = 24'd100000; @(posedge CLOCK_50);
		din_left = 24'd100000; din_right = 24'd100000; read_ready = 1'b1; write_ready = 1'b1; @(posedge CLOCK_50);
		din_left = 24'd100000; din_right = 24'd100000; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
		din_left = 24'd10000; din_right = 24'd10000; @(posedge CLOCK_50);
		din_left = 24'd10000; din_right = 24'd10000; read_ready = 1'b1; write_ready = 1'b1; @(posedge CLOCK_50);
		din_left = 24'd10000; din_right = 24'd10000; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
		din_left = 24'd1000; din_right = 24'd1000; @(posedge CLOCK_50);
		din_left = 24'd1000; din_right = 24'd1000; read_ready = 1'b1; write_ready = 1'b1; @(posedge CLOCK_50);
		din_left = 24'd1000; din_right = 24'd1000; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
		din_left = 24'd900; din_right = 24'd900; @(posedge CLOCK_50);
		din_left = 24'd900; din_right = 24'd900; read_ready = 1'b1; write_ready = 1'b1; @(posedge CLOCK_50);
		din_left = 24'd900; din_right = 24'd900; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
		din_left = 24'd100; din_right = 24'd100; @(posedge CLOCK_50);
		din_left = 24'd100; din_right = 24'd100; read_ready = 1'b1; write_ready = 1'b1; @(posedge CLOCK_50);
		din_left = 24'd100; din_right = 24'd100; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
	
	$stop; // End the simulation.  
	end
	
endmodule 