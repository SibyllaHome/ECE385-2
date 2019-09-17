module carry_lookahead_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
   logic [3:0] p;
	logic [3:0] g;
	logic [4:0] c;
	//logic i;
	
	
	always_comb
	begin
			//c[1] = (0 & p[0]) | g[0]; 
			//c[2] = (0 & p[0] & p[1]) | (g[0] & p[1]) | g[1];
			//c[3] = (0 & p[0] & p[1] & p[2]) | (g[0] & p[1] & p[2]) | (g[1] & p[2]) | g[2];
			//CO   = (0 & p[0] & p[1] & p[2] & p[3]) | (g[0] & p[1] & p[2] & p[3]) | (g[1] & p[2] & p[3]) | (g[2] & p[3]) | g[3];
		for (int i=1; i<5; i=i+1) begin
			c[0] = 0;
			c[i] = g[i-1] | (p[i-1] & c[i-1]);
		end
		
		CO = c[4];
	end
	
	four_bit_cla cla0(.x(A[3 : 0]), .y(B[3 : 0]), .cin(1'b0), .s(Sum[3 : 0]), .pg(p[0]), .gg(g[0]));
	four_bit_cla cla1(.x(A[7 : 4]), .y(B[7 : 4]), .cin(c[1]), .s(Sum[7 : 4]), .pg(p[1]), .gg(g[1]));
	four_bit_cla cla2(.x(A[11: 8]), .y(B[11: 8]), .cin(c[2]), .s(Sum[11: 8]), .pg(p[2]), .gg(g[2]));
	four_bit_cla cla3(.x(A[15:12]), .y(B[15:12]), .cin(c[3]), .s(Sum[15:12]), .pg(p[3]), .gg(g[3]));
	
	  
endmodule

module four_bit_cla(
					input [3:0] x,
					input [3:0] y,
					input cin,
					output logic [3:0] s,
					output logic pg,
					output logic gg
					);

	logic [3:0] p;
	logic [3:0] g;
	logic [3:0] c;
	logic i;
	
	assign p = x | y;
	assign g = x & y;
	
	always_comb
	begin
	
		c[1] = (1'b0 & p[0]) | g[0]; 
		c[2] = (1'b0 & p[0] & p[1]) | (g[0] & p[1]) | g[1];
		c[3] = (1'b0 & p[0] & p[1] & p[2]) | (g[0] & p[1] & p[2]) | (g[1] & p[2]) | g[2];
		pg = (p[0] & p[1] & p[2] & p[3]);
		gg = (g[0] & p[1] & p[2] & p[3]) | (g[1] & p[2] & p[3]) | (g[2] & p[3]) | g[3];
	
		//for (i=0; i<4; i=i+1) begin
		//	g[i] = x[i] & y[i];
		//	p[i] = x[i] ^ y[i];
	 //
		//end
		//
		//for (i=1; i<4; i=i+1) begin
		//	c[0] = cin;
		//	c[i] = g[i-1] | (p[i-1] & c[i-1]);
		//end
	
	end
	
	full_adder Fa0(.x(x[0]), .y(y[0]), .cin(c[0]), .s(s[0]));
	full_adder Fa1(.x(x[1]), .y(y[1]), .cin(c[1]), .s(s[1]));
	full_adder Fa2(.x(x[2]), .y(y[2]), .cin(c[2]), .s(s[2]));
	full_adder Fa3(.x(x[3]), .y(y[3]), .cin(c[3]), .s(s[3]));
	
endmodule


