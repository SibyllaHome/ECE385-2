////////////////////////////////////// STATE MACHINE ///////////////////////////////////////////// 
 
module stateMachine(
						  input logic Clk,
						  input logic Reset,
						  input logic AES_START,
						  output logic [3:0] SELECT,
						  output logic [1:0] WORD_SELECT,
						  output logic [4:0] counter, //only in always_ff
						  output logic AES_DONE);


						  
	// all states			  
	enum logic [4:0] {WAIT, INIT_ADD_ROUND_KEY, INV_SHIFT_ROWS, INV_SUB_BYTES, INV_ADD_ROUND_KEY, INV_MIX_1, INV_MIX_2, INV_MIX_3, INV_MIX_4, DONE}STATE, NEXT_STATE;

	logic [4:0]counter_comb; // only in always_comb
	
	always_ff @ (posedge Clk)
	begin
		if(Reset)
		begin
			STATE <= WAIT;
			counter <= 5'd0; //if Reset -> counter = 0;
		end
		else
		begin
			STATE <= NEXT_STATE;
			counter <= counter_comb;
		end
	end

	// state transition
	always_comb
	begin
		NEXT_STATE = STATE;
		unique case(STATE)
		
		// WAIT ////////////////////////////////////////
		WAIT : 
		begin
				if(AES_START) NEXT_STATE = INIT_ADD_ROUND_KEY;	//TO INIT_ADD_ROUND_KEY;
				else NEXT_STATE = WAIT;
		end
		
		// INITIAL ADD ROUND KEY ///////////////////////
		INIT_ADD_ROUND_KEY : NEXT_STATE = INV_SHIFT_ROWS;
		
		// INV_SHIFT_ROWS //////////////////////////////
		INV_SHIFT_ROWS : NEXT_STATE = INV_SUB_BYTES;
		
		// INV_SUB_BYTES ///////////////////////////////
		INV_SUB_BYTES : NEXT_STATE = INV_ADD_ROUND_KEY;
		
		// ADD_ROUND_KEY ///////////////////////////////
		INV_ADD_ROUND_KEY : 
		begin
			if(counter == 5'd0) NEXT_STATE = DONE;
			else NEXT_STATE = INV_MIX_1;
		end
		
		// INV_MIX_COLUMNS 1, 2, 3, 4 //////////////////
		INV_MIX_1 : NEXT_STATE = INV_MIX_2;
		INV_MIX_2 : NEXT_STATE = INV_MIX_3;
		INV_MIX_3 : NEXT_STATE = INV_MIX_4;
		INV_MIX_4 : NEXT_STATE = INV_SHIFT_ROWS;
		
		// DONE
		DONE :
		begin
			if(AES_START) NEXT_STATE = DONE;
			else NEXT_STATE = WAIT;
		end
		endcase
	end
	
	// each state
	always_comb
	begin
	//default
	AES_DONE = 1'b0;
	SELECT = 4'b0;
	WORD_SELECT = 2'b00;
	counter_comb = counter;
	
	unique case(STATE)		
		// WAIT
		WAIT : if(AES_START) counter_comb = 4'd10; //initialize counter to 10
		
		// INIT_ADD_ROUND_KEY, When transitioned to 
		INIT_ADD_ROUND_KEY :
		begin
//			SELECT = 2'b10;
			SELECT = 4'b0001;
			counter_comb = 5'd9;
		end
		
		//	INV_SHIFT_ROWS
		INV_SHIFT_ROWS :
		begin
//			SELECT = 2'b00;
			SELECT = 4'b0010;
		end
			
		//	INV_SUB_BYTES
		INV_SUB_BYTES :
		begin
//			SELECT = 2'b01;
			SELECT = 4'b0100;
		end
		
		//	INV_ADD_ROUND_KEY
		INV_ADD_ROUND_KEY :
		begin
//			SELECT = 2'b10;
			SELECT = 4'b0001;
		end
			
		//	INV_MIX_COLUMNS
		INV_MIX_1 :
		begin
//			SELECT = 2'b11;
			SELECT = 4'b1000;
			WORD_SELECT = 2'b00;
		end
	
		INV_MIX_2 :
		begin
//			SELECT = 2'b11;
			SELECT = 4'b1000;
			WORD_SELECT = 2'b01;
		end
		
		INV_MIX_3 :
		begin
//			SELECT = 2'b11;
			SELECT = 4'b1000;
			WORD_SELECT = 2'b10;
		end
		
		INV_MIX_4 :
		begin
//			SELECT = 2'b11;
			SELECT = 4'b1000;
			WORD_SELECT = 2'b11;
			counter_comb = counter - 1;
		end

		// DONE
		DONE : AES_DONE = 1'b1;

		endcase
	end



endmodule

































