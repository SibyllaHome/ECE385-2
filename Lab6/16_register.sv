module sixteen_register (input  logic Clk, LoadEn, Reset,
						  input  logic [15:0] Din,
						  output logic [15:0] Dout);
					
	always_ff @ (posedge Clk)
	begin
	
		if (Reset)
			Dout <= 16'h0;
		else if(LoadEn)
			Dout <= Din;
			
	end
	
endmodule
