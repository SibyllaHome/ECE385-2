module control(
					input logic Clk, Reset, ClearA_LoadB, Run, M,
					output logic load, shift, add, sub
					);
	
	