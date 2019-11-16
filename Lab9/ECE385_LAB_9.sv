module AES_test_top(
						  input logic CLK,
						  input logic RESET,
						  input logic [127:0]KEY,
						  input  logic [127:0] AES_MSG_ENC,
						  output logic [127:0] AES_MSG_DEC
						  );
						  
AES Decryptor