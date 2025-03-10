`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineer: 
// 
// Create Date: 03/02/2025 08:34:18 PM
// Design Name: async_FIFO
// Module Name: async_FIFO
// Project Name: CDC
// Target Devices: zybo z7-10
//////////////////////////////////////////////////////////////////////////////////

module async_FIFO #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4 // FIFO depth = 2^ADDR_WIDTH
)(
    input wire wr_clk, rd_clk, reset,
    input wire wr_en, rd_en,
    input wire [DATA_WIDTH-1:0] wr_data,
    output wire [DATA_WIDTH-1:0] rd_data,
    output wire full, empty
);

    reg [DATA_WIDTH-1:0] fifo_mem [0:(1<<ADDR_WIDTH)-1];
    reg [ADDR_WIDTH:0] wr_ptr = 0, rd_ptr = 0; // Extra bit for full/empty detection
    wire [ADDR_WIDTH:0] wr_ptr_gray, rd_ptr_gray;
    reg [ADDR_WIDTH:0] wr_ptr_gray_sync1, wr_ptr_gray_sync2;
    reg [ADDR_WIDTH:0] rd_ptr_gray_sync1, rd_ptr_gray_sync2;

    // Gray code conversion
    function [ADDR_WIDTH:0] binary_to_gray;
        input [ADDR_WIDTH:0] binary;
        begin
            binary_to_gray = binary ^ (binary >> 1);
        end
    endfunction

    // Synchronize pointers across clock domains
    always @(posedge rd_clk or posedge reset) begin
        if (reset) begin
            wr_ptr_gray_sync1 <= 0;
            wr_ptr_gray_sync2 <= 0;
        end else begin
            wr_ptr_gray_sync1 <= wr_ptr_gray;
            wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
        end
    end

    always @(posedge wr_clk or posedge reset) begin
        if (reset) begin
            rd_ptr_gray_sync1 <= 0;
            rd_ptr_gray_sync2 <= 0;
        end else begin
            rd_ptr_gray_sync1 <= rd_ptr_gray;
            rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
        end
    end

    // Write logic
    always @(posedge wr_clk or posedge reset) begin
        if (reset) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            fifo_mem[wr_ptr[ADDR_WIDTH-1:0]] <= wr_data;
            wr_ptr <= wr_ptr + 1;
        end
    end

    // Read logic
    always @(posedge rd_clk or posedge reset) begin
        if (reset) begin
            rd_ptr <= 0;
        end else if (rd_en && !empty) begin
            rd_ptr <= rd_ptr + 1;
        end
    end

    // Full and empty flags
    assign full = (wr_ptr_gray == {~rd_ptr_gray_sync2[ADDR_WIDTH:ADDR_WIDTH-1], rd_ptr_gray_sync2[ADDR_WIDTH-2:0]});
    assign empty = (rd_ptr_gray == wr_ptr_gray_sync2);

    // Gray code pointers
    assign wr_ptr_gray = binary_to_gray(wr_ptr);
    assign rd_ptr_gray = binary_to_gray(rd_ptr);

    // Read data output
    assign rd_data = fifo_mem[rd_ptr[ADDR_WIDTH-1:0]];

endmodule