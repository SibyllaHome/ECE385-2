module testbench();

timeunit 10ns;

timeprecision 1ns;

logic Clk = 0;
logic Reset, ClearA_LoadB, Run, X;
logic [7:0]S;
logic [7:0] Aval,
				Bval;
logic [6:0] AhexL,
				AhexU,
				BhexL,
				BhexU; 
logic [15:0] concatenated;
Multiplier_toplevel mult0(.*);

assign concatenated[15:8] 	 = Aval;
assign concatenated[7:0]	 = Bval;

//Clock
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

initial begin: TEST_VECTORS
Reset 			 = 0;			//Reset 			= yes
ClearA_LoadB	 = 1;			//ClearA_LoadB = No
Run				 = 1;			//Run 			= No
// -59 * 7  = -413 ///////////////////////////////////////////////////////////////////////////////
S					 = 8'b11100101;		//to B

#2	Reset			 = 1;			//Reset			= No

#2	ClearA_LoadB = 0;			//ClearA_LoadB = Yes -> ABCD is loaded into B, A is cleared
#2 ClearA_LoadB = 1;			//Turn off ClearA_LoadB
#2	S				 = 8'b00000111;		//SWTICH			= ECEB


#2 Run			 = 0;			//Run				= Yes
#2 Run			 = 1;			//Turn off Run
///  45 * 69 = 3105 /////////////////////////////////////////////////////////////////////////////////////////
#50 S				 = 8'b00000111;	
#2 ClearA_LoadB = 0;
#2 ClearA_LoadB = 1;
#2 S				 = 8'b11100101;
#2 Run			 = 0;			//Run				= Yes
#2 Run			 = 1;			//Turn off Run
// -23 * -124 = 2852 /////////////////////////////////////////////////////////////////////////////////
#50 S 				 = 8'b11100101;
#2 ClearA_LoadB = 0;
#2 ClearA_LoadB = 1;
#2 S 				 = 8'b11101010;
#2 Run			 = 0;			//Run				= Yes
#2 Run			 = 1;			//Turn off Run
// 25 * -86 = -2150  //////////////////////////////////////////////////////////////////////////////////
#50 S				 = 8'b00011001;
#2 ClearA_LoadB = 0;
#2 ClearA_LoadB = 1;
#2 S				 = 8'b00000101;
#2 Run			 = 0;			//Run				= Yes
#2 Run			 = 1;			//Turn off Run
end

endmodule
