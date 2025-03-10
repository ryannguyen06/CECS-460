`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2025 08:34:04 PM
// Design Name: 
// Module Name: Master
// Project Name: 
// Target Devices: 
//////////////////////////////////////////////////////////////////////////////////

module Master #(
    parameter DATA_WIDTH = 8
)(
    input wire clk, reset,
    input wire full, empty,
    input wire [DATA_WIDTH-1:0] rd_data,
    output reg wr_en, rd_en,
    output reg [DATA_WIDTH-1:0] wr_data
);

    reg [3:0] state;
    reg [DATA_WIDTH-1:0] data_to_write;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            wr_en <= 0;
            rd_en <= 0;
            wr_data <= 0;
        end else begin
            case (state)
                0: begin // Write data
                    if (!full) begin
                        wr_en <= 1;
                        wr_data <= data_to_write;
                        state <= 1;
                    end
                end
                1: begin // Wait for write completion
                    wr_en <= 0;
                    state <= 2;
                end
                2: begin // Read data
                    if (!empty) begin
                        rd_en <= 1;
                        state <= 3;
                    end
                end
                3: begin // Wait for read completion
                    rd_en <= 0;
                    state <= 0;
                end
            endcase
        end
    end

endmodule
