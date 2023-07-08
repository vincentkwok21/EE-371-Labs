/*
	Main Module
	
	Is responsible for controlling the states of the FSM, and whether or not to increment
	or decrement the counter. It also calls another display module.
	
	Takes in CLOCK_50, Switch, and Key signals
	Outputs LEDR and HEX display signals

*/
// commented sections that represent code were used to run testbenches in the intial programming of this module
//module main(CLOCK_50, SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, V_GPIO);
module main(CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, V_GPIO);

	input CLOCK_50;
	//input [9:0] SW;
	//input [3:0] KEY;
	//output [9:0] LEDR;
	output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	reg clk, reset; // defines clock and reset variables
	inout logic [35:0] V_GPIO;
	assign V_GPIO[27] = V_GPIO[24]; // for a
	assign V_GPIO[31] = V_GPIO[28]; //for b
	
	assign clk = CLOCK_50; // assigns clock to internal clock
	//assign reset = SW[9]; //assigns reset to switch 9
	assign reset = V_GPIO[23];

	reg a, b; // a and b correspond to sensors, on state represents sensor being tripped
	reg inc, dec, update; // variables to control counter
	
	assign a = V_GPIO[27];
	assign b = V_GPIO[31];
	
		
	// enum variables to control states, ps and ns for present and next states
	// last change variables creates a chain to track last states
	// enum {none, aTripped, bTripped, both} ps, ns, lastChange, lastChange2, lastChange3, lastChange4;
	
	enum {none, afirst, aboth, aoff, bfirst, bboth, boff} ps, ns;
	
	
	// instantiates display module
	display dsp (.clk, .reset, .inc, .dec, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5);

	// always comb block to track states
	always_comb begin
		case (ps)  
			// state where neither a or b is tripped
			 none:   begin 
					//inc = 1'b0;
					//dec = 1'b0;
					
					if (a)
						ns = afirst;
					else if (b)
						ns = bfirst;
					else 
						ns = none;
					end
					
			// state where only a is tripped
			 afirst:  	begin 
					if (a & b)
						ns = aboth;
					else if (a & !b)
						ns = afirst;
					else 
						ns = none;
					end
					
			// state where only b is tripped
			aboth:  	begin 
					if (!a & b)
						ns = aoff;
					else if (a & b)
						ns = aboth;
					else if (a & !b)
						ns = afirst;
					else
						ns = none;
					end
					
			// state where both a and b are tripped
			aoff:  	begin 
					if (!a & !b) begin
						ns = none;
						//inc = 1'b1;
						end
					else if (!a & b)
						ns = aoff;
					else if (a & b)
						ns = aboth;
					else
						ns = none;
					end
				
			bfirst:  	begin 
					if (a & b)
						ns = bboth;
					else if (!a & b)
						ns = bfirst;
					else 
						ns = none;
					end
					
			// state where only b is tripped
			bboth:  	begin 
					if (a & !b)
						ns = boff;
					else if (a & b)
						ns = bboth;
					else if (!a & b)
						ns = bfirst;
					else
						ns = none;
					end
					
			// state where both a and b are tripped
			boff:  	begin 
					if (!a & !b) begin
						ns = none;
						//dec = 1'b1;
						end
					else if (a & !b)
						ns = boff;
					else if (a & b)
						ns = bboth;
					else
						ns = none;
					end
					
		    default: ns = none;
		 endcase
	end


	always @ (posedge clk) begin 			  
		ps <= ns;
		
		if ((ps == aoff) && (ns == none))
			inc = 1'b1;
		else if ((ps == boff) && (ns == none))
			dec = 1'b1;
		else begin
			inc = 1'b0;
			dec = 1'b0;
			end
	end
	
endmodule


module main_testbench();  
	logic         clk;   
	logic  [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;    
	logic  [9:0]  LEDR;     
	logic  [3:0]  KEY; 
	logic  [9:0]  SW;  
	  
	main dut (.CLOCK_50(clk), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2),
					  .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5), .KEY(KEY), .LEDR(LEDR), .SW(SW));  
		
	 // Set up a simulated clock.   
	parameter CLOCK_PERIOD=100;  

	initial begin   
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
	end  
		
	// Test the design. 
	initial begin  
									 @(posedge clk);   
		SW[8:0] <= 0; LEDR[9:0] <= 0; KEY[3:0] <= 0; @(posedge clk);
		SW[9] <= 1;		  			@(posedge clk); // Always reset FSMs at start  
		SW[9] <= 0;			    	@(posedge clk);   
										repeat(4) @(posedge clk);		
		SW[0] <= 1;           	@(posedge clk);
										repeat(4) @(posedge clk);    
		SW[1] <= 1;			 		@(posedge clk);
										repeat(4) @(posedge clk);		
		SW[0] <= 0;           	@(posedge clk);
										repeat(4) @(posedge clk);   
		SW[1] <= 0;			 		@(posedge clk);   
										@(posedge clk);		
		SW[0] <= 1;           	@(posedge clk);
										repeat(4) @(posedge clk);    
		SW[1] <= 1;			 		@(posedge clk);
										repeat(4) @(posedge clk);		
		SW[0] <= 0;           	@(posedge clk);
										repeat(4) @(posedge clk);   
		SW[1] <= 0;			 		@(posedge clk);
										repeat(4) @(posedge clk);    
										@(posedge clk);		
		SW[0] <= 1;           	@(posedge clk);
										repeat(4) @(posedge clk);    
		SW[1] <= 1;			 		@(posedge clk);
										repeat(4) @(posedge clk);		
		SW[0] <= 0;           	@(posedge clk);
										repeat(4) @(posedge clk);   
		SW[1] <= 0;			 		@(posedge clk); 
										repeat(4) @(posedge clk);   
										@(posedge clk);		
		SW[0] <= 1;           	@(posedge clk);    
		SW[1] <= 1;			 		@(posedge clk);		
		SW[0] <= 0;           	@(posedge clk);   
		SW[1] <= 0;			 		@(posedge clk);  
										@(posedge clk);		
		SW[1] <= 1;           	@(posedge clk);     
		SW[0] <= 1;			 		@(posedge clk); 		
		SW[1] <= 0;           	@(posedge clk);   
		SW[0] <= 0;			 		@(posedge clk); 
										@(posedge clk);		
		SW[1] <= 1;           	@(posedge clk);     
		SW[0] <= 1;			 		@(posedge clk); 		
		SW[1] <= 0;           	@(posedge clk);   
		SW[0] <= 0;			 		@(posedge clk);
		@(posedge clk);

		$stop; // End the simulation.  
	end    
endmodule 