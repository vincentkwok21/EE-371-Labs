/* Top level module of the FPGA that takes the onboard resources 
 * as input and outputs the lines drawn from the VGA port.
 *
 * Inputs:
 *   KEY 			- On board keys of the FPGA
 *   SW 			- On board switches of the FPGA
 *   CLOCK_50 		- On board 50 MHz clock of the FPGA
 *
 * Outputs:
 *   HEX 			- On board 7 segment displays of the FPGA
 *   LEDR 			- On board LEDs of the FPGA
 *   VGA_R 			- Red data of the VGA connection
 *   VGA_G 			- Green data of the VGA connection
 *   VGA_B 			- Blue data of the VGA connection
 *   VGA_BLANK_N 	- Blanking interval of the VGA connection
 *   VGA_CLK 		- VGA's clock signal
 *   VGA_HS 		- Horizontal Sync of the VGA connection
 *   VGA_SYNC_N 	- Enable signal for the sync of the VGA connection
 *   VGA_VS 		- Vertical Sync of the VGA connection
 */
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign LEDR[8:0] = SW[8:0];
	
	logic [10:0] x0, y0, x1, y1, x, y;
	logic color, reset;
	
	VGA_framebuffer fb (
		.clk50			(CLOCK_50), 
		.reset			(1'b0), 
		.x, 
		.y,
		.pixel_color	(color), 
		.pixel_write	(1'b1),
		.VGA_R, 
		.VGA_G, 
		.VGA_B, 
		.VGA_CLK, 
		.VGA_HS, 
		.VGA_VS,
		.VGA_BLANK_n	(VGA_BLANK_N), 
		.VGA_SYNC_n		(VGA_SYNC_N));
				
	logic done, startClear;

	line_drawer lines (.clk(CLOCK_50), .reset(reset), .x0, .y0, .x1, .y1, .x, .y, .done);
	
	// sets up clock divider for a rate of 0.75 Hz
	logic [31:0] div_clk; 
	
	parameter whichClock = 24; // 0.75 Hz clock 
	clock_divider cdiv (.clock(CLOCK_50),  
                       .reset(reset),  
                       .divided_clocks(div_clk));

	// creates a new clock to be used to increment count
	logic slowClk; 
	assign slowClk = div_clk[whichClock];
	
	enum {clear, left, right, neg, pos, steep, shallow, horiz, vert} ps, ns;
	
	assign reset = (ps == clear);
	
	
	always_ff @(posedge CLOCK_50) begin
		if(reset) begin
			x0 <= 0;
			x1 <= 0;
			y0 <= 0;
			y1 <= 480;
			ns <= clear;
		end else if(ps == clear) begin
			
			case (ps)
				clear : begin
							color <= 1'b0;
							y0 <= 0;
							y1 <= 480;
							
							if(x0 < 641) begin
								if(done) begin
									x0 <= x0 + 1;
									x1 <= x1 + 1;
								end
							end 
						end 
				left : begin
							x0 <= 400;
							y0 <= 400;
							x1 <= 50;
							y1 <= 50;
							ns <= right;
						 end
				right : begin
							x0 <= 0;
							y0 <= 0;
							x1 <= 240;
							y1 <= 240;
							ns <= neg;
						 end
				neg : begin
							x0 <= 400;
							y0 <= 50;
							x1 <= 100;
							y1 <= 340;
							ns <= pos;
						 end
				pos : begin
							x0 <= 50;
							y0 <= 400;
							x1 <= 200;
							y1 <= 50;
							ns <= steep;
						 end
				steep : begin
							x0 <= 50;
							y0 <= 50;
							x1 <= 100;
							y1 <= 400;
							ns <= shallow;
						 end
				shallow : begin
							x0 <= 50;
							y0 <= 50;
							x1 <= 400;
							y1 <= 100;
							ns <= horiz;
						 end
				horiz : begin
							x0 <= 50;
							y0 <= 50;
							x1 <= 300;
							y1 <= 50;
							ns <= vert;
						 end
				vert : begin
							x0 <= 50;
							y0 <= 50;
							x1 <= 50;
							y1 <= 300;
							ns <= left;
						 end
			endcase
			
		end
	
	end
	
	
	always_ff @(posedge slowClk) begin
		
		if(ps == clear)
			ps <= ns;
		else begin
			ps <= clear;
		end
		
	end
	
	assign LEDR[9] = done;

endmodule  // DE1_SoC
