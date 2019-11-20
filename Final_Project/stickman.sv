module stickman(input logic [9:0] drawX, drawY,
      input logic clk,
      input logic jump,walk,
      input logic [9:0] x_begin, y_begin,
      output logic [4:0] pixel_val);
  
  
 


logic [7:0] player_out;
logic [7:0] jump_out;
logic [11:0] player_addr;
logic [9:0] x_diff, y_diff;


assign x_diff = drawX - x_begin;
assign y_diff = drawY - y_begin;
 
player player1(.read_addr(player_addr), .clk(clk), .data_out(player_out));
player_jump player1_jump(.read_addr(player_addr), .clk(clk), .data_out(jump_out));
//testRamSmall(.read_addr(test_addr), .clk(clk), .data_out(player_out));

always_comb begin
 pixel_val = 5'd0;
 player_addr = 10'b0;
 if (drawX >= x_begin && drawX < (x_begin + 10'd40) && drawY >= y_begin && drawY < (y_begin + 10'd80))
 begin
  player_addr = y_diff*10'd40 + x_diff;
  if(jump)begin
  pixel_val = jump_out[4:0];
  end
//  else if(walk)begin
//  
//  end
  else begin
  pixel_val = player_out[4:0];
  end
 end
 else
 begin
  pixel_val = 5'd0;
  player_addr = 9'b0;
 end
end

endmodule












module moving_player1(input clk,
									Reset,
									frame_clk,
//							input [9:0] DrawX, DrawY,
							input [47:0] keycode,
							output [9:0] x_begin, y_begin,
							output jump_out, walk_out
							);
							
	parameter [9:0] player1_X_Center = 10'd100;
	parameter [9:0] player1_Y_Center = 10'd370;
	parameter [9:0] player1_X_Min = 10'd25;
	parameter [9:0] player1_X_Max = 10'd280;
	parameter [9:0] player1_Y_Max = 10'd370;
	parameter [9:0] player1_Y_Min = 10'd290;
	parameter [9:0] player1_X_Step = 10'd2;
	parameter [9:0] player1_X_Step_neg = 10'd1;
	logic [9:0] player1_Y_Step;
//	parameter [5:0] counter_jump = 6'd60;
//	parameter [5:0] counter_fall = 6'd0;
	logic w_on, a_on, s_on, d_on, up_on, down_on, left_on, right_on;
	
	keycode_reader reader(.keycode(keycode),
								 .w_on(w_on),
								 .a_on(a_on),
								 .s_on(s_on),
								 .d_on(d_on),
								 .up_on(up_on),
								 .down_on(down_on),
								 .left_on(left_on),
								 .right_on(right_on));
	logic top;
	logic top_in;
	logic jump;
	logic jump_in;
	logic walk;
	assign jump_out = jump;
	assign walk_out = walk;
	logic [5:0] counter;
	logic [5:0] counter_in;
	logic [9:0] player1_X_Motion, player1_Y_Motion, player1_X_Pos, player1_Y_Pos;
	logic [9:0] player1_X_Motion_in, player1_Y_Motion_in, player1_X_Pos_in, player1_Y_Pos_in;
	assign x_begin = player1_X_Pos;
	assign y_begin = player1_Y_Pos;
	
	logic frame_clk_delayed, frame_clk_rising_edge;
   always_ff @ (posedge clk) begin
       frame_clk_delayed <= frame_clk;
       frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
   end
   // Update ball position and motion
   always_ff @ (posedge clk)
   begin
       if (Reset)
       begin
           player1_X_Pos <= player1_X_Center;
           player1_Y_Pos <= player1_Y_Center;
           player1_X_Motion <= 10'd0;
           player1_Y_Motion <= 10'd0;
			  counter <= 0;
			  jump <= 0;
			  top <= 0;
       end
			
       else       // Update only at rising edge of frame clock
       begin
           player1_X_Pos <= player1_X_Pos_in;
           player1_Y_Pos <= player1_Y_Pos_in;
           player1_X_Motion <= player1_X_Motion_in;
           player1_Y_Motion <= player1_Y_Motion_in;
			  counter <= counter_in;
			  jump <= jump_in;
			  top <= top_in;
       end
		 if (jump == 1'b0)
		 begin
				counter <= 0;
				top <= 0;
			end
		  else 
		  begin
				counter <= counter_in;
				top <= top_in;
			end
       // By defualt, keep the register values.
   end

	 
	
	
	always_comb
	begin
		
		//Update the player's position with its motion
		player1_X_Pos_in = player1_X_Pos;
		player1_Y_Pos_in = player1_Y_Pos;
		player1_X_Motion_in = player1_X_Motion;
		player1_Y_Motion_in = player1_Y_Motion;
		counter_in = counter;
		top_in = top;
		jump_in = jump;
		walk = 1'b0;
		
		
		//Y direction needs to be changed
	if (frame_clk_rising_edge)
      begin           
				if ( player1_Y_Pos >= player1_Y_Max )		
					begin
					player1_Y_Motion_in = 0;
					player1_X_Motion_in = player1_X_Motion;
//					else if ( keycode == 8'h16 )
//						begin
//						player1_X_Motion_in = 0;
//						player1_Y_Motion_in = 0;					// S: DOWN
//						end
					if (a_on == 0 && d_on == 0)
						begin 
						player1_X_Motion_in = 0;
						end
					else if (a_on == 1'b1 && d_on == 1'b1)
						player1_X_Motion_in = 0;

					else if ( d_on == 1'b1)
						begin
						player1_X_Motion_in = player1_X_Step;	// A: LEFT
						walk = 1'b1;
						end
					else if (a_on == 1'b1)
						begin
						player1_X_Motion_in = (~(player1_X_Step) + 1'b1);					// D: RIGHT
						walk = 1'b1;
						end
					if (w_on == 1'b1)
						begin
//						player1_X_Motion_in = player1_X_Motion;
//						player1_Y_Motion_in = 0; // W: UP
						jump_in = 1'b1;
						top_in = 0;
						player1_X_Motion_in = {player1_X_Motion[9],player1_X_Motion[9:1]};
						end
					end
				if( player1_X_Pos >= player1_X_Max )
					begin
					player1_X_Motion_in = 0;
					player1_Y_Motion_in = player1_Y_Motion;
					if (player1_Y_Pos >= player1_Y_Max)
						player1_Y_Motion_in = 0;
					if ( a_on == 1'b1 && player1_Y_Pos >= player1_Y_Max)
						begin
						player1_X_Motion_in = (~(player1_X_Step) + 1'b1);	// A: LEFT
						end
					end
				if (player1_X_Pos <= player1_X_Min)
					begin
					player1_X_Motion_in = 0;
					player1_Y_Motion_in = player1_Y_Motion;
					if (player1_Y_Pos >= player1_Y_Max)
						player1_Y_Motion_in = 0;
					if (d_on == 1'b1 && player1_Y_Pos >= player1_Y_Max)
						begin
						player1_X_Motion_in = player1_X_Step;					// D: RIGHT
						end
					end
				if (jump == 1'b1)
					begin
					if (counter < 6'd59 && top == 0)
					begin
					   counter_in = counter + 1'b1;
					   player1_Y_Motion_in = (~(player1_Y_Step) + 1'b1);
						if (player1_X_Pos >= player1_X_Max || player1_X_Pos <= player1_X_Min)
							player1_X_Motion_in = 0;
						else
							player1_X_Motion_in = player1_X_Motion;
//							begin
//							if (player1_X_Motion > 10'd0)
//								player1_X_Motion_in = 10'd1;
//							else if (player1_X_Motion < 10'd0)
//								player1_X_Motion_in = {player1_X_Motion[9],player1_X_Motion[9:1]};
//							else
//								player1_X_Motion_in = 10'd0;
//							end
					end
					if (counter >= 6'd59)
						top_in = 1;
					if (counter > 0 && top == 1'b1)
					begin
						counter_in = counter - 1'b1;
						player1_Y_Motion_in = player1_Y_Step;
						if (player1_X_Pos >= player1_X_Max || player1_X_Pos <= player1_X_Min)
							player1_X_Motion_in = 0;
						else
							player1_X_Motion_in = player1_X_Motion;
//							begin
//							if (player1_X_Motion > 10'd0)
//								player1_X_Motion_in = 10'd1;
//							else if (player1_X_Motion < 10'd0)
//								player1_X_Motion_in = {player1_X_Motion[9],player1_X_Motion[9:1]};
//							else
//								player1_X_Motion_in = 10'd0;
//							end
					end
					if (counter <= 0 && top == 1'b1)
					begin
						jump_in = 0;
						top_in = 0;
					end
				end
						
						
				
            // Update the ball's position with its motion
            player1_X_Pos_in = player1_X_Pos + player1_X_Motion;
            player1_Y_Pos_in = player1_Y_Pos + player1_Y_Motion;	
			end	
	end
	
	always_comb
	begin
		player1_Y_Step = 0;
		unique case(counter)
		6'd1: player1_Y_Step = 10'd4;
		6'd2, 6'd3, 6'd4, 6'd5, 6'd8 : player1_Y_Step = 10'd3;
		6'd6, 6'd7, 6'd9, 6'd10, 6'd11, 6'd12, 6'd13, 6'd14, 6'd15, 6'd16, 6'd17, 6'd18, 6'd19, 6'd20, 6'd21, 6'd23, 6'd25, 6'd27, 6'd29, 6'd33: player1_Y_Step = 10'd2;
		6'd22, 6'd24, 6'd26, 6'd28, 6'd30, 6'd31, 6'd32, 6'd34, 6'd35, 6'd36, 6'd37, 6'd38, 6'd39, 6'd40, 6'd41, 6'd42, 6'd44, 6'd45, 6'd46, 6'd48, 6'd50, 6'd52, 6'd55, 6'd59: player1_Y_Step = 10'd1;
		6'd0, 6'd43, 6'd47, 6'd49, 6'd51, 6'd53, 6'd54, 6'd56, 6'd57, 6'd58: player1_Y_Step = 10'd0;
		endcase
	end
		
	
	
endmodule






module moving_player2(input clk,
									Reset,
									frame_clk,
//							input [9:0] DrawX, DrawY,
							input [47:0] keycode,
							output [9:0] x_begin, y_begin,
							output jump_out, walk_out
							);
							
	parameter [9:0] player1_X_Center = 10'd500;
	parameter [9:0] player1_Y_Center = 10'd370;
	parameter [9:0] player1_X_Min = 10'd320;
	parameter [9:0] player1_X_Max = 10'd575;
	parameter [9:0] player1_Y_Max = 10'd370;
	parameter [9:0] player1_Y_Min = 10'd290;
	parameter [9:0] player1_X_Step = 10'd2;
	logic [9:0] player1_Y_Step;
//	parameter [5:0] counter_jump = 6'd60;
//	parameter [5:0] counter_fall = 6'd0;
	logic w_on, a_on, s_on, d_on, up_on, down_on, left_on, right_on;
	
	keycode_reader reader(.keycode(keycode),
								 .w_on(w_on),
								 .a_on(a_on),
								 .s_on(s_on),
								 .d_on(d_on),
								 .up_on(up_on),
								 .down_on(down_on),
								 .left_on(left_on),
								 .right_on(right_on));
	logic top;
	logic top_in;
	logic jump;
	logic jump_in;
	logic walk;
	assign jump_out = jump;
	assign walk_out = walk;
	logic [5:0] counter;
	logic [5:0] counter_in;
	logic [9:0] player1_X_Motion, player1_Y_Motion, player1_X_Pos, player1_Y_Pos;
	logic [9:0] player1_X_Motion_in, player1_Y_Motion_in, player1_X_Pos_in, player1_Y_Pos_in;
	assign x_begin = player1_X_Pos;
	assign y_begin = player1_Y_Pos;
	
	logic frame_clk_delayed, frame_clk_rising_edge;
   always_ff @ (posedge clk) begin
       frame_clk_delayed <= frame_clk;
       frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
   end
   // Update ball position and motion
   always_ff @ (posedge clk)
   begin
       if (Reset)
       begin
           player1_X_Pos <= player1_X_Center;
           player1_Y_Pos <= player1_Y_Center;
           player1_X_Motion <= 10'd0;
           player1_Y_Motion <= 10'd0;
			  counter <= 0;
			  jump <= 0;
			  top <= 0;
       end
			
       else       // Update only at rising edge of frame clock
       begin
           player1_X_Pos <= player1_X_Pos_in;
           player1_Y_Pos <= player1_Y_Pos_in;
           player1_X_Motion <= player1_X_Motion_in;
           player1_Y_Motion <= player1_Y_Motion_in;
			  counter <= counter_in;
			  jump <= jump_in;
			  top <= top_in;
       end
		 if (jump == 1'b0)
		 begin
				counter <= 0;
				top <= 0;
			end
		  else 
		  begin
				counter <= counter_in;
				top <= top_in;
			end
       // By defualt, keep the register values.
   end

	 
	
	
	always_comb
	begin
		
		//Update the player's position with its motion
		player1_X_Pos_in = player1_X_Pos;
		player1_Y_Pos_in = player1_Y_Pos;
		player1_X_Motion_in = player1_X_Motion;
		player1_Y_Motion_in = player1_Y_Motion;
		counter_in = counter;
		top_in = top;
		jump_in = jump;
		walk = 1'b0;
		
		
		//Y direction needs to be changed
	if (frame_clk_rising_edge)
      begin           
				if ( player1_Y_Pos >= player1_Y_Max )		
					begin
					player1_Y_Motion_in = 0;
					player1_X_Motion_in = player1_X_Motion;
//					else if ( keycode == 8'h16 )
//						begin
//						player1_X_Motion_in = 0;
//						player1_Y_Motion_in = 0;					// S: DOWN
//						end
					if (left_on == 0 && right_on == 0)
						begin 
						player1_X_Motion_in = 0;
						end
					else if (left_on == 1'b1 && right_on == 1'b1)
						player1_X_Motion_in = 0;

					else if ( right_on == 1'b1)
						begin
						player1_X_Motion_in = player1_X_Step;	// A: LEFT
						walk = 1'b1;
						end
					else if (left_on == 1'b1)
						begin
						player1_X_Motion_in = (~(player1_X_Step) + 1'b1);					// D: RIGHT
						walk = 1'b1;
						end
					if (up_on == 1'b1)
						begin
//						player1_X_Motion_in = player1_X_Motion;
//						player1_Y_Motion_in = 0; // W: UP
						jump_in = 1'b1;
						top_in = 0;
						player1_X_Motion_in = {player1_X_Motion[9],player1_X_Motion[9:1]};
						end
					end
				if( player1_X_Pos >= player1_X_Max )
					begin
					player1_X_Motion_in = 0;
					player1_Y_Motion_in = player1_Y_Motion;
					if (player1_Y_Pos >= player1_Y_Max)
						player1_Y_Motion_in = 0;
					if ( a_on == 1'b1 && player1_Y_Pos >= player1_Y_Max)
						begin
						player1_X_Motion_in = (~(player1_X_Step) + 1'b1);	// A: LEFT
						end
					end
				if (player1_X_Pos <= player1_X_Min)
					begin
					player1_X_Motion_in = 0;
					player1_Y_Motion_in = player1_Y_Motion;
					if (player1_Y_Pos >= player1_Y_Max)
						player1_Y_Motion_in = 0;
					if (d_on == 1'b1 && player1_Y_Pos >= player1_Y_Max)
						begin
						player1_X_Motion_in = player1_X_Step;					// D: RIGHT
						end
					end
				if (jump == 1'b1)
					begin
					if (counter < 6'd59 && top == 0)
					begin
					   counter_in = counter + 1'b1;
					   player1_Y_Motion_in = (~(player1_Y_Step) + 1'b1);
						if (player1_X_Pos >= player1_X_Max || player1_X_Pos <= player1_X_Min)
							player1_X_Motion_in = 0;
						else
							player1_X_Motion_in = player1_X_Motion;
//							begin
//							if (player1_X_Motion > 10'd0)
//								player1_X_Motion_in = 10'd1;
//							else if (player1_X_Motion < 10'd0)
//								player1_X_Motion_in = {player1_X_Motion[9],player1_X_Motion[9:1]};
//							else
//								player1_X_Motion_in = 10'd0;
//							end
					end
					if (counter >= 6'd59)
						top_in = 1;
					if (counter > 0 && top == 1'b1)
					begin
						counter_in = counter - 1'b1;
						player1_Y_Motion_in = player1_Y_Step;
						if (player1_X_Pos >= player1_X_Max || player1_X_Pos <= player1_X_Min)
							player1_X_Motion_in = 0;
						else
							player1_X_Motion_in = player1_X_Motion;
//							begin
//							if (player1_X_Motion > 10'd0)
//								player1_X_Motion_in = 10'd1;
//							else if (player1_X_Motion < 10'd0)
//								player1_X_Motion_in = {player1_X_Motion[9],player1_X_Motion[9:1]};
//							else
//								player1_X_Motion_in = 10'd0;
//							end
					end
					if (counter <= 0 && top == 1'b1)
					begin
						jump_in = 0;
						top_in = 0;
					end
				end
						
						
				
            // Update the ball's position with its motion
            player1_X_Pos_in = player1_X_Pos + player1_X_Motion;
            player1_Y_Pos_in = player1_Y_Pos + player1_Y_Motion;	
			end	
	end
	
	always_comb
	begin
		player1_Y_Step = 0;
		unique case(counter)
		6'd1: player1_Y_Step = 10'd4;
		6'd2, 6'd3, 6'd4, 6'd5, 6'd8 : player1_Y_Step = 10'd3;
		6'd6, 6'd7, 6'd9, 6'd10, 6'd11, 6'd12, 6'd13, 6'd14, 6'd15, 6'd16, 6'd17, 6'd18, 6'd19, 6'd20, 6'd21, 6'd23, 6'd25, 6'd27, 6'd29, 6'd33: player1_Y_Step = 10'd2;
		6'd22, 6'd24, 6'd26, 6'd28, 6'd30, 6'd31, 6'd32, 6'd34, 6'd35, 6'd36, 6'd37, 6'd38, 6'd39, 6'd40, 6'd41, 6'd42, 6'd44, 6'd45, 6'd46, 6'd48, 6'd50, 6'd52, 6'd55, 6'd59: player1_Y_Step = 10'd1;
		6'd0, 6'd43, 6'd47, 6'd49, 6'd51, 6'd53, 6'd54, 6'd56, 6'd57, 6'd58: player1_Y_Step = 10'd0;
		endcase
	end
		
	
	
endmodule
























	 
	 
	 
	 
	 