///************************************************************************
//Avalon-MM Interface for AES Decryption IP Core
//
//Dong Kai Wang, Fall 2017
//
//For use with ECE 385 Experiment 9
//University of Illinois ECE Department
//
//Register Map:
//
// 0-3 : 4x 32bit AES Key
// 4-7 : 4x 32bit AES Encrypted Message
// 8-11: 4x 32bit AES Decrypted Message
//   12: Not Used
//	13: Not Used
//   14: 32bit Start Register
//   15: 32bit Done Register
//
//************************************************************************/
//
//module avalon_aes_interface (
//	// Avalon Clock Input
//	input logic CLK,
//	
//	// Avalon Reset Input
//	input logic RESET,
//	
//	// Avalon-MM Slave Signals
//	input  logic AVL_READ,					// Avalon-MM Read
//	input  logic AVL_WRITE,					// Avalon-MM Write
//	input  logic AVL_CS,						// Avalon-MM Chip Select
//	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
//	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
//	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
//	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
//	
//	// Exported Conduit
//	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
//);
//	
//
//	
//	logic[31:0] reg_file[15:0];
//	logic[31:0] reg_temp[15:0];
//	//
//	always_ff @ (posedge CLK)
//	begin
//		for(int i = 0; i < 16; i++)
//		begin
//			if(RESET) reg_file[i] <= 32'b0;	
//			else reg_file[i] = reg_temp[i];
//		end
//	end
//	
//	
//	always_comb
//	begin
//		if(AVL_CS)
//		begin
//			for(int i = 0; i < 16; i++)
//			begin
//				reg_temp[i] = reg_file[i];
//				if(AVL_WRITE && AVL_ADDR == i)
//				begin
//					if(AVL_BYTE_EN[3]) reg_temp[i] [31:24] = AVL_WRITEDATA[31:24];
//					if(AVL_BYTE_EN[2]) reg_temp[i] [23:16] = AVL_WRITEDATA[23:16];
//					if(AVL_BYTE_EN[1]) reg_temp[i] [15:8]  = AVL_WRITEDATA[15:8];
//					if(AVL_BYTE_EN[0]) reg_temp[i] [7:0]   = AVL_WRITEDATA[7:0];
//				end
//			end
//		end
//	end
//	
//		assign EXPORT_DATA[31:16] = reg_file[0][31:16];
//		assign EXPORT_DATA[15:0] = reg_file[3][15:0];
//
//
//endmodule






/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

 0-3 : 4x 32bit AES Key
 4-7 : 4x 32bit AES Encrypted Message
 8-11: 4x 32bit AES Decrypted Message
   12: Not Used
	13: Not Used
   14: 32bit Start Register
   15: 32bit Done Register

************************************************************************/

module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	
	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);

    logic [31:0] reg_file [0:15];
	 logic [31:0] reg_temp [0:15];
	 
	 logic AES_DONE;
	 logic [127:0] AES_MSG_DEC;
	 
	 always_ff @ (posedge CLK) begin
	     for(int j = 0; j < 16; j++) begin
		      if(RESET) reg_file[j] <= 32'b0;
				else reg_file[j] <= reg_temp[j];
		  end
	 end
	 
	 always_comb begin
	     AVL_READDATA = 32'bX;
	     for(int i = 0; i < 16; i++) begin
		      reg_temp[i] = reg_file[i];
				if(AVL_ADDR == i && AVL_CS) begin
				    if(AVL_READ) AVL_READDATA = reg_file[i];
					 if(AVL_WRITE) begin
					     if(AVL_BYTE_EN[3]) reg_temp[i] [31:24] = AVL_WRITEDATA[31:24];
						  if(AVL_BYTE_EN[2]) reg_temp[i] [23:16] = AVL_WRITEDATA[23:16];
						  if(AVL_BYTE_EN[1]) reg_temp[i] [15:8]  = AVL_WRITEDATA[15:8];
						  if(AVL_BYTE_EN[0]) reg_temp[i] [7:0]   = AVL_WRITEDATA[7:0];
					 end
				end
		  end
		  
		  reg_temp[15] = {31'b0, AES_DONE};
		  reg_temp[8]  = AES_MSG_DEC[31:0];
		  reg_temp[9]  = AES_MSG_DEC[63:32];
		  reg_temp[10] = AES_MSG_DEC[95:64];
		  reg_temp[11] = AES_MSG_DEC[127:96];
		  
	 end

	 assign EXPORT_DATA[31:16] = reg_file[0][31:16];
	 assign EXPORT_DATA[15:0]  = reg_file[3][15:0];
	 
	 
	 AES decryption(.CLK(CLK), .RESET(RESET), .AES_START(reg_file[14][0]), .AES_DONE(AES_DONE),
						 .AES_KEY({reg_file[0], reg_file[1], reg_file[2], reg_file[3]}),
						 .AES_MSG_ENC({reg_file[4], reg_file[5], reg_file[6], reg_file[7]}),
						 .AES_MSG_DEC(AES_MSG_DEC));
	 

endmodule

