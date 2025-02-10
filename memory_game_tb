`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2025 07:46:53 PM
// Design Name: 
// Module Name: memory_game_tb
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


module memory_game_tb;
    reg clk;
    reg [3:0] sw;
    reg btn0;
    wire led0, led1;

    // Instantiate the memory_game module
    memory_game uut (
        .clk(clk),
        .sw(sw),
        .btn0(btn0),
        .led0(led0),
        .led1(led1)
    );
    always #5 clk = ~clk; 
    reg [3:0] expected_values [0:9]; 
    integer i;
    initial begin
        // Initialize signals
        clk = 0;
        sw = 4'b0000;
        btn0 = 1;
        btn0 = 0;
        i = 0;
        // Store expected values based on known memory initialization
        expected_values[0] = 4'b0011;
        expected_values[1] = 4'b1010;
        expected_values[2] = 4'b0111;
        expected_values[3] = 4'b1111;
        expected_values[4] = 4'b0000;
        expected_values[5] = 4'b1100;
        expected_values[6] = 4'b0101;
        expected_values[7] = 4'b0001; 
        expected_values[8] = 4'b1001;
        expected_values[9] = 4'b0110;

        #20; // Wait for initialization
        for (i = 0; i < 10; i = i + 1) begin #10;
            // Set sw to the expected value from the testbench memory (correct guess)
            sw = expected_values[i];#10;
            btn0 = 1;#10; 
            btn0 = 0;#20;
            // Check Guess
            if (sw == expected_values[i]) begin
                $display("Correct guess at DRAM: %d", i);
            end else begin
                $display("Incorrect guess at DRAM: %d", i); 
            end
        end
        // Loop for incorrect guesses only
        for (i = 0; i < 10; i = i + 1) begin #10;
            // Set sw to an incorrect value
            sw = expected_values[i] ^ 4'b0001;#10; // Flip one bit
            btn0 = 1;#10; 
            btn0 = 0;#20; 
            if (sw == expected_values[i]) begin
                $display("Correct guess at DRAM: %d", i);
            end else begin
                $display("Incorrect guess at DRAM: %d", i); 
            end
        end
        $finish;
    end
endmodule
