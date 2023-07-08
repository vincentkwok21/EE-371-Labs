module Lab4Task1_tb ();

	//define parameters
	parameter T = 20;

	//define module port connections
	logic Start, Reset, clk;
	logic [7:0] Input;
	logic Ready, Done;
	logic [3:0] Result;
	
	//instantiate module
	Lab4Task1 dut (.*);
	
	//create simulated clock
	initial begin
		clk <= 0;
		forever #(T/2) clk <= ~clk;
	end // clock intial

	//define test inputs
	initial begin 
		Input = 8'b10001001;
		Reset = 1; Start = 0;	@(posedge clk);
		Reset = 0;					@(posedge clk);
		Start = 1;					@(posedge clk);
		Start = 0;
	
		repeat (20)				@(posedge clk);
										@(posedge clk);
		$stop();
	end
endmodule
