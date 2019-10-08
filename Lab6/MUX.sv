module MUX_PC(input logic [15:0] Din0, Din1, Din2,
				  input logic [1:0] Select,
				  output logic [15:0] Dout);
	
	always_comb
	begin
		case(Select)
			
			2'b00:	Dout = Din0;
			
			2'b01:	Dout = Din1;
			
			2'b10:	Dout = Din2;
			
			2'b11:	Dout = 16'h0;
			
		endcase
	end
	
endmodule


module MUX_MDR(input logic [15:0] Din0, Din1,
					input logic Select,
					output logic [15:0] Dout);
					
	always_comb
	begin
		case(Select)
			
			1'b0:		Dout = Din0;
			
			1'b1:		Dout = Din1;
			
		endcase
		
	end
	
endmodule


module MUX_GATE (input logic [15:0] Din0, Din1, Din2, Din3,
					  input logic [3:0] Select,
					  output logic [15:0] Dout);
					  
	always_comb
	begin
		case(Select)
		
			4'b1000:		Dout = Din0;
			
			4'b0100:		Dout = Din1;
			
			4'b0010:		Dout = Din2;
			
			4'b0001:		Dout = Din3;
			
			default:		Dout = 16'b0;
			
		endcase
		
	end
	
endmodule

module ADDR2MUX(input logic [15:0] Din0, Din1, Din2,
					 input logic [1:0] Select,
					 output logic [15:0] Dout);
					 
	always_comb
	begin
		case(Select)
			
			2'b00:	Dout = Din0;
			2'b01:	Dout = Din1;
			2'b10:	Dout = Din2;
			2'b11:	Dout = 16'b0000000000000000;
		
		endcase
	end

endmodule


module mux2 #(parameter width)
					(input logic [width - 1:0] Din0, Din1,
					input logic Select,
					output logic [width - 1:0] Dout);
					
	always_comb
	begin
		case(Select)
			
			1'b0:		Dout = Din0;
			
			1'b1:		Dout = Din1;
			
		endcase
		
	end
	
endmodule
	
	
	
	
	
