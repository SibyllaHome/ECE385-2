module toplevel(
										 input					CLOCK_50,
										 input[3:0]				KEY,
										 output logic[6:0]	HEX0, HEX1,
										 // PS/2 INPUT
										 input logic 			PS2_CLK, PS2_DAT,
										 // VGA
										 output logic [7:0]  VGA_R,        //VGA Red
																	VGA_G,        //VGA Green
																	VGA_B,        //VGA Blue
										 output logic        VGA_CLK,      //VGA Clock
																	VGA_SYNC_N,   //VGA Sync signal
																	VGA_BLANK_N,  //VGA Blank signal
																	VGA_VS,       //VGA virtical sync signal
																	VGA_HS,       //VGA horizontal sync signal
										 // CY7C67200 Interface
										 inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
										 output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
										 output logic        OTG_CS_N,     //CY7C67200 Chip Select
																	OTG_RD_N,     //CY7C67200 Write
																	OTG_WR_N,     //CY7C67200 Read
																	OTG_RST_N,    //CY7C67200 Reset
										 input               OTG_INT,      //CY7C67200 Interrupt
										 // SDRAM ON NIOS II
										 output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
										 inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
										 output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
										 output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
										 output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
																	DRAM_CAS_N,   //SDRAM Column Address Strobe
																	DRAM_CKE,     //SDRAM Clock Enable
																	DRAM_WE_N,    //SDRAM Write Enable
																	DRAM_CS_N,    //SDRAM Chip Select
																	DRAM_CLK      //SDRAM Clock
										 
										 );
										 
	 logic Reset_h, Clk;
    logic [31:0] keycode; // used for NIOS, not PS/2
	 logic [15:0] keycode2;
	 logic [47:0] full_keycode;
	 logic jump1,jump2,walk1,walk2;
	 assign full_keycode = {keycode, keycode2};
    
    assign Clk = CLOCK_50;
	 
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end
	 
	 
	 // generate VGA_CLK
	 always_ff @ (posedge Clk) begin
		if(Reset_h) begin
			VGA_CLK <= 1'b0;
		end else begin
			VGA_CLK <= ~VGA_CLK;
		end
	 end

	 
	 // USB HPI ///////////////////////////
	 logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
	 //////////////////////////////////////
	 
	 // pixel position
	 logic [9:0] POS_X, POS_Y;
	 
	 //stickman
	 logic [4:0] pixel,pixel_player1,pixel_player2;
	 logic [9:0] x_begin,y_begin;
	 logic [9:0] x_begin2,y_begin2;
	 
	 //for VGA CONTROLLER
	 logic active;   // high during active pixel drawing
	 logic screenend;
	 logic animate;
	 
	 logic [VRAM_A_WIDTH-1:0] address;
	 logic [VRAM_D_WIDTH-1:0] dataout;
	 
	 // EZ-OTG
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
	 
	 // signals for keyboard
//	 logic [7:0] keyCode;	// used for PS/2
//	 logic		 isPress;
	 // keyboard (PS/2)
//	 keyboard PS2(
//					  .Clk(Clk),
//					  .psClk(PS2_CLK),
//					  .psData(PS2_DAT),
//					  .reset(Reset_h),
//					  .keyCode(keyCode),
//					  .press(isPress));
	 
	 // test keyboard
//	 logic A;
//	 logic B;
//	 always_comb begin
//	 A = 1'b0;
//	 B = 1'b0;
//	 if(keyCode == 8'h04) begin
//		A = 1'b1;
//		B = 1'b0;
//	 end
//	 else if(keyCode == 8'h05)begin
//		A = 1'b0;
//		B = 1'b1;
//	 end
//	 end
//	 
//	 HexDriver hex0(A, HEX0);
//	 HexDriver hex1(B, HEX1);
	 
	 // NIOS II
	 final_project nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),
									  .keycode2_export(keycode2),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
	 
	 // VGA_CONTROLLER
	 VGA_controller vga_controller_instance(.*,
														 .Reset(Reset_h),
														 .DrawX(POS_X),
														 .DrawY(POS_Y),
														 //new stuff belows
														 .o_active(active),
														 .o_screenend(screenend),
														 .o_animate(animate));
														 
	 
														 
	 // Color Mapper
	 color_mapper color_mapper(.pixel_val(pixel),
										.drawX(POS_X),
										.drawY(POS_Y),
										.clk(Clk),
//					  					.finished_frogs(4'b0001),
										.VGA_R(VGA_R),
										.VGA_G(VGA_G),
										.VGA_B(VGA_B)
										);
					  
	 // player 1
	 stickman player1(.drawX(POS_X),
							.drawY(POS_Y),
							.clk(Clk),
							.*,
							.jump(jump1),
							.walk(walk1),
							.pixel_val(pixel_player1));
							
	 stickman player2(.drawX(POS_X),
							.drawY(POS_Y),
							.clk(Clk),
							.x_begin(x_begin2),
							.y_begin(y_begin2),
							.jump(jump2),
							.walk(walk2),
							.pixel_val(pixel_player2));
	 always_comb begin
		if (pixel_player1 == 5'd0)
			pixel = pixel_player2;
		else 
			pixel = pixel_player1;
	 end
		
							
	 moving_player1 Mplayer1(.clk(Clk),
									 .Reset(Reset_h),
									 .frame_clk(VGA_VS),
									 .keycode(full_keycode),
									 .*,
									 .jump_out(jump1),
									 .walk_out(walk1)
									);
	 moving_player2 Mplayer2(.clk(Clk),
									 .Reset(Reset_h),
									 .frame_clk(VGA_VS),
									 .keycode(full_keycode),
									 .x_begin(x_begin2),
									 .y_begin(y_begin2),
									 .jump_out(jump2),
									 .walk_out(walk2));
					  
//	 // ram.sv instantiate
//	 testRam testMan(.read_addr(addr),
//						  .clk(Clk),
//						  .data_out(pixel));
//	
//	 logic [18:0] addr;
//	 assign addr = POS_Y * 640 + POS_X;
			
//	 // SRAM
//	 sram #(
//        .ADDR_WIDTH(VRAM_A_WIDTH), 
//        .DATA_WIDTH(VRAM_D_WIDTH), 
//        .DEPTH(VRAM_DEPTH), 
//        .MEMFILE("game.mem"))  // bitmap to load
//        vram (
//        .i_addr(address), 
//        .i_clk(CLK), 
//        .i_write(0),  // we're always reading
//        .i_data(0), 
//        .o_data(dataout)
//    );
	 
//	 // VRAM frame buffers
    localparam SCREEN_WIDTH = 640;
    localparam SCREEN_HEIGHT = 480;
    localparam VRAM_DEPTH = SCREEN_WIDTH * SCREEN_HEIGHT; 
    localparam VRAM_A_WIDTH = 19;  // 2^19 > 640 x 480
    localparam VRAM_D_WIDTH = 6;   // colour bits per pixel
	 
//	 // load palatte
//	 reg [11:0] palette [0:63];  // 64 x 12-bit colour palette entries
//    reg [11:0] colour;
//    initial begin
//endmodule
//
//        $display("Loading palette.");
//        $readmemh("game_palette.mem", palette);  // bitmap palette to load
//    end
//	 
//	 always_ff @ (posedge CLK)
//    begin
//        address <= POS_Y * SCREEN_WIDTH + POS_X;
//
//        if (active)
//            colour <= palette[dataout];
//        else    
//            colour <= 0;
//
//        VGA_R <= colour[11:8];
//        VGA_G <= colour[7:4];
//        VGA_B <= colour[3:0];
//    end
endmodule
