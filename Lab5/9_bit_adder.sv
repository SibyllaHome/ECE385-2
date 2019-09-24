module nine_bit_adder_subtractor(
											input   logic[7:0]     A,
											input   logic[7:0]     B,
											input	  logic 			  fn,	// Sub: fn = 1 <--> Add: fn = 0
											output  logic[8:0]     Sum);
    


logic c0,c1;
logic[7:0] B_final;

assign B_final = (B ^ {8{fn}});

four_bit_ra f0(.x(A[3:0]), .y(B_final[3:0]), .cin(fn), .s(Sum[3:0]), .cout(c0));
four_bit_ra f1(.x(A[7:4]), .y(B_final[7:4]), .cin(c0), .s(Sum[7:4]), .cout(c1));
full_adder 	f2(.x(A[7]  ), .y(B_final[7]),	.cin(c1), .s(Sum[8]),	.cout()	);

//assign Sum[8] = A[8];


endmodule



//4 - bit ripple adder
module four_bit_ra(
						input [3:0] x,
						input [3:0] y,
						input cin,
						output logic [3:0] s,
						output logic cout
						);
						
	logic c0, c1, c2;
	
	full_adder fa0(.x(x[0]), .y(y[0]), .cin(cin), .s(s[0]), .cout(c0));
	full_adder fa1(.x(x[1]), .y(y[1]), .cin(c0 ), .s(s[1]), .cout(c1));
	full_adder fa2(.x(x[2]), .y(y[2]), .cin(c1 ), .s(s[2]), .cout(c2));
	full_adder fa3(.x(x[3]), .y(y[3]), .cin(c2 ), .s(s[3]), .cout(cout));					
endmodule

//full adder
module full_adder(
						input x,
						input y,
						input cin,
						output logic s,
						output logic cout
						);
						
	assign s    = x ^ y ^ cin;
	assign cout = (x&y) | (x&cin) | (cin&y);
	
endmodule
