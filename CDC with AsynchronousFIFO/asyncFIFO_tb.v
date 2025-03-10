`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2025 01:25:32 PM
// Design Name: 
// Module Name: asyncFIFO_tb
// Project Name: 
// Target Devices: 
//////////////////////////////////////////////////////////////////////////////////


module asyncFIFO_tb();

    reg wr_clk, rd_clk, reset;
    reg wr_en, rd_en;
    reg [7:0] wr_data;
    wire [7:0] rd_data;
    wire full, empty;

    // Instantiate FIFO
    async_FIFO #(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(4)
    ) fifo (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .reset(reset),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    initial begin
        wr_clk = 0;
        forever #5.55 wr_clk = ~wr_clk; // 90 MHz
    end

    initial begin
        rd_clk = 0;
        forever #7.69 rd_clk = ~rd_clk; // 65 MHz
    end

    // Test sequence
    initial begin
        reset = 1;
        wr_en = 0;
        rd_en = 0;
        wr_data = 0;
        #20;
        reset = 0;
        
        // Write data to FIFO
        wr_en = 1;
        wr_data = 8'hAA;
        #10;
        wr_en = 0;

        // Read data from FIFO
        #20;
        rd_en = 1;
        #10;
        rd_en = 0;

        // Interleaved read/write
        #20;
        wr_en = 1;
        wr_data = 8'h55;
        #10;
        wr_en = 0;
        rd_en = 1;
        #10;
        rd_en = 0;
        
        // Interleaved read/write
        #20;
        wr_en = 1;
        wr_data = 8'h22;
        #10;
        wr_en = 0;
        rd_en = 1;
        #10;
        rd_en = 0;
        
        // Interleaved read/write
        #20;
        wr_en = 1;
        wr_data = 8'h27;
        #10;
        wr_en = 0;
        rd_en = 1;
        #10;
        rd_en = 0;
        
        // Interleaved read/write
        #20;
        wr_en = 1;
        wr_data = 8'h33;
        #10;
        wr_en = 0;
        rd_en = 1;
        #10;
        rd_en = 0;
        
        // Interleaved read/write
        #20;
        wr_en = 1;
        wr_data = 8'h00;
        #10;
        wr_en = 0;
        rd_en = 1;
        #10;
        rd_en = 0;
        
        // Interleaved read/write
        #20;
        wr_en = 1;
        wr_data = 8'h77;
        #10;
        wr_en = 0;
        rd_en = 1;
        #10;
        rd_en = 0;
        
        // Interleaved read/write
        #20;
        wr_en = 1;
        wr_data = 8'h15;
        #10;
        wr_en = 0;
        rd_en = 1;
        #10;
        rd_en = 0;
        
        // Read data from FIFO
        #20;
        rd_en = 1;
        #10;
        rd_en = 0;
        

        #100;
        $finish;
    end

endmodule
