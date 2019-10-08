module NZP (input logic Nin, Zin, Pin, LD_CC, CLK
				output logic Nout, Zout, Pout)
				
	always_ff @ (posedge CLK)
	begin
		if (LD_CC)
		begin
			Nout <= Nin;
			Zout <= Zin;
			Pout <= Pin;
		end
	end
	
endmodule

