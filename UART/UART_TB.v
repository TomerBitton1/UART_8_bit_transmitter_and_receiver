// UART Testbench
`timescale 1ns / 1ps

module UART_TB;

    // Testbench signals
    reg clk = 0;
    reg start = 0;
    reg [7:0] txin;
    wire [7:0] rxout;
    wire rxdone, txdone; 
    wire txrx;

    integer i = 0;

    // Clock
    always #5 clk = ~clk;
   
    // Instantiate the DUT
    UART dut (
        .clk(clk), 
        .start(start), 
        .txin(txin), 
        .tx(txrx), 
        .rx(txrx), 
        .rxout(rxout), 
        .rxdone(rxdone), 
        .txdone(txdone)
    );

    initial begin
        // Initialization
        txin = 8'b0;
        start = 0;
        
        // Loop to transmit 5 random data values
        for (i = 0; i < 5; i = i + 1) begin
            // Generate random 8-bit data
            txin = $random % 256;
            
            // Start the transmission
            start = 1;

            // Wait until the transmission is done (txdone and rxdone both high)
            wait(txdone && rxdone);
            
            // Transmission complete, stop transmission
            start = 0;
            
            // delay before next transmission
            #100;
        end
        
        // Finish simulation after all transmissions
        $finish;
    end

endmodule