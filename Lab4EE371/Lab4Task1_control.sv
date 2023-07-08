module Lab4Task1_control(input logic Start, Reset, clk,
								 output logic Load_A, Shift_A, Decr_P, Incr_Result,
								 input logic A0, P_zero,
								 output logic Ready, Done);
								 
	//define state names and variables
	enum {S_idle, S_shift, S_done} ps, ns;
	
	//controller logic with sychronous reset
	always_ff @(posedge clk)
		if (Reset)
			ps <= S_idle;
		else
			ps <= ns;
	
	//next state logic
	always_comb
		case(ps)
			S_idle: ns = Start ? S_shift : S_idle;
			S_shift: ns = P_zero ? S_done : S_shift;
			S_done: ns = Start ? S_done : S_idle;
		endcase
		
	//output assignments
	assign Load_A = (ps == S_idle) & Start;
	assign Shift_A = (ps == S_shift);
	assign Decr_P = (ps == S_shift);
	assign Incr_Result = (ps == S_shift) & (ns == S_shift) & (A0 == 1);
	assign Ready = (ps == S_idle);  
	assign Done = (ps == S_done);
	
endmodule 