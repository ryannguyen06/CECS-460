`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2025 04:04:49 PM
// Design Name: 
// Module Name: BRAM8
// Project Name: 
// Target Devices: 
//////////////////////////////////////////////////////////////////////////////////

module BRAM8(
    input wire clk,
    input wire we,
    input wire [7:0] addr,
    input wire [7:0] din,
    output reg [7:0] dout
    );
    
    //Declare BRAM memory
    reg [7:0] mem [255:0];
    
    //Initialize memory with 12 values
    initial begin
        mem[0] = 8'h3A;
        mem[1] = 8'h7F;
        mem[2] = 8'hB2;
        mem[3] = 8'h5D;
        mem[4] = 8'hE1;
        mem[5] = 8'h96;
        mem[6] = 8'hC4;
        mem[7] = 8'h0F;
        mem[8] = 8'hFF;
        mem[9] = 8'h29;
        mem[10] = 8'h83;
        mem[11] = 8'hD7;
     end 
     
     always @(negedge clk) begin
        if (we)
            mem[addr] <= din; //Write
            
        dout <= mem[addr]; //Read
     end
        
endmodule
