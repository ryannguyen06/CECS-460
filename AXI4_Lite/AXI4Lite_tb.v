`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2025 09:05:06 AM
// Design Name: 
// Module Name: AXI4Lite_tb
// Project Name: 
// Target Devices: // 
//////////////////////////////////////////////////////////////////////////////////

module AXI4Lite_tb();

    // Clock and reset
    reg ACLK;
    reg ARESETN;

    // AXI4-Lite signals
    reg [7:0] AWADDR;
    reg AWVALID;
    wire AWREADY;
    reg [7:0] WDATA;
    reg WVALID;
    wire WREADY;
    reg [0:0] WSTRB;
    wire [1:0] BRESP;
    wire BVALID;
    reg BREADY;
    reg [7:0] ARADDR;
    reg ARVALID;
    wire ARREADY;
    wire [7:0] RDATA;
    wire [1:0] RRESP;
    wire RVALID;
    reg RREADY;

    // Instantiate the AXI4-Lite slave module
    AXI4_LiteSlave uut(
        .ACLK(ACLK),
        .ARESETN(ARESETN),
        .AWADDR(AWADDR),
        .AWVALID(AWVALID),
        .AWREADY(AWREADY),
        .WDATA(WDATA),
        .WVALID(WVALID),
        .WREADY(WREADY),
        .WSTRB(WSTRB),
        .BRESP(BRESP),
        .BVALID(BVALID),
        .BREADY(BREADY),
        .ARADDR(ARADDR),
        .ARVALID(ARVALID),
        .ARREADY(ARREADY),
        .RDATA(RDATA),
        .RRESP(RRESP),
        .RVALID(RVALID),
        .RREADY(RREADY)
    );

    // Clock generation
    always #5 ACLK = ~ACLK;

    initial begin
        // Initialize signals
        ACLK = 0;
        ARESETN = 0;
        AWADDR = 0;
        AWVALID = 0;
        WDATA = 0;
        WVALID = 0;
        WSTRB = 0;
        BREADY = 0;
        ARADDR = 0;
        ARVALID = 0;
        RREADY = 0;
        
        

        // Reset
        #10 ARESETN = 1;

        // Perform write transactions
        #10;
        ARADDR = 8'h00;
        ARVALID = 1;
        RREADY = 1;
        #10
        ARVALID = 0;
        
        #20
        AWADDR = 8'h10;
        WDATA = 8'h55;
        AWVALID = 1;
        WVALID = 1;
        WSTRB = 1;
        #10;
        AWVALID = 0;
        WVALID = 0;

        // Perform read transactions
        #20;
        ARADDR = 8'h10;
        ARVALID = 1;
        RREADY = 1;
        #10;
        ARVALID = 0;

        // Perform concurrent write and read transactions
        #30;
        AWADDR = 8'h20;
        WDATA = 8'hAA;
        AWVALID = 1;
        WVALID = 1;
        WSTRB = 1;
        ARADDR = 8'h20;
        ARVALID = 1;
        RREADY = 1;
        #10;
        AWVALID = 0;
        WVALID = 0;
        ARVALID = 0;

        // Wait for responses
        #50;

        // Finish simulation
        $finish;
    end

endmodule