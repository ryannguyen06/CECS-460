`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2025 07:41:32 PM
// Design Name: 
// Module Name: memory_game
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


module memory_game(
    input        clk,          
    input  [3:0] sw,           
    input        btn0,         
    output reg   led0,         
    output reg   led1          
);

//setting up memory
    reg [3:0] memory_array [0:9];
    initial begin
        memory_array[0] = 4'h3; //0011
        memory_array[1] = 4'hA; //1010
        memory_array[2] = 4'h7; //0111
        memory_array[3] = 4'hF; //1111
        memory_array[4] = 4'h0; //0000
        memory_array[5] = 4'hC; //1100
        memory_array[6] = 4'h5; //0101
        memory_array[7] = 4'h1; //0001
        memory_array[8] = 4'h9; //1001
        memory_array[9] = 4'h6; //0110
    end
    
    initial begin
        led0 = 1'b0;
        led1 = 1'b0;
    end
    
//address value
    reg [3:0] address = 4'b0;   
//store value
    wire [3:0] stored_value;
    assign stored_value = memory_array[address];

    reg btn0_d1, btn0_d2;
    always @(posedge clk) begin
        btn0_d1 <= btn0;
        btn0_d2 <= btn0_d1;
    end
    wire btn0_rising = (btn0_d1 & ~btn0_d2);

    always @(posedge clk) begin
        if (btn0_rising) begin
            if (sw == stored_value) begin
                led0 <= 1'b1;  //correct
                led1 <= 1'b0;
            end else begin
                led0 <= 1'b0; //incorrect
                led1 <= 1'b1;  
            end
            //update address location
            if (address == 4'd9) 
                address <= 4'd0;
            else 
                address <= address + 4'd1;
        end else begin
        //was trying to turn off led after each guess but didnt work
            led0 <= led0;
            led1 <= led1;
        end
    end

endmodule
