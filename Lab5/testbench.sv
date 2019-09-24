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
Multiplier_toplevel mult0(.*);

//Clock
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

initial begin: TEST_VECTORS
Reset 			= 0;			//Reset 			= yes
ClearA_LoadB	= 1;			//ClearA_LoadB = No
Run				= 1;			//Run 			= No
S					= 8'b11000101;		//to B

#2	Reset			= 1;			//Reset			= No

#3	ClearA_LoadB= 0;			//ClearA_LoadB = Yes -> ABCD is loaded into B, A is cleared
#4 ClearA_LoadB= 1;			//Turn off ClearA_LoadB
#4	S				= 8'b00000111;		//SWTICH			= ECEB

#5 Run			= 0;			//Run				= Yes
#5 Run			= 1;			//Turn off Run

end

endmodule
