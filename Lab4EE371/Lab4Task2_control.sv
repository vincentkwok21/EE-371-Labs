module Lab4Task2_control(input logic Start, Reset, clk,
								 output logic Load_Regs, Set_Found, Set_Middle, Set_High, Set_Low,
								 input logic Mem_Eq_In, H_Eq_L, In_Gt_Mem,
								 output logic Ready, Done);
	//define state names and variables
	enum logic [1:0] {S_idle, S_search, S_done} ps, ns;

	//controller logic with synchronous reset
	always_ff @(posedge clk)
	if (Reset)
		ps <= S_idle;
	else
		ps <= ns;
	
	//next state logic
	always_comb
		case(ps)
			S_idle: ns = Start ? S_search : S_idle;
			S_search: ns = (Mem_Eq_In | H_Eq_L) ? S_done : S_search;
			S_done: ns = Start ? S_done : S_idle;
		endcase	
		
	//output assignments
	assign Load_Regs = (ps == S_idle) & Start;
	assign Set_Found = (ps == S_done) & (Mem_Eq_In);
	assign Set_Middle = (ps == S_search) & (ns == S_search); 
	assign Set_High = (ps == S_search) & (ns == S_search) & ~(In_Gt_Mem);
	assign Set_Low = (ps == S_search) & (ns == S_search) & (In_Gt_Mem);
	assign Ready = (ps == S_idle);  
	assign Done = (ps == S_done);
	
endmodule

