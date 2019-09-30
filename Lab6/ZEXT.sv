module ZEXT(input logic [15:0] Din,
				output logic [19:0] Dout);
	always_comb
	begin
	
		Dout[15:0] = Din[15:0];
		Dout[19:16] = {0, 0, 0, 0};
		
	end
	
endmodule
