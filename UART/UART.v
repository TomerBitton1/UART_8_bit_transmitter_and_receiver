// Verilog UART Code
`timescale 1ns / 1ps

module UART(
    input clk,
    input start,
    input [7:0] txin,
    output reg tx, 
    input rx,
    output [7:0] rxout,
    output rxdone, 
    output txdone
    );

    // Parameters
    parameter clk_value = 100000;
    parameter baud = 9600;
    parameter wait_count = clk_value / baud;

    // State Definitions
    parameter idle = 0, send = 1, check = 2;  // TX 
    parameter ridle = 0, rwait = 1, recv = 2; // RX

    // Registers
    reg bitDone = 0;
    integer count = 0;
    reg [1:0] state = idle; // TX initial state
    reg [9:0] txData;  // Data with start and stop bits
    integer bitIndex = 0;

    integer rcount = 0;
	reg [1:0] rstate = ridle;  // RX initial state
    reg [9:0] rxdata;
    integer rindex = 0;

    /////////////////// Generate Trigger for Baud Rate //////////////////
    always @(posedge clk) begin
        if (state == idle) begin 
            count <= 0;
        end else begin
            if (count == wait_count) begin
                bitDone <= 1'b1;
                count <= 0;  
            end else begin
                count <= count + 1;
                bitDone <= 1'b0;  
            end
        end
    end

    /////////////////////// TX Logic ///////////////////////
    always @(posedge clk) begin
        case (state)
            idle: begin
                tx <= 1'b1;
                txData <= 10'b0;
                bitIndex <= 0;              
                if (start == 1'b1) begin
                    txData <= {1'b1, txin, 1'b0}; // Start and stop bits
                    state <= send;
                end else begin           
                    state <= idle;
                end
            end

            send: begin
                tx <= txData[bitIndex];
                state <= check;
            end

            check: begin         
                if (bitIndex <= 9) begin
                    if (bitDone == 1'b1) begin
                        state <= send;
                        bitIndex <= bitIndex + 1;
                    end
                end else begin
                    state <= idle;
                    bitIndex <= 0;
                end
            end

            default: state <= idle;
        endcase
    end

    // TX Done Signal
    assign txdone = (bitIndex == 9 && bitDone == 1'b1) ? 1'b1 : 1'b0;

    /////////////////////// RX Logic ///////////////////////
    always @(posedge clk) begin
        case (rstate)
            ridle: begin
                rxdata <= 10'b0;
                rindex <= 0;
                rcount <= 0;  
                if (rx == 1'b0) begin   // Checks if the start bit is on
                    rstate <= rwait;
                end else begin
                    rstate <= ridle;   // Checks if the start bit is off
                end
            end

            rwait: begin
                if (rindex > 9) begin
                    rxdata <= 10'b0;
                    tx <= 1'b1;
                end 
                
                if (rcount < wait_count / 2) begin
                    rcount <= rcount + 1;
                    rstate <= rwait;
                end else begin
                    rcount <= 0;
                    rstate <= recv;
                    rxdata <= {rx, rxdata[9:1]};
                end
            end

            recv: begin
                if (rindex <= 9) begin
                    if (bitDone == 1'b1) begin
                        rindex <= rindex + 1;
                        rstate <= rwait;
                    end
                end else begin
                    rstate <= ridle;
                    rxdata <= 10'b0;
                end
            end

            default: rstate <= ridle;
        endcase
    end

    // RX Output and Done Signal
    assign rxout = rxdata[8:1];
    assign rxdone = (rindex == 9 && bitDone == 1'b1) ? 1'b1 : 1'b0;

endmodule