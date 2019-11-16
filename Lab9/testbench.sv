module testbench();

timeunit 10ns;

timeprecision 1ns;

logic CLK = 0;
logic RESET, AES_START;
logic AES_DONE;
logic [127:0] AES_KEY;
logic [127:0] AES_MSG_ENC;
logic [127:0] AES_MSG_DEC;

AES decryptor(.*);

//toggle clock
always begin : CLOCK_GENERATION
#1 CLK = ~CLK;
end

initial begin : CLOCK_INITIALIZATION
	CLK = 0;
end

initial begin : TEST_VECTORS

AES_KEY 		= 128'h000102030405060708090a0b0c0d0e0f;//0004080c0105090d02060a0e03070b0f;
AES_MSG_ENC = 128'hdaec3055df058e1c39e814ea76f6747e;//dadf3976ec05e8f6308e1474551cea7e;
#20 RESET = 1;
#2 AES_START = 0;
#2 RESET = 0;


// initialize key
//#2 AES_KEY 		= 128'h0004080c0105090d02060a0e03070b0f;
//#2 AES_MSG_ENC = 128'hdaec3055df058e1c39e814ea76f6747e;


// Run
#2 AES_START = 1;
#250 AES_START = 0;
end
endmodule
