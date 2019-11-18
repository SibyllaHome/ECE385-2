module color_mapper(
	input  logic [4:0] pixel_val,
	input  logic [9:0] drawX, drawY,
	input	 logic      clk,
	output logic [7:0] VGA_R, VGA_G, VGA_B
);

logic [18:0] test_addr;
logic [7:0] test_out;
logic [7:0] R, G, B, frog_addr;


logic [4:0] pixel;

background background(.read_addr(test_addr), .clk(clk), .data_out(test_out));

pixel_decode decoder(.pixel_val(pixel), .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B));
always_comb begin
	pixel = pixel_val;
	if (pixel_val == 5'd0 && drawX >= 10'd0 && drawX < 10'd640 && drawY >= 10'd0 && drawY < 10'd480)
	begin
		test_addr = int'(drawY / 2) * 10'd320 + int'(drawX / 2);
		pixel = test_out[4:0];
	end
	else
	begin
		test_addr = 16'b0;
		pixel = pixel_val;
	end
 
end
endmodule

module pixel_decode(input logic [4:0] pixel_val,
output logic [7:0] VGA_R, VGA_G, VGA_B);

always_comb begin
unique case (pixel_val)
		5'd21: begin
			VGA_R = 8'h24;
			VGA_G = 8'h18;
			VGA_B = 8'h8A;
		end 5'd20: begin
			VGA_R = 8'h15;
			VGA_G = 8'h5E;
			VGA_B = 8'hD8;
		end 5'd19: begin
			VGA_R = 8'h65;
			VGA_G = 8'hB0;
			VGA_B = 8'hFF;
		end 5'd18: begin
			VGA_R = 8'h39;
			VGA_G = 8'h88;
			VGA_B = 8'h02;
		end 5'd17: begin
			VGA_R = 8'h88;
			VGA_G = 8'hD5;
			VGA_B = 8'h00;
		end 5'd16: begin
			VGA_R = 8'hBB;
			VGA_G = 8'hBD;
			VGA_B = 8'h00;	
		end 5'd15: begin
			VGA_R = 8'h6C;
			VGA_G = 8'h6C;
			VGA_B = 8'h01;
		end 5'd14: begin
			VGA_R = 8'h36;
			VGA_G = 8'h33;
			VGA_B = 8'h01;
		end 4'd13: begin
			VGA_R = 8'hAE;
			VGA_G = 8'hAC;
			VGA_B = 8'hAE;
		end 4'd12: begin
			VGA_R = 8'hF0;
			VGA_G = 8'hBC;
			VGA_B = 8'h3C;
		end 4'd11: begin
			VGA_R = 8'hFC;
			VGA_G = 8'hBC;
			VGA_B = 8'hB0;
		end 4'd10: begin
			VGA_R = 8'hFC;
			VGA_G = 8'h74;
			VGA_B = 8'h46;
		end 4'd09: begin
			VGA_R = 8'hD8;
			VGA_G = 8'h28;
			VGA_B = 8'h00;
		end 4'd08: begin
			VGA_R = 8'hA4;
			VGA_G = 8'h00;
			VGA_B = 8'h00;
		end 4'd07: begin
			VGA_R = 8'hBC;
			VGA_G = 8'hBC;
			VGA_B = 8'hBC;
		end 4'd06: begin
			VGA_R = 8'hFC;
			VGA_G = 8'hFC;
			VGA_B = 8'hFC;
		end 4'd05: begin
			VGA_R = 8'h00;
			VGA_G = 8'h58;
			VGA_B = 8'hF8;
		end 4'd04: begin
			VGA_R = 8'hFF;
			VGA_G = 8'hE0;
			VGA_B = 8'hA8;
		end 4'd03: begin
			VGA_R = 8'h50;
			VGA_G = 8'h30;
			VGA_B = 8'h00;
		end 4'd02: begin
			VGA_R = 8'hF0;
			VGA_G = 8'hD0;
			VGA_B = 8'hB0;
		end 4'd01: begin
			VGA_R = 8'hF8;
			VGA_G = 8'h38;
			VGA_B = 8'h00;
		end 4'd00: begin
			VGA_R = 8'hFF;
			VGA_G = 8'h00;
			VGA_B = 8'h00;
		end default: begin
			VGA_R = 8'h0;
			VGA_G = 8'h0;
			VGA_B = 8'h0;
		end
	endcase
end

endmodule
