module testbench();

timeunit 10ns; // Half clock cycle at 50MHz

timeprecision 1ns;

//internal signals
logic Clk = 0;
logic Reset, LoadB, Run, CO;
logic[15:0] SW;

logic[6:0]      Ahex0;    // Hex drivers display both inputs to the adder.
logic[6:0]      Ahex1;
logic[6:0]      Ahex2;
logic[6:0]      Ahex3;
logic[6:0]      Bhex0;
logic[6:0]      Bhex1;
logic[6:0]      Bhex2;
logic[6:0]      Bhex3;


//store result
logic[15:0] Sum,expected;

//error count
integer ErrorCnt = 0;

//Instantiate Lab4 Adders
lab4_adders_toplevel myAdder(.*);


//CLOCK
always begin: CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
	Clk = 0;
end

///////////////////////////TEST BEGIN///////////////////////////
initial begin: TEST_VECTORS
Reset = 1;			//reset
LoadB = 0;			//not loading B
Run = 0;				//not running
SW = 16'h02;		//switch => 0000000000000010
expected = 16'h03; //expected result = 0000000000000011

#1 Reset = 0;

//load B
//#2 SW = 16'h02;	//switch => 0000000000000010
#2 LoadB = 1;
//load 
#2 SW = 16'h01;	//switch => 0000000000000001
#2 LoadB = 0;

//start run
#3 Run = 1;

if (Sum == expected)
$display("SUCCESS!");
else
$display("Result != Expected");
end
endmodule

