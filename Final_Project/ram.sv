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




module background (
					 input [16:0] read_addr,		// 2 ^ 17 > 76800
					 input clk,
					 output logic [7:0] data_out);

logic [7:0] mem [0:76799]; // 76800 lines

initial begin
	$readmemh("background.txt",mem);
end

always_ff @ (posedge clk)
begin
	data_out <= mem[read_addr];
end

endmodule





module player (
					 input [11:0] read_addr,		// 2 ^ 12 > 3200
					 input clk,
					 output logic [7:0] data_out);

logic [7:0] mem [0:3199]; // 320 lines

initial begin
	$readmemh("player.txt",mem);
end

always_ff @ (posedge clk)
begin
	data_out <= mem[read_addr];
end

endmodule
