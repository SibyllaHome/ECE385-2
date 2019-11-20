
module stickman2 ( input     Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					input [31:0]  keycode,				 // represent for key input 8 bits
               output [9:0]   x_begin, y_begin,       // Current pixel coordinates
					output [7:0]	cnt
              );
    
    parameter [9:0] Ball_X_Center = 10'd100;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center = 10'd365;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min = 10'd25;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max = 10'd280;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min = 10'd290;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max = 10'd365;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step = 10'd1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step = 10'd1;      // Step size on the Y axis
    parameter [9:0] Ball_Size = 10'd4;        // Ball size
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in, Gravity_in;
    
	 assign x_begin = Ball_X_Pos;
	 assign y_begin = Ball_Y_Pos;
	 
	 logic [7:0] counter,counter_in;
	 assign cnt = counter;
	 
	 logic w, a, s, d;
	 keycode_reader key_reader(.keycode(keycode),
										 .w_on(w),
										 .a_on(a),
										 .s_on(s),
										 .d_on(d)
										 );
	 
	 
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
	 
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Ball_X_Pos <= Ball_X_Center;
            Ball_Y_Pos <= Ball_Y_Center;
            Ball_X_Motion <= 10'd0;
            Ball_Y_Motion <= Ball_Y_Step;
				counter <= 7'd0;
        end
        else
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
            Ball_X_Motion <= Ball_X_Motion_in;
            Ball_Y_Motion <= Ball_Y_Motion_in;
				counter <= counter_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        Ball_X_Pos_in = Ball_X_Pos;
        Ball_Y_Pos_in = Ball_Y_Pos;
        Ball_X_Motion_in = Ball_X_Motion;
        Ball_Y_Motion_in = Ball_Y_Motion;
		  Gravity_in = 10'd0;
		  counter_in = 7'd0;
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
//				Ball_Y_Motion_in = Ball_Y_Motion + Gravity_in;
//            // Be careful when using comparators with "logic" datatype because compiler treats 
//            //   both sides of the operator as UNSIGNED numbers.
//            // e.g. Ball_Y_Pos - Ball_Size <= Ball_Y_Min 
//            // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.
//            if( Ball_Y_Pos >= Ball_Y_Max )  				// Ball is at the bottom edge, BOUNCE!
//					begin
//					Ball_X_Motion_in = 10'b0;
//					Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // 2's complement.
//					
//					end
//            else if ( Ball_Y_Pos <= Ball_Y_Min) 		// Ball is at the top edge, BOUNCE!
//               begin
//					Ball_X_Motion_in = 10'b0;
//					Ball_Y_Motion_in = Ball_Y_Step;
//					end
//            // TODO: Add other boundary detections and handle keypress here.
//				else if ( Ball_X_Pos>= Ball_X_Max )		// Ball is at the right edge!
//					begin
//					Ball_Y_Motion_in = 10'b0;
//					Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);  // 2's complement
//					end
//				else if ( Ball_X_Pos <= Ball_X_Min )		// Ball is at the left edge!
//					begin
//					Ball_Y_Motion_in = 10'b0;
//					Ball_X_Motion_in = Ball_X_Step;
//					end
//					 
//				// handling keycode WASD
//				else 
//					begin
//					if ( w == 1'b1 && counter == 10'd0 )
//						begin
//						counter_in = 7'd30;
//						Ball_X_Motion_in = 0;
//						Gravity_in = 10'd1;
//						Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1); // W: UP
//						end
//					else if ( s == 1'b1 )
//						begin
//						Ball_X_Motion_in = 0;
//						Gravity_in = 10'd1;
//						Ball_Y_Motion_in = Ball_Y_Step + Gravity_in;								// S: DOWN (Don't need)
//						end
//					else if ( a == 1'b1)
//						begin
//						Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);	// A: LEFT
//						end
//					else if ( d == 1'b1)
//						begin
//						Ball_X_Motion_in = Ball_X_Step;					// D: RIGHT
//						end
//					else if ( w == 1'b0 && a == 1'b0 && s == 1'b0 && d == 1'b0 && counter == 10'd0)
//						begin
//						Ball_Y_Motion_in = 0;
//						Ball_X_Motion_in = 0; //stop
//						end
//					end
//            // Update the ball's position with its motion
//            Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
//            Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
//				counter_in = counter_in - 1;
//        end
//			Ball_Y_Motion_in = Ball_Y_Motion + 1;
//			Ball_X_Motion_in = Ball_X_Motion;
//			if(w)begin
//				if(Ball_Y_Pos >= Ball_Y_Max) begin
//					Ball_Y_Motion_in = (~Ball_Y_Step) + 1'b1;
//				end
//				else if(Ball_Y_Pos < Ball_Y_Max)begin
//					
//				end
			end
    end
    
    
endmodule
