//4-bit logic processor top level module
//for use with ECE 385 Fall 2016
//last modified by Zuofu Cheng


//Always use input/output logic types when possible, prevents issues with tools that have strict type enforcement

module Processor (input logic   Clk,     // Internal
                                Reset,   // Push button 0
                                LoadA,   // Push button 1
                                LoadB,   // Push button 2
                                Execute, // Push button 3
                  input  logic [7:0]  Din,     // input data
                  input  logic [2:0]  F,       // Function select
                  input  logic [1:0]  R,       // Routing select
                  output logic [3:0]  LED,     // DEBUG
                  output logic [7:0]  Aval,    // DEBUG
												  Bval,    // DEBUG
                  output logic [6:0]  AhexL,
												  AhexU,
                                      BhexL,
                                      BhexU);

	 //local logic variables go here
	 logic Reset_SH, LoadA_SH, LoadB_SH, Execute_SH;
	 logic [2:0] F_S;
	 logic [1:0] R_S;
	 logic Ld_A, Ld_B, newA, newB, opA_upper, opA_lower, opB_upper, opB_lower, bitA, bitB, Shift_En,
	       F_A_B;
	 logic [7:0] A, B, Din_S;
	 
	 
	 //We can use the "assign" statement to do simple combinational logic
	 assign Aval = A;
	 assign Bval = B;
	 assign LED = {Execute_SH,LoadA_SH,LoadB_SH,Reset_SH}; //Concatenate is a common operation in HDL
	 
	 //Instantiation of modules here
	 
	 /******************************************************************************************************************
	  *																																				    *
	  *				<----------------------------------------------------------------------------------------			    *
	  *				|-->   reg_unit_upper   ->   reg_unit_lower   ->   compute_unit   ->   routing_unit   ->|			    *
	  *																																				    *
	  *		pin:	 (new A/B)			(opA/B_upper)				(opA/B_lower)			(bit A/B)				(new A/B)	    *
	  *			 																																	    *
	  ******************************************************************************************************************/
	 register_unit    reg_unit_upper (
                        .Clk(Clk),
                        .Reset(Reset_SH),
                        .Ld_A(LoadA_SH), //note these are inferred assignments, because of the existence a logic variable of the same name
                        .Ld_B(LoadB_SH),
                        .Shift_En,
                        .D(Din_S[7:4]),
                        .A_In(newA),
                        .B_In(newB),
                        .A_out(opA_upper),
                        .B_out(opB_upper),
                        .A(A[7:4]),
                        .B(B[7:4]) );
								
	 register_unit		reg_unit_lower(
								.Clk(Clk),
								.Reset(Reset_SH),
								.Ld_A(LoadA_SH),
								.Ld_B(LoadB_SH),
								.Shift_En,
								.D(Din_S[3:0]),
								.A_In(opA_upper),
								.B_In(opB_upper),
								.A_out(opA_lower),
								.B_out(opB_lower),
								.A(A[3:0]),
								.B(B[3:0]) );
								
    compute          compute_unit (
								.F(F_S),
                        .A_In(opA_lower),
                        .B_In(opB_lower),
                        .A_Out(bitA),
                        .B_Out(bitB),
                        .F_A_B );
								
    router           router (
								.R(R_S),
                        .A_In(bitA),
                        .B_In(bitB),
                        .A_Out(newA),
                        .B_Out(newB),
                        .F_A_B );
								
	 control          control_unit (
                        .Clk(Clk),
                        .Reset(Reset_SH),
                        .LoadA(LoadA_SH),
                        .LoadB(LoadB_SH),
                        .Execute(Execute_SH),
                        .Shift_En,
                        .Ld_A,
                        .Ld_B );
								
	 HexDriver        HexAL (
                        .In0(A[3:0]),
                        .Out0(AhexL) );
								
	 HexDriver        HexBL (
                        .In0(B[3:0]),
                        .Out0(BhexL) );
								
	 //When you extend to 8-bits, you will need more HEX drivers to view upper nibble of registers, for now set to 0
	 HexDriver        HexAU (
                        .In0(A[7:4]),
                        .Out0(AhexU) );	
								
	 HexDriver        HexBU (
                       .In0(B[7:4]),
                        .Out0(BhexU) );
								
	  //Input synchronizers required for asynchronous inputs (in this case, from the switches)
	  //These are array module instantiations
	  //Note: S stands for SYNCHRONIZED, H stands for active HIGH
	  //Note: We can invert the levels inside the port assignments
	  sync button_sync[3:0] (Clk, {~Reset, ~LoadA, ~LoadB, ~Execute}, {Reset_SH, LoadA_SH, LoadB_SH, Execute_SH});
	  sync Din_sync[7:0] (Clk, Din[7:0], Din_S[7:0]);
	  sync F_sync[2:0] (Clk, F, F_S);
	  sync R_sync[1:0] (Clk, R, R_S);
	  
endmodule
