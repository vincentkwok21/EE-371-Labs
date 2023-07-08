module mux2_1(out, i0, i1, sel);  
	output logic [23:0] out;   
	input  logic [23:0] i0, i1;
	input logic sel;   
	
	always_comb begin
		integer i;
	 
		for (i = 0; i < 24; i++) begin
			out[i] = (i1[i] & sel) | (i0[i] & ~sel);
		end
	end
 
endmodule  
  
module mux2_1_testbench();  
 logic i0, i1, sel;   
 logic out;   
   
 mux2_1 dut (.out, .i0, .i1, .sel);   
  
 initial begin  
  sel=0; i0=0; i1=0; #10;   
  sel=0; i0=0; i1=1; #10;   
  sel=0; i0=1; i1=0; #10;   
  sel=0; i0=1; i1=1; #10;   
  sel=1; i0=0; i1=0; #10;   
  sel=1; i0=0; i1=1; #10;   
  sel=1; i0=1; i1=0; #10;   
  sel=1; i0=1; i1=1; #10;   
 end  
endmodule