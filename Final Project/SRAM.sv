module sram #(parameter ADDR_WIDTH, DATA_WIDTH, DEPTH, MEMFILE) (
    input logic CLK,
    input logic [ADDR_WIDTH-1:0] address, 
    input logic write,
    input logic [DATA_WIDTH-1:0] data,
    output logic [DATA_WIDTH-1:0] output_data 
    );

    logic [DATA_WIDTH-1:0] memory [0:DEPTH-1]; 

    initial begin
        if (MEMFILE > 0)
        begin
            $display("Loading memory init file '" + MEMFILE + "' into array.");
            $readmemh(MEMFILE, memory);
        end
    end

    always_ff @ (posedge CLK)
    begin
        if(write) begin
            memory[address] <= data;
        end
        else begin
            output_data <= memory[address];
        end     
    end
endmodule