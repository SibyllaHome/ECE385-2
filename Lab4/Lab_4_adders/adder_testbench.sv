module testbench();

timeunit 10ns; // Half clock cycle at 50MHz

timeprecision 1ns;

//internal signals
logic Clk = 0;
logic Reset, LoadB, Run;
logic[15:0] sw;

//store result
logic[15:0] result,expected;

//error count
integer ErrorCnt = 0;

//Instantiate Lab4 Adders
lab4_adders_toplevel myAdder(.*)


//CLOCK
always begin: CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
	Clk = 0;
end

///////////////////////////TEST BEGIN///////////////////////////
initial begin: TEST_VECTORS
Reset = 0;			//reset
LoadB = 1;			//not loading B
Run = 1;				//not running
sw = 16'h00;		//switch => 0000000000000000
expected = 16'h03 //expected result = 0000000000000011

//load B
#2 LoadB = 0;
#2 sw = 16'h02;	//switch => 0000000000000010
//load A
#2 LoadB = 1;
#2 sw = 16'h01;	//switch => 0000000000000001

//start run
#3 Run = 0;

result = Sum;		//result => Sum(output from adder)
if (result == expected)
$display("SUCCESS!");
else
$display("Result != Expected");
end
endmodule

