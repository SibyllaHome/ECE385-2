module control(
					input logic Clk, Reset, ClearA_LoadB, Run, M, MP,  //M = B[0], MP = Q-1
					output logic load, shift, add, sub, Reset_Q
					);
	
	enum logic [4:0] {ST,A,AS,B,BS,C,CS,D,DS,E,ES,F,FS,G,GS,H,HS,EN} curr_state, next_state;  //ST start, EN end
	
	
	always_ff @ (posedge Clk or posedge Reset)
	begin
		if (Reset) 
			curr_state <= ST;
		else
			curr_state <= next_state;
	end
	
	always_comb
	begin
	
		next_state = curr_state;
		
		unique case (curr_state)
		
		ST : if (Run)
					next_state = A;
		A  : 		next_state = AS;
		AS	:		next_state = B;
		B  :     next_state = BS;
		BS :     next_state = C;
		C  :     next_state = CS;
		CS :     next_state = D;
		D  :     next_state = DS;
		DS :     next_state = E;
		E  :     next_state = ES;
		ES :     next_state = F;
		F  :     next_state = FS;
		FS :     next_state = G;
		G  :     next_state = GS;
		GS :     next_state = H;
		H  :     next_state = HS;
		HS :     next_state = EN;
		EN : if (~Run)
					next_state = ST;
					
		endcase
	end
	
	
	always_comb
	begin
		case(curr_state)
		
			ST, EN:
			begin
				load 	= ClearA_LoadB;
				shift = 1'b0;
				add 	= 1'b0;
				sub 	= 1'b0;
				Reset_Q = 1'b1;
			end
			
			//add or sub or do nothing
			
			A,B,C,D,E,F,G,H:
			begin
				Reset_Q = 1'b0;
				load 	= 1'b0;
				shift = 1'b0;
				if (MP == M) 
				begin
					add = 1'b0;
					sub = 1'b0;
				end 
				else if(M == 1 && MP == 0)
				begin
					add = 1'b0;
					sub = 1'b1;
				end
				else
				begin
					// if(M)
					// begin
					// add = 1'b0;
					// sub = 1'b1;
					// end
					// else
					// begin
					add = 1'b1;
					sub = 1'b0;
					// end
				end

			end
			
			//shift
			AS,BS,CS,DS,ES,FS,GS,HS:
			begin
				Reset_Q = 1'b0;
				load 	= 1'b0;
				shift = 1'b1;
				add 	= 1'b0;
				sub 	= 1'b0;
			end
			
		endcase
	end
	
endmodule
	
		
		
		
		
		
		
		
		
	
		