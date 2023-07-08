module Lab4Task1_datapath (input logic Reset, clk,
									input logic [7:0] Input,
									input logic Load_A, Shift_A, Decr_P, Incr_Result,
									output logic A0, P_zero,
									output logic [3:0] Result = '0);
									
	//internal datapath signals and registers
	logic [7:0] In, P;
	
	assign A0 = (In[0]); 
	assign P_zero = (P == 0);
	
	// datapath logic
	always_ff @(posedge clk) begin
		if(Reset) begin
			Result <= 4'b0000;
		end
		if (Load_A) begin
			P <= 8; // different datatype?
			In <= Input;
			if(A0) Result <= 4'b0001; // differnet datatype?
		end
		
		if (Shift_A)  In <= (In >> 1);
		if (Decr_P)   P <= P - 1;
		if (Incr_Result) Result <= Result + 1;
	end
	
	//output assignments
endmodule 