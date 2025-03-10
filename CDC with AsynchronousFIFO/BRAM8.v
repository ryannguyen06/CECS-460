`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2025 01:46:14 PM
// Design Name: 
// Module Name: BRAM8
// Project Name: 
// Target Devices: 
//////////////////////////////////////////////////////////////////////////////////


module BRAM8 #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4, // 2^4 = 16 locations
    parameter MEM_DEPTH = 1 << ADDR_WIDTH
)(
    input wire clk, reset,
    input wire full, empty,
    input wire [DATA_WIDTH-1:0] rd_data,
    output reg wr_en, rd_en,
    output reg [DATA_WIDTH-1:0] wr_data
);

    reg [DATA_WIDTH-1:0] bram_mem [0:MEM_DEPTH-1]; // BRAM memory array
    reg [ADDR_WIDTH-1:0] bram_addr; // Address pointer for BRAM
    reg [3:0] state;

    // Initialize BRAM with random hex values
//    integer i;
//    initial begin
//        for (i = 0; i < MEM_DEPTH; i = i + 1) begin
//            bram_mem[i] = $random & 8'hFF; // Random 8-bit hex value
//        end
//    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            wr_en <= 0;
            rd_en <= 0;
            wr_data <= 0;
            bram_addr <= 0;
        end else begin
            case (state)
                0: begin // Read data from FIFO
                    if (!empty) begin
                        rd_en <= 1;
                        state <= 1;
                    end
                end
                1: begin // Process data (BRAM access)
                    rd_en <= 0;
                    wr_data <= bram_mem[bram_addr]; // Read from BRAM
                    bram_addr <= bram_addr + 1; // Increment address
                    state <= 2;
                end
                2: begin // Write data back to FIFO
                    if (!full) begin
                        wr_en <= 1;
                        state <= 0;
                    end
                end
            endcase
        end
    end

endmodule
