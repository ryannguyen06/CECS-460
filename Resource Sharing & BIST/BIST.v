`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2025 06:45:18 PM
// Design Name: 
// Module Name: BIST
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


module BIST(
    input clk,
    input reset,
    output reg bist_pass,    // High if all tests pass
    output reg bist_done,    // High when BIST routine is complete
    output reg enable_normal // Set high to enable normal operation (BIST passed)
);

    // Define BIST states:
    reg [2:0] state;
    localparam STATE_INIT     = 3'd0,
               STATE_X1      = 3'd1,  // Altitude test stage 1
               STATE_X2      = 3'd2,  // Altitude test stage 2
               STATE_CHECK_AT = 3'd3,  // Check altitude result
               STATE_BT       = 3'd4,  // Battery test
               STATE_CHECK_BT = 3'd5,  // Check battery result
               STATE_DONE     = 3'd6,
               STATE_FAIL     = 3'd7;
    // alt
    reg signed [7:0] test_x1;
    reg signed [7:0] test_x2;
    reg signed [15:0] expected_alt;
    
    // batt
    reg signed [7:0] test_v;
    reg signed [7:0] test_t;
    reg signed [7:0] test_c;
    reg signed [15:0] expected_batt;

    // BIST
    reg signed [15:0] bist_ac_temp;
    reg signed [15:0] bist_result;
    
    initial begin
        // alt test (2*3) + (3*5) = 6 + 15 = 21
        test_x1 = 8'sd2;
        test_x2 = 8'sd3;
        expected_alt     = 16'sd21;
        
        // batt test((-4)*2) + 5 = -8 + 5 = -3
        test_v = -8'sd4;
        test_t = 8'sd2;
        test_c  = 8'sd5;
        expected_batt     = -16'sd3;
    end

    // BIST state machine
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state         <= STATE_INIT;
            bist_pass     <= 1'b0;
            bist_done     <= 1'b0;
            enable_normal <= 1'b0;
            bist_ac_temp  <= 16'sd0;
            bist_result   <= 16'sd0;
        end
        else begin
            case(state)
                STATE_INIT: begin
                    state <= STATE_X1;
                end
                STATE_X1: begin
                    bist_ac_temp <= test_x1 * 3;
                    state        <= STATE_X2;
                end
                STATE_X2: begin
                    bist_result <= bist_ac_temp + (test_x2 * 5);
                    state       <= STATE_CHECK_AT;
                end
                STATE_CHECK_AT: begin
                    if (bist_result == expected_alt)
                        state <= STATE_BT; 
                    else
                        state <= STATE_FAIL;
                end
                STATE_BT: begin
                    bist_result <= (test_v * test_t) + test_c;
                    state       <= STATE_CHECK_BT;
                end
                STATE_CHECK_BT: begin
                    if (bist_result == expected_batt)
                        state <= STATE_DONE;
                    else
                        state <= STATE_FAIL;
                end
                STATE_DONE: begin
                    bist_pass     <= 1'b1;
                    bist_done     <= 1'b1;
                    enable_normal <= 1'b1;
                    state         <= STATE_DONE;
                end
                STATE_FAIL: begin
                    bist_pass     <= 1'b0;
                    bist_done     <= 1'b1;
                    enable_normal <= 1'b0;
                    state         <= STATE_FAIL;
                end
                default: state <= STATE_FAIL;
            endcase
        end
    end

endmodule
