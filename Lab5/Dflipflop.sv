module DFlip (input logic Clk, load, reset, B,
				output logic D);
				
				always_ff @ (posedge Clk)
				begin
					
					if (reset)
						D <= 1'b0;
						
					else 
						if (load)
							D <= B;
						else
							D <= D;
						
				end
				
endmodule
