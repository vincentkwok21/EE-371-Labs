/*
	Display Module
	
	Is responsible for controlling the hex displays
	
	takes in clock and reset signals, along with signals to increment and decrement counter
	outputs HEX signals

*/
module display (clk, reset, inc, dec, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input clk, reset;
	input inc, dec;
	output reg [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	// creates dig control signals to control each respective HEX
	reg [3:0] dig0 = 4'b0000;
	reg [3:0] dig1 = 4'b1111;
	reg [3:0] dig2 = 4'b0000;
	reg [3:0] dig3 = 4'b0000;
	reg [3:0] dig4 = 4'b0000;
	reg [3:0] dig5 = 4'b0000;
	
	reg [4:0] count = 5'b00000; // creates counter variable to track count	
	
	// updates each HEX every clk tick
	always_ff @(posedge clk) begin
		// sets default hex values
		if(reset) begin
			count = 5'b00000;
			dig0 = 4'b0000;
			dig1 = 4'b1111;
			dig2 = 4'b0000;
			dig3 = 4'b0000;
			dig4 = 4'b0000;
			dig5 = 4'b0000;
		end
		
		// if full, sets HEXs 2-5 to FULL
		if(count == 5'b10000) begin
			dig2 = 4'b1111;
			dig3 = 4'b1111;
			dig4 = 4'b1111;
			dig5 = 4'b1111;
			end
		else if(count == 5'b00000) begin // if 0, sets Hexs 1-5 to CLEAR
			dig1 = 4'b1111;
			dig2 = 4'b0000;
			dig3 = 4'b0000;
			dig4 = 4'b0000;
			dig5 = 4'b0000;
			end
		else begin // else sets hexs 2-5 to off
			if(dig1 == 4'b1111) 
				dig1 = 4'b0000;// if dig1 is 'R', sets it to 0
			dig2 = 4'b0001;
			dig3 = 4'b0001;
			dig4 = 4'b0001;
			dig5 = 4'b0001;
		end
				
		
		// creates the logic for when inc is true
		if(inc) begin
			// increments count if not full
			if(count != 5'b10000) begin // full if count == 16
				count = count + 1'b1;
			
				dig0 = dig0 + 1'b1;
				
				if (dig0 == 4'b1010) begin
					dig1 = dig1 + 1'b1;
					dig0 = 4'b0000;
					end
			end
		end
		
		// creates the logic for when dec is true
		if(dec) begin
			if(count != 5'b00000) begin
				count = count - 1'b1;
				
				if (dig0 == 4'b0000) begin 
					dig1 = dig1 - 1'b1;
					dig0 = 4'b1010; end
					
				dig0 = dig0 - 1'b1;
			end
		end
		
		// case statement to set values for HEX0
		case(dig0)
		 4'b0000: HEX0 = ~(7'b1111110); // 0 
		 4'b0001: HEX0 = ~(7'b0110000); // 1 
		 4'b0010: HEX0 = ~(7'b1101101); // 2 
		 4'b0011: HEX0 = ~(7'b1111001); // 3 
		 4'b0100: HEX0 = ~(7'b0110011); // 4 
		 4'b0101: HEX0 = ~(7'b1011011); // 5 
		 4'b0110: HEX0 = ~(7'b1011111); // 6 
		 4'b0111: HEX0 = ~(7'b1110000); // 7 
		 4'b1000: HEX0 = ~(7'b1111111); // 8 
		 4'b1001: HEX0 = ~(7'b1111011); // 9
		 default: HEX0 = ~(7'b0000000); 
		endcase
		
		// case statement to set values for HEX1
		case(dig1)
		 4'b0000: HEX1 = ~(7'b1111110); // 0
		 4'b0001: HEX1 = ~(7'b0110000); // 1 
		 4'b0010: HEX1 = ~(7'b1101101); // 2 
		 4'b0011: HEX1 = ~(7'b1111001); // 3 
		 4'b0100: HEX1 = ~(7'b0110011); // 4 
		 4'b0101: HEX1 = ~(7'b1011011); // 5 
		 4'b0110: HEX1 = ~(7'b1011111); // 6 
		 4'b0111: HEX1 = ~(7'b1110000); // 7 
		 4'b1000: HEX1 = ~(7'b1111111); // 8 
		 4'b1001: HEX1 = ~(7'b1111011); // 9  
		 4'b1111: HEX1 = ~(7'b1000110); // CLEA'R'
		 default: HEX1 = ~(7'b0000000);
		endcase
		
		// case statement to set values for HEX2
		case(dig2)
		 4'b0000: HEX2 = ~(7'b1110111); // CLE'A'R 
		 4'b1111: HEX2 = ~(7'b0001110); // FUL'L'
		 default: HEX2 = ~(7'b0000000); 
		endcase
		
		// case statement to set values for HEX3
		case(dig3)
		 4'b0000: HEX3 = ~(7'b1001111); // CL'E'AR 
		 4'b1111: HEX3 = ~(7'b0001110); // FU'L'L
		 default: HEX3 = ~(7'b0000000); 
		endcase
		
		// case statement to set values for HEX4
		case(dig4)
		 4'b0000: HEX4 = ~(7'b0001110); // C'L'EAR
		 4'b1111: HEX4 = ~(7'b0111110); // F'U'LL
		 default: HEX4 = ~(7'b0000000); 
		endcase
		
		// case statement to set values for HEX5
		case(dig5)
		 4'b0000: HEX5 = ~(7'b1001110); // 'C'LEAR
		 4'b1111: HEX5 = ~(7'b1000111); // 'F'ULL
		 default: HEX5 = ~(7'b0000000); 
		endcase
		
	end 

endmodule 