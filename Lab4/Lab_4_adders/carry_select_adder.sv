module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a carry select.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
     
	  logic c0,c1,c2;
	  
	  four_bit_ra fra0(.x(A[3 : 0]), .y(B[3 : 0]), .cin( 0), .s(Sum[3 : 0]), .cout(c0));
	  four_bit_sa csa1(.x(A[7 : 4]), .y(B[7 : 4]), .cin(c0), .s(Sum[7 : 4]), .cout(c1));
	  four_bit_sa csa2(.x(A[11: 8]), .y(B[11: 8]), .cin(c1), .s(Sum[11: 8]), .cout(c2));
	  four_bit_sa csa3(.x(A[15:12]), .y(B[15:12]), .cin(c2), .s(Sum[15:12]), .cout(CO));
	  
endmodule


module four_bit_sa(
						input [3:0] x,
						input [3:0] y,
						input cin,
						output logic [3:0] s,
						output logic cout
						);
						
						
	logic c0;
	logic c1;
	logic [3:0] s0;
	logic [3:0] s1;
	
	four_bit_ra FRA0(.x(x[3 : 0]), .y(y[3 : 0]), .cin(0), .s(s0[3 : 0]), .cout(c0));
	four_bit_ra FRA1(.x(x[3 : 0]), .y(y[3 : 0]), .cin(1), .s(s1[3 : 0]), .cout(c1));
	
	always_comb
	begin
	
		if (cin == 0) begin
			cout = c0;
			s = s0;
		end else begin
			cout = c1;
			s = s1;
		end
	
	
	end
						
						
endmodule




