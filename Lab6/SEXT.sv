module sext_input5 (input logic [4:0]  IN,
						 output logic [15:0] OUT);
			
						always_comb
						begin 
						if(IN[4] == 1)
							OUT[15:5] = 11'b11111111111; //from 5 bits to 16 bits
						else
							OUT[15:5] = 11'b00000000000; //need 11 bits
						OUT[4:0] = IN;
						end
endmodule

module sext_input6 (input logic [5:0]  IN,
						 output logic [15:0] OUT);
			
						always_comb
						begin 
						if(IN[5] == 1)
							OUT[15:6] = 10'b1111111111; //from 6 bits to 16 bits
						else
							OUT[15:6] = 10'b0000000000; //need 10 bits
						OUT[5:0] = IN;
						end
endmodule

module sext_input9 (input logic [8:0]  IN,
						 output logic [15:0] OUT);
			
						always_comb
						begin 
						if(IN[8] == 1)
							OUT[15:9] = 7'b1111111; //from 9 bits to 16 bits
						else
							OUT[15:9] = 7'b0000000; //need 7 bits
						OUT[8:0] = IN;	
						end
endmodule

module sext_input11 (input logic [10:0] IN,
						  output logic [15:0] OUT);
			
						always_comb
						begin 
						if(IN[10] == 1)
							OUT[15:11] = 5'b11111; //from 11 bits to 16 bits
						else
							OUT[15:11] = 5'b00000; //need 4 bits
						OUT[10:0] = IN;	
						end
endmodule
