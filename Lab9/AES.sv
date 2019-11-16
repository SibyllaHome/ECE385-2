//////////////////////////////////////////////// AES ////////////////////////////////////////////////////////////
module AES (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC
);


	logic [3:0] Select;
	logic [1:0] word_select;
	logic [1407:0] KEY_SCHEDULE;
	logic [127:0] state;
	logic [127:0] state_isr;
	logic [31:0] word_in;
	logic [31:0] word_out;
	logic [127:0] key;
	logic [127:0] state_key;
	logic [127:0] state_sub;
	logic [127:0] next_state;
	logic [4:0] count;
	logic load;
	
	InvSubBytes sub0 (.clk(CLK), .in(state[7:0]),     .out(state_sub[7:0]));
	InvSubBytes sub1 (.clk(CLK), .in(state[15:8]),    .out(state_sub[15:8]));
	InvSubBytes sub2 (.clk(CLK), .in(state[23:16]),   .out(state_sub[23:16]));
	InvSubBytes sub3 (.clk(CLK), .in(state[31:24]),   .out(state_sub[31:24]));
	InvSubBytes sub4 (.clk(CLK), .in(state[39:32]),   .out(state_sub[39:32]));
	InvSubBytes sub5 (.clk(CLK), .in(state[47:40]),   .out(state_sub[47:40]));
	InvSubBytes sub6 (.clk(CLK), .in(state[55:48]),   .out(state_sub[55:48]));
	InvSubBytes sub7 (.clk(CLK), .in(state[63:56]),   .out(state_sub[63:56]));
	InvSubBytes sub8 (.clk(CLK), .in(state[71:64]),   .out(state_sub[71:64]));
	InvSubBytes sub9 (.clk(CLK), .in(state[79:72]),   .out(state_sub[79:72]));
	InvSubBytes sub10(.clk(CLK), .in(state[87:80]),   .out(state_sub[87:80]));
	InvSubBytes sub11(.clk(CLK), .in(state[95:88]),   .out(state_sub[95:88]));
	InvSubBytes sub12(.clk(CLK), .in(state[103:96]),  .out(state_sub[103:96]));
	InvSubBytes sub13(.clk(CLK), .in(state[111:104]), .out(state_sub[111:104]));
	InvSubBytes sub14(.clk(CLK), .in(state[119:112]), .out(state_sub[119:112]));
	InvSubBytes sub15(.clk(CLK), .in(state[127:120]), .out(state_sub[127:120]));
		

	stateMachine SM(.Clk(CLK), .Reset(RESET), .AES_START(AES_START), .SELECT(Select), .WORD_SELECT(word_select), .AES_DONE(AES_DONE),.counter(count));
	KeyExpansion expanison(.clk(CLK), .Cipherkey(AES_KEY), .KeySchedule(KEY_SCHEDULE));
	InvShiftRows ISR(.data_in(state), .data_out(state_isr));
	InvMixColumns IMC(.in(word_in), .out(word_out));
	InvAddRoundKey IARK(.INPUT(state), .ROUNDKEY(key), .OUTPUT(state_key));

	always_ff @ (posedge CLK) begin
		if(RESET) begin
			state <= 128'b0;
			AES_MSG_DEC <= 128'b0;
			load <= 1'b0;
		end
		else begin
			if (AES_START && !load) begin
				state <= AES_MSG_ENC;
				load <= 1'b1;
			end
			else if(!AES_START) load <= 1'b0;
			else begin
				load <= load;
				AES_MSG_DEC <= next_state;
				state <= next_state;
			end
		end
	end
	
	
	

	
	
	always_comb 
	begin
		word_in = state[31:0];
		unique case(word_select)
			2'b00: word_in = state[31:0];
			2'b01: word_in = state[63:32]; 
         2'b10: word_in = state[95:64]; 
         2'b11: word_in = state[127:96];
		endcase
	end
	
	
		always_comb
	begin
		key = KEY_SCHEDULE[127:0];
		unique case(count)
			5'd10: key = KEY_SCHEDULE[127:0];
			5'd9:  key = KEY_SCHEDULE[255:128];
			5'd8:  key = KEY_SCHEDULE[383:256];
			5'd7:  key = KEY_SCHEDULE[511:384];
			5'd6:  key = KEY_SCHEDULE[639:512];
			5'd5:  key = KEY_SCHEDULE[767:640];
			5'd4:  key = KEY_SCHEDULE[895:768];
			5'd3:  key = KEY_SCHEDULE[1023:896];
			5'd2:  key = KEY_SCHEDULE[1151:1024];
			5'd1:  key = KEY_SCHEDULE[1279:1152];
			5'd0:  key = KEY_SCHEDULE[1407:1280];
		endcase
		
	end
	
	
	
	always_comb 
	begin
		next_state = state;
		case(Select)
			4'b0010: next_state = state_isr;
			4'b0100: next_state = state_sub;
			4'b0001: next_state = state_key;
			4'b1000: begin
				unique case(word_select)
					2'b00: next_state[31:0]   = word_out;
					2'b01: next_state[63:32]  = word_out;
					2'b10: next_state[95:64]  = word_out;
					2'b11: next_state[127:96] = word_out;
				endcase
				end
		endcase
	end
	
endmodule

