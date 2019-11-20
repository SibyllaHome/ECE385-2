module keycode_reader(
							input logic [47:0] keycode,
							output logic w_on, a_on, s_on, d_on, up_on, down_on, left_on, right_on
						  );

assign w_on = (keycode[47:40] == 8'h1A | keycode[39:32] == 8'h1A | keycode[31:24]	== 8'h1A | keycode[23:16] == 8'h1A | keycode[15:8] == 8'h1A | keycode[7:0] == 8'h1A);					  
assign a_on = (keycode[47:40] == 8'h04 | keycode[39:32] == 8'h04 | keycode[31:24]	== 8'h04 | keycode[23:16] == 8'h04 | keycode[15:8] == 8'h04 | keycode[7:0] == 8'h04);					  
assign s_on = (keycode[47:40] == 8'h16 | keycode[39:32] == 8'h16 | keycode[31:24]	== 8'h16 | keycode[23:16] == 8'h16 | keycode[15:8] == 8'h16 | keycode[7:0] == 8'h16);
assign d_on = (keycode[47:40] == 8'h07 | keycode[39:32] == 8'h07 | keycode[31:24]	== 8'h07 | keycode[23:16] == 8'h07 | keycode[15:8] == 8'h07 | keycode[7:0] == 8'h07);					  
assign up_on = (keycode[47:40] == 8'h52 | keycode[39:32] == 8'h52 | keycode[31:24]	== 8'h52 | keycode[23:16] == 8'h52 | keycode[15:8] == 8'h52 | keycode[7:0] == 8'h52);					  
assign down_on = (keycode[47:40] == 8'h51 | keycode[39:32] == 8'h51 | keycode[31:24]	== 8'h51 | keycode[23:16] == 8'h51 | keycode[15:8] == 8'h51 | keycode[7:0] == 8'h51);
assign left_on = (keycode[47:40] == 8'h50 | keycode[39:32] == 8'h50 | keycode[31:24]	== 8'h50 | keycode[23:16] == 8'h50 | keycode[15:8] == 8'h50 | keycode[7:0] == 8'h50); 
assign right_on = (keycode[47:40] == 8'h4F | keycode[39:32] == 8'h4F | keycode[31:24]	== 8'h4F | keycode[23:16] == 8'h4F | keycode[15:8] == 8'h4F | keycode[7:0] == 8'h4F); 


endmodule
