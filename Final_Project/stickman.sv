module stickman(input logic [9:0] drawX, drawY,
					 input logic clk,
					 output logic [4:0] pixel_val);
		
//logic [11:0] player_addr;
logic [7:0] player_out;
logic [11:0] test_addr;
logic [9:0] x_begin = 10'd50;
logic [9:0] y_begin = 10'd380; 
logic [9:0] x_diff, y_diff;

assign x_diff = drawX - x_begin;
assign y_diff = drawY - y_begin;
	
player player1(.read_addr(test_addr), .clk(clk), .data_out(player_out));
//testRamSmall(.read_addr(test_addr), .clk(clk), .data_out(player_out));

always_comb begin
	pixel_val = 5'd0;
	test_addr = 10'b0;
	if (drawX >= x_begin && drawX < (x_begin + 10'd40) && drawY >= y_begin && drawY < (y_begin + 10'd80))
	begin
		test_addr = y_diff*10'd40 + x_diff;
		pixel_val = player_out[4:0];
	end
	else
	begin
		pixel_val = 5'd0;
		test_addr = 9'b0;
	end
end

endmodule
