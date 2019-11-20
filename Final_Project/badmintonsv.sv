module badminton(
					  input logic [9:0] player_x, player_y,
					  input logic Clk,
					  input logic frame_clk,
					  input logic 
					  input logic Reset,
					  output logic [9:0] ball_x, ball_y);

					  

	parameter [9:0] Ball_X_Center;
	parameter [9:0] Ball_Y_Center;
	parameter [9:0] Ball_X_Max;
	parameter [9:0] Ball_X_Min;
	parameter [9:0] Ball_Y_Max;
	parameter [9:0] Ball_Y_Min;
	// player box
	parameter [9:0] Player_X_Min = player_x;
	parameter [9:0] Player_X_Max = player_x + 10'd40;
	parameter [9:0] Player_Y_Min = player_y;
	parameter [9:0] Player_Y_Max = player_y + 10'd80;
	
	logic [9:0] Ball_X_Motion, Ball_Y_Motion, Ball_X_Pos, Ball_Y_Pos;
	logic [9:0] Ball_X_Motion_in, Ball_Y_Motion_in, Ball_X_Pos_in, Ball_Y_Pos_in;
	
	
	
	assign ball_x = Ball_X_Pos;
	assign ball_y = Ball_Y_Pos;
					  
	logic frame_clk_delayed, frame_clk_rising_edge;
   always_ff @ (posedge clk) begin
       frame_clk_delayed <= frame_clk;
       frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
   end					  

	always_ff @ (posedge clk)
   begin
		if(Reset)
		begin
			Ball_X_Pos <= player_x;
			Ball_Y_Pos <= player_y;
			Ball_X_Motion <= 10'd0;
			Ball_Y_Motion <= 10'd0;
		end
		else
			Ball_X_Pos <= Ball_X_Pos_in;
			Ball_Y_Pos <= Ball_Y_Pos_inl
			Ball_X_Motion <= Ball_X_Motion_in;
			Ball_Y_Motion <= Ball_Y_Motion_in;
		end
	end
	
	always_comb
	begin
		// update location
		Ball_X_Pos_in = Ball_X_Pos;
		Ball_Y_Pos_in = Ball_Y_Pos;
		Ball_X_Motion_in = Ball_X_Motion;
		Ball_Y_Motion_in = Ball_Y_Motion;
	
	if(frame_clk_rising_edge)
	begin
		
		
		
		
		
		Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
		Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;	
	end
	end
	
	

endmodule
