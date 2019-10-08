module ALU (input logic [15:0] A,B,
				input logic [1:0] Select,
				output logic [15:0] Dout);
				
	always_comb
	begin
		case (Select)
		
			2'b00:
				Dout = A + B;
			2'b01:
				Dout = A & B;
			2'b10:
				Dout = ~A;
			2'b11:
				Dout = A;
		
		endcase
	end

endmodule
