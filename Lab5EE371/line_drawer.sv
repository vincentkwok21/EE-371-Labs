/* Given two points on the screen this module draws a line between
 * those two points by coloring necessary pixels
 *
 * Inputs:
 *   clk    - should be connected to a 50 MHz clock
 *   reset  - resets the module and starts over the drawing process
 *	 x0 	- x coordinate of the first end point
 *   y0 	- y coordinate of the first end point
 *   x1 	- x coordinate of the second end point
 *   y1 	- y coordinate of the second end point
 *
 * Outputs:
 *   x 		- x coordinate of the pixel to color
 *   y 		- y coordinate of the pixel to color
 *   done	- flag that line has finished drawing
 *
 */
module line_drawer(clk, reset, x0, y0, x1, y1, x, y, done);
	input logic clk, reset;
	input logic [10:0]	x0, y0, x1, y1;
	output logic done;
	output logic [10:0]	x, y;
	
	/* You'll need to create some registers to keep track of things
	 * such as error and direction.
	 */
	logic signed [11:0] error, dx, dy;
	logic isSteep;
	logic signed [10:0] ystep;
	logic signed [10:0] tx0, tx1, ty0, ty1,  tdx, tdy, absdx, absdy, nextX, nextY;
	
	// creates states 
	enum {checkSteep, checkBackwards, startDraw, isDrawing} ps, ns;
	
	// calculates the absolute values based on input to calculate if line is steep
	always_comb begin
		dx = x1 - x0;
		dy = y1 - y0;
		
		absdx = dx[11] ? -dx[10:0] : dx[10:0];
		absdy = dy[11] ? -dy[10:0] : dy[10:0];
	
		isSteep = (absdy > absdx);
	end
	
	always_ff @(posedge clk) begin
		if(reset) begin
			error <= 0;
			
			nextX <= 0;
			nextY <= 0;
			
			ns <= checkSteep;
		end
		else begin
		
			// if inputs are steep, swaps x and y
			if(ps == checkSteep) begin
				done <= 1'b0;
				if(isSteep) begin
					tx0 <= y0;
					tx1 <= y1;
					ty0 <= x0;
					ty1 <= x1;
				end
				else begin
					tx0 <= x0;
					tx1 <= x1;
					ty0 <= y0;
					ty1 <= y1;
				end
				
				ns <= checkBackwards;
			end
			
			// if x0 > x1, then it swaps x1 and x0, y1 and y0
			if(ps == checkBackwards) begin
				if(tx0 > tx1) begin
					tx0 <= tx1;
					ty0 <= ty1;
					tx1 <= tx0;
					ty1 <= ty0;
				end
				
				ns <= startDraw;
			end
			
			// calculates new dx and dy after checking steep and backwards
			// sets error and ystep
			if(ps == startDraw) begin
				if(ty0 < ty1) begin
					ystep <= 1;
					tdy <= ty1 - ty0;
				end
				else begin
					ystep <= -1;
					tdy <= ty0 - ty1;
				end
				
				tdx <= tx1 - tx0;
				error <= -((tx1 - tx0) / 2);		
					
				nextX <= tx0;
				nextY <= ty0;
				
				ns <= isDrawing;
			end
			
			// loops through from x0 to x1, drawing each pixel
			if(ps == isDrawing) begin
				// done condition
				if(nextX == tx1 + 1) begin
					ns <= checkSteep;
					done <= 1'b1;
					
				end else begin
				
					if(isSteep) begin
						x <= nextY;
						y <= nextX;
					end
					else begin
						x <= nextX;
						y <= nextY;	
					end
				
					nextX <= nextX + 1;
					
					if((error + tdy) >= 0) begin
						error <= error + tdy - tdx;
						nextY <= nextY + ystep;
					end else begin 
						error <= error + tdy;
					end
				end
			end
		
		// always updates state
		ps <= ns;
		
		end
		
	end
	
endmodule  // line_drawer

module line_drawer_testbench ();
	logic clk, reset;
	logic [10:0]	x0, y0, x1, y1;
	logic [10:0]	x, y;
	logic done;
	
	line_drawer dut (.*);

	parameter CLOCK_PERIOD = 300;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

	integer i;
	initial begin
		
	reset <= 1; 
	x0 <= 11'd0; y0 <= 11'd0; x1 <= 11'd100;  y1  <= 11'd20; @(posedge clk);
	reset <= 0;
	
	for (i = 0; i < 100; i++) begin
		@(posedge clk);
	end

	$stop();
	end
endmodule 