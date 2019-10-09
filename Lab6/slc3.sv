//------------------------------------------------------------------------------
// Company:        UIUC ECE Dept.
// Engineer:       Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Lab 6 Given Code - SLC-3 
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015 
//    Revised 10-19-2017 
//    spring 2018 Distribution
//
//------------------------------------------------------------------------------
module slc3(
    input logic [15:0] S,
    input logic Clk, Reset, Run, Continue,
    output logic [11:0] LED,
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
    output logic CE, UB, LB, OE, WE,
    output logic [19:0] ADDR,
    inout wire [15:0] Data //tristate buffers need to be of type wire
);

// Declaration of push button active high signals
logic Reset_ah, Continue_ah, Run_ah;

assign Reset_ah = ~Reset;
assign Continue_ah = ~Continue;
assign Run_ah = ~Run;

// Internal connections
logic BEN, N, Z, P, n, z, p;
logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED;
logic GatePC, GateMDR, GateALU, GateMARMUX;
logic [1:0] PCMUX, ADDR2MUX, ALUK;
logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX;
logic MIO_EN;

//logic PC_PLUS_ONE;
logic [2:0]  SR1_MUX_OUT, DR_MUX_OUT;
logic [15:0] MDR_In;
logic [15:0] MAR, MDR, IR, PC;	
logic [15:0] PC_MUX_OUT, MDR_MUX_OUT, ADDR2_MUX_OUT, ADDR1_MUX_OUT, SR2_MUX_OUT, SR1_OUT, SR2_OUT, ALU_OUT, BUS; 	// MUX_OUTPUTs & BUS
logic [15:0] Data_from_SRAM, Data_to_SRAM;

// Signals being displayed on hex display
logic [3:0][3:0] hex_4;

logic [15:0] SEXT_5, SEXT_6, SEXT_9, SEXT_11;

//// For week 1, hexdrivers will display IR. Comment out these in week 2.
//HexDriver hex_driver3 (IR[15:12], HEX3);
//HexDriver hex_driver2 (IR[11:8], HEX2);
//HexDriver hex_driver1 (IR[7:4], HEX1);
//HexDriver hex_driver0 (IR[3:0], HEX0);

// For week 2, hexdrivers will be mounted to Mem2IO
 HexDriver hex_driver3 (hex_4[3][3:0], HEX3);
 HexDriver hex_driver2 (hex_4[2][3:0], HEX2);
 HexDriver hex_driver1 (hex_4[1][3:0], HEX1);
 HexDriver hex_driver0 (hex_4[0][3:0], HEX0);

// The other hex display will show PC for both weeks.
HexDriver hex_driver7 (PC[15:12], HEX7);
HexDriver hex_driver6 (PC[11:8], HEX6);
HexDriver hex_driver5 (PC[7:4], HEX5);
HexDriver hex_driver4 (PC[3:0], HEX4);

// Connect MAR to ADDR, which is also connected as an input into MEM2IO.
// MEM2IO will determine what gets put onto Data_CPU (which serves as a potential
// input into MDR)
assign ADDR = { 4'b00, MAR }; //Note, our external SRAM chip is 1Mx16, but address space is only 64Kx16
assign MIO_EN = ~OE;
// You need to make your own datapath module and connect everything to the datapath
// Be careful about whether Reset is active high or low
// datapath d0 (/* Please fill in the signals.... */);

// Registers:----------------------------------------------
// PC:
sixteen_register PC_reg(.Clk,
								.LoadEn(LD_PC),
								.Reset(Reset_ah),
								.Din(PC_MUX_OUT),
								.Dout(PC));

//assign PC_PLUS_ONE = PC + 16'h0001;

// MDR:
sixteen_register MDR_reg(.Clk,
								 .LoadEn(LD_MDR),
								 .Reset(Reset_ah),
								 .Din(MDR_MUX_OUT),
								 .Dout(MDR));
// MAR:								 
sixteen_register MAR_reg(.Clk,
								 .LoadEn(LD_MAR),
								 .Reset(Reset_ah),
								 .Din(BUS),
								 .Dout(MAR));

// IR:
sixteen_register IR_reg(.Clk,
								.LoadEn(LD_IR),
								.Reset(Reset_ah),
								.Din(BUS),
								.Dout(IR));
								
// MUXes:--------------------------------------------------
// PC MUX
MUX_PC pc_mux(.Din0(BUS),										// from PC + 1
				  .Din1(ADDR2_MUX_OUT + ADDR1_MUX_OUT),	// from addr2 + addr1
				  .Din2(PC + 1'b1),								// from BUS
				  .Select(PCMUX),
				  .Dout(PC_MUX_OUT));
				  
// MDR MUX:
MUX_MDR mdr_mux(.Din0(BUS),
					 .Din1(MDR_In),
					 .Select(MIO_EN),
					 .Dout(MDR_MUX_OUT));
				  
// Gate MUX (4 to 1), Gate MarMUX, Gate PC, Gate ALU, Gate MDR
MUX_GATE gate_mux(.Din0(ADDR2_MUX_OUT + ADDR1_MUX_OUT),		// output from MAR
						.Din1(PC),											// output from PC
						.Din2(ALU_OUT),									// output from ALU
						.Din3(MDR),											// output from MDR
						.Select({GateMARMUX,GatePC,GateALU,GateMDR}),
						.Dout(BUS));										// output to BUS
	
	
// ADDR2 MUX
ADDR2MUX addr2_mux(.Din0(SEXT_11),
						 .Din1(SEXT_9 ),
						 .Din2(SEXT_6 ),
					 // .The last input is all 0
						 .Select(ADDR2MUX),
						 .Dout(ADDR2_MUX_OUT));
			
// ADDR1 MUX (using parameterized module)
mux2 #(16) addr1_mux(.Din0(SR1_OUT), // select 0
							.Din1(PC), 		 // select 1
							.Select(ADDR1MUX),
							.Dout(ADDR1_MUX_OUT));
			
// SR1 MUX
mux2 #(3) sr1_mux(.Din0(IR[11:9]), // select 0
						.Din1(IR[8:6]),  // select 1
						.Select(SR1MUX),
						.Dout(SR1_MUX_OUT));
// DR MUX
mux2 #(3) dr_mux(.Din0(IR[11:9]), 		// select 0
					  .Din1(3'b111), 	// select 1
					  .Select(DRMUX),
					  .Dout(DR_MUX_OUT));
// SR2 MUX
mux2 #(16) sr2_mux(.Din0(SR2_OUT),
						 .Din1(SEXT_5),
						 .Select(SR2MUX),
						 .Dout(SR2_MUX_OUT));  // USE FOR ALU INPUT : SR2_MUX_OUT
			
// SEXT modules:--------------------------------------------
sext_input5 sext_5(.IN(IR[4:0]),
						 .OUT(SEXT_5));

sext_input6 sext_6(.IN(IR[5:0]),
						 .OUT(SEXT_6));

sext_input9 sext_9(.IN(IR[8:0]),
						 .OUT(SEXT_9));

sext_input11 sext_11(.IN(IR[10:0]),
							.OUT(SEXT_11));
// REG FILES:------------------------------------------------
REG_FILE reg_file(.Clk,
						.LD_REG,
						.Reset(Reset_ah),
						.FROM_DR_MUX(DR_MUX_OUT),
						.FROM_SR1(SR1_MUX_OUT),			
						.FROM_SR2(IR[2:0]),				// FROM SR2
						.FROM_BUS(BUS),
						.SR1_OUT,							// USE FOR ALU INPUT : SR1_OUT
						.SR2_OUT);

// ALU:-------------------------------------------------------
ALU alu(.A(SR1_OUT),
		  .B(SR2_MUX_OUT),
		  .Select(ALUK),
		  .Dout(ALU_OUT));

		  
		  
// LOGIC AND NZP :--------------------------------------------
NZP nzp(.*,
		  .Nin(N),.Zin(Z),.Pin(P),
		  .Nout(n),.Zout(z),.Pout(p));	

BEN ben(.Clk,.LD_BEN,.FROM_IR(IR[11:9]),
		  .n, .z, .p,
		  .ben(BEN)); 
// logic from BUS
always_comb
begin
 if(BUS[15])
 begin
  N = 1'b1;
  Z = 1'b0;
  P = 1'b0;
 end
 else if(BUS == 16'b0)
 begin
  N = 1'b0;
  Z = 1'b1;
  P = 1'b0;
 end
 else 
 begin
  N = 1'b0;
  Z = 1'b0;
  P = 1'b1;
 end
end

always_ff @ (posedge Clk)
begin
	if(LD_LED)
		LED <= IR[11:0];
	else
		LED <= 12'b0;
end

// Our SRAM and I/O controller
Mem2IO memory_subsystem(
    .*, .Reset(Reset_ah), .ADDR(ADDR), .Switches(S),
    .HEX0(hex_4[0][3:0]), .HEX1(hex_4[1][3:0]), .HEX2(hex_4[2][3:0]), .HEX3(hex_4[3][3:0]),
    .Data_from_CPU(MDR), .Data_to_CPU(MDR_In),
    .Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM)
);

// The tri-state buffer serves as the interface between Mem2IO and SRAM
tristate #(.N(16)) tr0(
    .Clk(Clk), .tristate_output_enable(~WE), .Data_write(Data_to_SRAM), .Data_read(Data_from_SRAM), .Data(Data)
);

// State machine and control signals
ISDU state_controller(
    .*, .Reset(Reset_ah), .Run(Run_ah), .Continue(Continue_ah),
    .Opcode(IR[15:12]), .IR_5(IR[5]), .IR_11(IR[11]),
    .Mem_CE(CE), .Mem_UB(UB), .Mem_LB(LB), .Mem_OE(OE), .Mem_WE(WE)
);

endmodule
