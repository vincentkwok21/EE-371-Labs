module Lab4Task1(input logic Start, Reset, clk,
						input logic [7:0] Input,
						output logic Ready, Done,
						output logic [3:0] Result = '0);
						
	//define status and control signals
	logic Load_A, Shift_A, Decr_P, Incr_Result;
	logic A0, P_zero;
	
//	//instantive control and datapath
	Lab4Task1_control c_unit (.*);
	Lab4Task1_datapath d_unit (.*);
	
endmodule // Lab4task1