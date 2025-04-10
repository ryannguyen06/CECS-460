`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2025 06:44:41 PM
// Design Name: 
// Module Name: controller
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


module controller(
    input clk,
    input reset,
    input enable, 
    // alt inputs
    input signed [7:0] x1,
    input signed [7:0] x2,
    // batt inputs
    input signed [7:0] v,
    input signed [7:0] t,
    input signed [7:0] c,
    // outputs
    output reg signed [15:0] out,
    output reg op_valid,  
    output reg op_type    
);

    // states
    reg [1:0] state;
    localparam STATE_X1 = 2'd0,  // alt pipe 1
               STATE_X2 = 2'd1,  // alt pipe 2
               STATE_BT  = 2'd2;  // batt

    // hold result of first alt calc 
    reg signed [15:0] ac_temp;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state    <= STATE_X1;
            ac_temp  <= 16'sd0;
            out      <= 16'sd0;
            op_valid <= 1'b0;
            op_type  <= 1'b0;
        end
        else if (enable) begin
            case (state)
                STATE_X1: begin
                    ac_temp  <= x1 * 3;
                    op_valid <= 1'b0; 
                    state    <= STATE_X2;
                end
                STATE_X2: begin
                    out      <= ac_temp + (x2 * 5);
                    op_valid <= 1'b1;  
                    op_type  <= 1'b0;  
                    state    <= STATE_BT;
                end
                STATE_BT: begin
                    out      <= (v * t) + c;
                    op_valid <= 1'b1; 
                    op_type  <= 1'b1;  
                    state    <= STATE_X1;
                end
                default: state <= STATE_X1;
            endcase
        end
    end

endmodule
