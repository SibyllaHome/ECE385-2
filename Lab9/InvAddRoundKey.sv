module InvAddRoundKey(
							 input logic [127:0] INPUT,
							 input logic [127:0] ROUNDKEY,
							 output logic [127:0] OUTPUT);
assign OUTPUT = INPUT ^ ROUNDKEY;
endmodule
