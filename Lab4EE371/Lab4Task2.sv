module Lab4Task2(input logic Start, Reset, clk,
					input logic [7:0] Input,
					output logic Ready, Done, Found,
					output logic [4:0] Loc); // need LOC as output too
					
	//define status and control signals 
	logic Load_Regs, Set_Found, Set_Middle, Set_High, Set_Low;
	logic Mem_Eq_In, H_Eq_L, In_Gt_Mem;
	logic [4:0] M;
	
	assign Loc = M;
	
	//instantive control and datapath
	Lab4Task2_control c_unit (.*);
	Lab4Task2_datapath d_unit (.*);

endmodule // Lab4task2
