module Lab4Task2_datapath(input logic Reset, clk,
								  input logic [7:0] Input,
								  input logic Load_Regs, Set_Found, Set_Middle, Set_High, Set_Low,
								  output logic Mem_Eq_In, H_Eq_L, In_Gt_Mem,
								  output logic Found,
								  output logic [4:0] M = 5'b01111); // add LOC later to output logic

	//internal datapath signals and registers
	logic [7:0] In, Mem;
	logic [4:0] L = 5'b00000;
	logic [4:0] H = 5'b11111;
	
	logic buff;
	
	
	//datapath logic
	always_ff @(posedge clk) begin
		if (Load_Regs) begin
			In <= Input;
			Found <= 1'b0;
			M <= 5'b01111;
			L <= 5'b00000;
			H <= 5'b11111;
		end
		
		if(buff) begin
			if (Set_Found) Found <= 1'b1; // something about updating the LOC here
			if (Set_High) begin 
				H <= (M - 1);
				M <= ((L + M) / 2);
			end
			
			if (Set_Low) begin
				L <= (M + 1);
				M <= ((H + M) / 2);
			end
			buff <= 0;
		end else begin
			buff <= 1;
		end
			
		
//		if (Set_Middle) M <= ((L + H) / 2);
	end
	
	// output assignments
	assign Mem_Eq_In = (Mem == In);
	assign H_Eq_L = (H == L);
	assign In_Gt_Mem = (In > Mem);
	
	
	ram32x8 ram (.address(M), .clock(clk), .data(8'd0), .wren(1'b0), .q(Mem));
	
endmodule

