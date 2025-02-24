`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2025 04:40:16 PM
// Design Name: 
// Module Name: AXI4_LiteSlave
// Project Name: 460
// Target Devices: 
//////////////////////////////////////////////////////////////////////////////////

module AXI4_LiteSlave(
    input wire ACLK,
    input wire ARESETN,
    
    //Write Address Channel
    input wire [7:0] AWADDR,
    input wire AWVALID,
    output reg AWREADY,
    
    //Write Data Channel
    input wire[7:0] WDATA,
    input wire[0:0] WSTRB,
    input wire WVALID,
    output reg WREADY,
    
    //Write response Channel
    output reg [1:0] BRESP,
    output reg BVALID,
    input wire BREADY,
    
    //Read Address Channel
    input wire [7:0] ARADDR,
    input wire ARVALID,
    output reg ARREADY,
    
    //Read Data Channel
    output reg [7:0] RDATA,
    output reg [1:0] RRESP,
    output reg RVALID,
    input wire RREADY
    );
    
    //BRAM Signals
    reg WE;
    reg [7:0] ADDR;
    reg [7:0] DIN;
    wire [7:0] DOUT;
    
    //Instantiate BRAM8
    BRAM8 uut(
        .clk(ACLK),
        .we(WE),
        .addr(ADDR),
        .din(DIN),
        .dout(DOUT)
        );
        
     always @(posedge ACLK) begin
    if (!ARESETN) begin
        AWREADY <= 0;
    end else begin
        if (AWVALID && !AWREADY) 
            AWREADY <= 1;
    end
    end

    always @(posedge ACLK) begin
        if (!ARESETN) begin
            WREADY <= 0;
            BVALID <= 0;
            WE <= 0;
        end else begin
            if (WVALID && !WREADY) begin
                WREADY <= 1;
                if (WSTRB) begin
                    WE <= 1;
                    ADDR <= AWADDR;
                    DIN <= WDATA;
                end 
                BVALID <= 1;
                BRESP <= 2'b00; // HANDSHAKE
            end 
            if (BVALID && BREADY) 
                BVALID <= 0;
        end
    end
    
    always @(posedge ACLK) begin
    if (!ARESETN) begin
        ARREADY <= 0;
        RVALID <= 0;
        RDATA <= 0;
    end else begin
        if (ARVALID && !ARREADY) begin
            ARREADY <= 1;
            ADDR <= ARADDR;
        end 
        if (ARREADY) begin
            RDATA <= DOUT; // Ensure data is read from memory
            RVALID <= 1;
            RRESP <= 2'b00; // HANDSHAKE
            ARREADY <= 0; // Deassert ARREADY after processing
        end
        if (RVALID && RREADY) begin
            RVALID <= 0;
        end
    end
end


    
endmodule
