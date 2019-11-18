module testRam (
					 input [18:0] read_addr,
					 input clk,
					 output logic [7:0] data_out);

logic [7:0] mem [0:307199]; // 307200 lines

initial begin
	$readmemh("mario.txt",mem);
end

always_ff @ (posedge clk)
begin
	data_out <= mem[read_addr];
end

endmodule


module testRamSmall (
					 input [9:0] read_addr,		// 2 ^ 10
					 input clk,
					 output logic [7:0] data_out);

logic [7:0] mem [0:791]; // 792 lines

initial begin
	$readmemh("Right.txt",mem);
end

always_ff @ (posedge clk)
begin
	data_out <= mem[read_addr];
end

endmodule
