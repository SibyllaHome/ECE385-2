/* Module declaration.  Everything within the parentheses()
 * is a port between this module and the outside world */
 
module Multiplier_toplevel
(
    input   logic           Clk,         // 50MHz clock is only used to get timing estimate data
    input   logic           Reset,       // From push-button 0.  Remember the button is active low (0 when pressed)
    input   logic           ClearA_LoadB,// From push-button 2.
    input   logic           Run,         // From push-button 3.
    input   logic[7:0]      S,           // From slider switches
    
    // all outputs are registered
    output  logic           X,           // check if they have same sign.  Goes to the green LED to the left of the hex displays.
    output  logic[7:0]      Aval,        // Goes to the red LEDs.  You need to press "Run" before the sum shows up here.
    output  logic[7:0]      Bval,        
    output  logic[6:0]      AhexU,       // Hex drivers display both inputs to the adder.
    output  logic[6:0]      AhexL,
    output  logic[6:0]      BhexU,
    output  logic[6:0]      BhexL
);

    /* Declare Internal Registers */
    logic[7:0]     A;  // use this as an input to your multiplier
    logic[7:0]     B;  // use this as an input to your multiplier
    
    /* Declare Internal Wires
     * Wheather an internal logic signal becomes a register or wire depends
     * on if it is written inside an always_ff or always_comb block respectivly */
//    logic[7:0]      Aval_comb;
//	   logic[7:0]      Bval_comb;
//    logic           X_comb;
//    logic[6:0]      AhexU_comb;
//    logic[6:0]      AhexL_comb;
//    logic[6:0]      BhexU_comb;
//    logic[6:0]      BhexL_comb;
	 logic			  Q_,Q;					//Represent for Q -1 (Shift out from B)
	 logic			  shift;					//indicating SHIFT starts
	 logic			  load_B;				//signal indicating load B and also clear A
	 logic			  A_Shift_Out;			//temporary variable hold the shift out value from A
	 logic 			  add_EN, sub_EN;		//Add / Sub Enable, depends on control unit
	 logic[8:0]      XA;
	 logic Reset_SH, ClearA_LoadB_SH, Run_SH;	 //X + [7:0]A
    /* Behavior of registers A, B, X */
//    always_ff @(posedge Clk) begin
//        
//        if (!Reset) begin
//            // if reset is pressed, clear the adder's input registers
//            A <= 8'h0000;
//            B <= 8'h0000;
//            X <= 1'b0;
//        end else if (!ClearA_LoadB) begin
//            // If LoadB is pressed, copy switches to register B
//            B <= S;
//				A <= 8'h0000;
//        end
//        
//        // transfer A,B and X from multiplier to output register
//        // every clock cycle that Run is pressed
//        if (!Run) begin
//            Aval <= Aval_comb;
//            Bval <= Bval_comb;
//				X    <= X_comb;
//        end
//            // else, Aval, Bval and X maintain their previous values  
//    end
//	 
//    //determine signal for load register//////////////////////////////////////////////////////
//	 assign reg_load = add_EN | sub_EN;			 //whenever add / sub is operated
//	 
//	 //determine whether Add or Sub////////////////////////////////////////////////////////////
//	always_comb 
//	begin
//	
//		 if(add_EN == 1'b1)begin
//		 fn = 1'b0;							//fn = 0, operate Add
//		 end
//		 else if(sub_EN == 1'b1)begin
//		 fn = 1'b1;							//fn = 1, operate Sub
//		 end
//	end
//	
//	 //////////////////////////////////////////////////////////////////////////////////////////
//	 
//    /* Decoders for HEX drivers and output registers
//     * Note that the hex drivers are calculated one cycle after Sum so
//     * that they have minimal interfere with timing (fmax) analysis.
//     * The human eye can't see this one-cycle latency so it's OK. */
//    always_ff @(posedge Clk) begin
//        
//        AhexU <= AhexU_comb;
//        AhexL <= AhexL_comb;
//        BhexU <= BhexU_comb;
//        BhexL <= BhexL_comb;
//        
//    end
    //////////////////////////////////////////////////////////////////////////////////////////
    /* Module instantiation
	  * You can think of the lines below as instantiating objects (analogy to C++).
     * The things with names like Ahex0_inst, Ahex1_inst... are like a objects
     * The thing called HexDriver is like a class
     * Each time you instantate an "object", you consume physical hardware on the FPGA
     * in the same way that you'd place a 74-series hex driver chip on your protoboard 
     * Make sure only *one* adder module (out of the three types) is instantiated*/
	  assign Aval = A;
	  assign Bval = B;
	 //instantiate modules here
		/***************************************************************************************************/
		DFlip 		bitX(
					 //input
							 .Clk(Clk),
							 .load(add_EN | sub_EN),
							 .reset(load_B | Reset_SH),
							 .B(XA[8]),
					 //output
							 .D(X));
							 
		/****************************************************************************************************/					 
		shift_reg8 regA(
					 //input
							 .Clk(Clk),
							 .Reset(load_B | Reset_SH), 
							 .Shift_In(X), 
							 .Load(add_EN | sub_EN),			//input from control unit, whenever add/sub is over, load A
							 .Shift_En(shift), 					//input from control unit
							 .D(XA[7:0]),							//Data in from Adder_Subtractor
					 //output
							 .Shift_Out(A_Shift_Out),
							 .Data_Out(A)); 						//8 - bit A value in register here!!

		shift_reg8 regB(
					 //input
							 .Clk(Clk),
							 .Reset(Reset_SH),
							 .Shift_In(A_Shift_Out),
							 .Load(load_B),						//input from control unit
							 .Shift_En(shift),				//input from control unit
							 .D(S),								//concatenate 					
					 //output
							 .Shift_Out(Q_),
							 .Data_Out(B));					//8 - bit B value in register here!!
							 
		/*****************************************************************************************************/					 
		DFlip			Qminus(
					//input
							.Clk(Clk),
							.load(shift),
							.reset(ClearA_LoadB | Reset_SH),
							.B(Q_),
					//output
							.D(Q));
							
		/****************************************************************************************************/					 
		nine_bit_adder_subtractor ADD_SUB(
											 //input
													 .A(A),
													 .B(S),
													 .fn(sub_EN),		//input from control unit to decide whether + or -
											 //output
													 .Sum(XA));
		/****************************************************************************************************/					 
		control control_unit(
							//input
									.Clk(Clk),
									.Reset(Reset),
									.ClearA_LoadB(ClearA_LoadB_SH),
									.Run(Run_SH),
									.M(B[0]),
									.MP(Q),
							//output
									.load(load_B),
									.shift(shift),
									.add(add_EN),
									.sub(sub_EN));

	 /////////////////////////////////////////////////////////////////////////////////////////////////

    HexDriver AhexL_inst
    (
        .In0(A[3:0]),   // This connects the 4 least significant bits of 
                        // register A to the input of a hex driver named Ahex0_inst
        .Out0(AhexL)
    );
    
    HexDriver AhexU_inst
    (
        .In0(A[7:4]),
        .Out0(AhexU)
    );
    
    
    HexDriver BhexL_inst
    (
        .In0(B[3:0]),
        .Out0(BhexL)
    );
    
    HexDriver BhexU_inst
    (
        .In0(B[7:4]),
        .Out0(BhexU)
    );
	 
	 
	 sync button_sync[2:0]
	(
		Clk,
		{~Reset, ~ClearA_LoadB, ~Run},
		{Reset_SH, ClearA_LoadB_SH, Run_SH}
	);

    ////////////////////////////////////////////////////////////////////////////////////////////////

endmodule
