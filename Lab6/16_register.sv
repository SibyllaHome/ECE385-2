module sixteen_register (input  logic Clk, LoadEn, Reset,
						  input  logic [15:0] Din,
						  output logic [15:0] Dout);
					
	always_ff @ (posedge Clk)
	begin
	
		if (Reset)
			Dout <= 16'h0;
		else if(LoadEn)
			Dout <= Din;
			
	end
	
endmodule

module REG_FILE(input logic Clk, LD_REG, Reset,
					 input logic [2:0] FROM_DR_MUX, FROM_SR1, FROM_SR2, FROM_SR1,
					 output logic [15:0] FROM_BUS, SR1_OUT, SR2_OUT);
					 
					 logic [7:0][15:0] Registers;
					 
					 always_ff @ (posedge Clk)
					 begin
								if(~Reset)
								begin
										Registers[0] <= 16h'0;
										Registers[2] <= 16h'0;
										Registers[3] <= 16h'0;
										Registers[4] <= 16h'0;
										Registers[5] <= 16h'0;
										Registers[6] <= 16h'0;
										Registers[7] <= 16h'0;
								end
								else if(LD_REG)
									case(FROM_DR_MUX)
										3'b000: Registers[0] <= FROM_BUS;
										3'b001: Registers[1] <= FROM_BUS;
										3'b010: Registers[2] <= FROM_BUS;
										3'b011: Registers[3] <= FROM_BUS;
										3'b100: Registers[4] <= FROM_BUS;
										3'b101: Registers[5] <= FROM_BUS;
										3'b110: Registers[6] <= FROM_BUS;
										3'b111: Registers[7] <= FROM_BUS;
										default:;
									endcase
					end
					
					always_comb
					begin
							case(FROM_SR1)
												3'b000 : SR1_OUT <= Registers[0];
												3'b001 :	SR1_OUT <= Registers[1];
												3'b010 : SR1_OUT <= Registers[2];
												3'b011 : SR1_OUT <= Registers[3];
												3'b100 : SR1_OUT <= Registers[4];
												3'b101 : SR1_OUT <= Registers[5];
												3'b110 : SR1_OUT <= Registers[6];
												3'b111 : SR1_OUT <= Registers[7];
												default:;
							endcase
							
							case(FROM_SR2)
												3'b000 : SR2_OUT <= Registers[0];
												3'b001 :	SR2_OUT <= Registers[1];
												3'b010 : SR2_OUT <= Registers[2];
												3'b011 : SR2_OUT <= Registers[3];
												3'b100 : SR2_OUT <= Registers[4];
												3'b101 : SR2_OUT <= Registers[5];
												3'b110 : SR2_OUT <= Registers[6];
												3'b111 : SR2_OUT <= Registers[7];
												default:;
							endcase
					end
							

					 
	