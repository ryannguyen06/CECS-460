`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2025 06:48:58 PM
// Design Name: 
// Module Name: top_tb
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

module top_tb;
    reg clk;
    reg reset;
    
    // BIST outputs
    wire bist_pass;
    wire bist_done;
    wire enable_normal;
    
    // con inputs
    reg signed [7:0] x1;
    reg signed [7:0] x2;
    reg signed [7:0] v;
    reg signed [7:0] t;
    reg signed [7:0] c;
    
    wire signed [15:0] out;
    wire op_valid;
    wire op_type; 

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // BIST instantiation
    BIST bist_inst (
        .clk(clk),
        .reset(reset),
        .bist_pass(bist_pass),
        .bist_done(bist_done),
        .enable_normal(enable_normal)
    );
    
    // controller instantiation
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
    

    initial begin
        reset = 1;
        x1 = 8'd0; x2 = 8'd0;
        v = 8'd0; t = 8'd0; c = 8'd0;
        #20;
        reset = 0;
        wait (bist_done == 1);
        
        // alt calc (10*3)+(2*5) = 30+10 = 40
        @(posedge clk);
        x1 = 8'd10; x2 = 8'd2; 
        v = 8'd0; t = 8'd0; c = 8'd0;
        @(posedge clk);
        x1 = 8'd10; x2 = 8'd2; 
        v = 8'd0; t = 8'd0; c = 8'd0;

        
        // batt calc (8*3)+(-2)= 24-2 = 22
        @(posedge clk);
        x1 = 8'd0; x2 = 8'd0; 
        v = 8'd8; t = 8'd3; c = -8'd2;

        
        // alt calc ((-5)*3) + (4*5) = -15 + 20 = 5
        @(posedge clk);
        x1 = -8'd5; x2 = 8'd4; 
        v = 8'd0; t = 8'd0; c = 8'd0;
        @(posedge clk);
        x1 = -8'd5; x2 = 8'd4; 
        v = 8'd0; t = 8'd0; c = 8'd0;

        
        // batt calc (7*(-2)) + 10 = -14 + 10 = -4
        @(posedge clk);
        x1 = 8'd0; x2 = 8'd0; 
        v = 8'd7; t = -8'd2; c = 8'd10;

        
        // alt calc (3*3) + (3*5) = 9 + 15 = 24
        @(posedge clk);
        x1 = 8'd3; x2 = 8'd3; 
        v = 8'd0; t = 8'd0; c = 8'd0;
        @(posedge clk);
        x1 = 8'd3; x2 = 8'd3; 
        v = 8'd0; t = 8'd0; c = 8'd0;

        
        // batt calc ((-6)*2) + (-5) = -12 - 5 = -17
        @(posedge clk);
        x1 = 8'd0; x2 = 8'd0; 
        v = -8'd6; t = 8'd2; c = -8'd5;

        // delay
        #100;
        $finish;
    end
endmodule
