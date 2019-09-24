/* Module declaration.  Everything within the parentheses()
 * is a port between this module and the outside world */
 
module multiplier_toplevel
(
    input   logic           Clk,         // 50MHz clock is only used to get timing estimate data
    input   logic           Reset,       // From push-button 0.  Remember the button is active low (0 when pressed)
    input   logic           ClearA_LoadB,// From push-button 1
    input   logic           Run,         // From push-button 3.
    input   logic[7:0]      S,           // From slider switches
    
    // all outputs are registered
    output  logic           X,           // check if they have same sign.  Goes to the green LED to the left of the hex displays.
    output  logic[7:0]      Aval,        // Goes to the red LEDs.  You need to press "Run" before the sum shows up here.
    output  logic[7:0]      Bval,        
    output  logic[6:0]      AhexU,       // Hex drivers display both inputs to the adder.
    output  logic[6:0]      AhexL,
    output  logic[6:0]      BhexU,
    output  logic[6:0]      BhexL,
);

    /* Declare Internal Registers */
    logic[7:0]     A;  // use this as an input to your multiplier
    logic[7:0]     B;  // use this as an input to your multiplier
    
    /* Declare Internal Wires
     * Wheather an internal logic signal becomes a register or wire depends
     * on if it is written inside an always_ff or always_comb block respectivly */
    logic[7:0]      Aval_comb;
	 logic[7:0]      Bval_comb;
    logic           X_comb;
	 logic			  Q_;				//Represent for Q -1 (Shift out from B)
    logic[6:0]      AhexU_comb;
    logic[6:0]      AhexL_comb;
    logic[6:0]      BhexU_comb;
    logic[6:0]      BhexL_comb;
	 logic			  shift;			//indicating SHIFT starts
	 logic			  load_B;		//signal indicating load B and also clear A
	 logic			  A_Shift_Out;	//temporary variable hold the shift out value from A
	 logic 			  add_EN, sub_EN, fn;		//Add / Sub Enable, depends on control unit
	 logic			  reg_load;		//load data into register (2 DFF & 1 shift_reg)
	 
    /* Behavior of registers A, B, X */
    always_ff @(posedge Clk) begin
        
        if (!Reset) begin
            // if reset is pressed, clear the adder's input registers
            A <= 8'h0000;
            B <= 8'h0000;
            X <= 1'b0;
        end else if (!ClearA_LoadB) begin
            // If LoadB is pressed, copy switches to register B
            B <= S;
				A <= 8'h0000;
        end
        
        // transfer A,B and X from multiplier to output register
        // every clock cycle that Run is pressed
        if (!Run) begin
            Aval <= Aval_comb;
            Bval <= Bval_comb;
				X    <= X_comb;
        end
            // else, Aval, Bval and X maintain their previous values  
    end
	 
    //determine signal for load register//////////////////////////////////////////////////////
	 reg_load = add_EN | sub_EN;			 //whenever add / sub is operated
	 
	 //determine whether Add or Sub////////////////////////////////////////////////////////////
	 if(add_EN == 1'b1)begin
	 fn = 1'b0;							//fn = 0, operate Add
	 end
	 else if(sub_EN == 1'b1)begin
	 fn = 1'b1;							//fn = 1, operate Sub
	 end
	 //////////////////////////////////////////////////////////////////////////////////////////
	 
    /* Decoders for HEX drivers and output registers
     * Note that the hex drivers are calculated one cycle after Sum so
     * that they have minimal interfere with timing (fmax) analysis.
     * The human eye can't see this one-cycle latency so it's OK. */
    always_ff @(posedge Clk) begin
        
        AhexU <= AhexU_comb;
        AhexL <= AhexL_comb;
        BhexU <= BhexU_comb;
        BhexL <= BhexL_comb;
        
    end
    //////////////////////////////////////////////////////////////////////////////////////////
    /* Module instantiation
	  * You can think of the lines below as instantiating objects (analogy to C++).
     * The things with names like Ahex0_inst, Ahex1_inst... are like a objects
     * The thing called HexDriver is like a class
     * Each time you instantate an "object", you consume physical hardware on the FPGA
     * in the same way that you'd place a 74-series hex driver chip on your protoboard 
     * Make sure only *one* adder module (out of the three types) is instantiated*/
	  
	 //instantiate modules here
		/***************************************************************************************************/
		DFF		  	  X(
					 //input
							 .Clk(Clk),
							 .load(reg_load),
							 .reset(ClearA_LoadB | Reset),
							 .B(X_comb),
					 //output
							 .D(X_comb));
							 
		/****************************************************************************************************/					 
		shift_reg8 regA(
					 //input
							 .Clk(Clk),
							 .Reset(load_B), 
							 .Shift_In(X_comb), 
							 .Load(reg_load),						//input from control unit, whenever add/sub is over, load A
							 .Shift_En(shift), 					//input from control unit
							 .D(A[7:0]),							//Data in from Adder_Subtractor
					 //output
							 .Shift_Out(A_Shift_Out),
							 .Data_Out()); 						//8 - bit A value in register here!!

		Shift_reg8 regB(
					 //input
							 .Clk(Clk),
							 .Reset(1'b0),
							 .Shift_In(A_Shift_Out),
							 .Load(load_B),						//input from control unit
							 .Shift_En(shift),					//input from control unit
							 .D(S[7:0]),				//concatenate 					*?*
					 //output
							 .Shift_Out(Q_),
							 .Data_Out());							//8 - bit B value in register here!!
							 
		/*****************************************************************************************************/					 
		DFF			Qminus(
					//input
							.Clk(Clk),
							.load(reg_load),
							.reset(ClearA_LoadB | Reset),
							.B(Q_),
					//output
							.D(Q_));
							
		/****************************************************************************************************/					 
		nine_bit_adder_subtractor ADD_SUB(
											 //input
													 .A(A[7:0]),
													 .B(S[7:0]),
													 .fn(fn),		//input from control unit to decide whether + or -
											 //output
													 .Sum(A[7:0]));
		/****************************************************************************************************/					 
		control control_unit(
							//input
									.Clk(Clk),
									.Reset(Reset),
									.ClearA_LoadB(ClearA_LoadB),
									.Run(Run),
									.M(),
									.MP(),
							//output
									.load(load_B),
									.shift(shift),
									.add(add_En),
									.sub(sub_En),
									);

	 /////////////////////////////////////////////////////////////////////////////////////////////////

    HexDriver AhexL_inst
    (
        .In0(A[3:0]),   // This connects the 4 least significant bits of 
                        // register A to the input of a hex driver named Ahex0_inst
        .Out0(AhexL_comb)
    );
    
    HexDriver AhexU_inst
    (
        .In0(A[7:4]),
        .Out0(AhexU_comb)
    );
    
    
    HexDriver BhexL_inst
    (
        .In0(B[3:0]),
        .Out0(BhexL_comb)
    );
    
    HexDriver BhexU_inst
    (
        .In0(B[7:4]),
        .Out0(BhexU_comb)
    );
    ////////////////////////////////////////////////////////////////////////////////////////////////

endmodule
