`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2025 06:45:32 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top(
    input clk,
    input reset
);
    // bist/con signals
    wire bist_pass, bist_done, enable_normal;
    wire signed [15:0] out;
    wire op_valid;
    wire op_type;  
    
    // inputs
    reg signed [7:0] x1;
    reg signed [7:0] x2;
    reg signed [7:0] v;
    reg signed [7:0] t;
    reg signed [7:0] c;
    
    // BIST instantiation
    BIST bist_inst (
        .clk(clk),
        .reset(reset),
        .bist_pass(bist_pass),
        .bist_done(bist_done),
        .enable_normal(enable_normal)
    );
    
    // con instantiatio
    controller ctrl_inst (
        .clk(clk),
        .reset(reset),
        .enable(enable_normal),
        .x1(x1),
        .x2(x2),
        .v(v),
        .t(t),
        .c(c),
        .out(out),
        .op_valid(op_valid),
        .op_type(op_type)
    );
    
    reg [1:0] cycle_count;
    always @(posedge clk or posedge reset) begin
        if (reset)
            cycle_count <= 2'd0;
        else
            cycle_count <= (cycle_count == 2) ? 2'd0 : cycle_count + 1;
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x1  <= 8'd0;
            x2  <= 8'd0;
            v <= 8'd0;
            t <= 8'd0;
            c  <= 8'd0;
        end
        else begin
            case (cycle_count)
                2'd0, 2'd1: begin
                    x1  <= 8'd10;
                    x2  <= 8'd2;
                    v <= 8'd0;
                    t <= 8'd0;
                    c  <= 8'd0;
                end
                2'd2: begin
                    x1  <= 8'd0;
                    x2  <= 8'd0;
                    v <= 8'd8;
                    t <= 8'd3;
                    c  <= -8'd2;
                end
            endcase
        end
    end

endmodule
