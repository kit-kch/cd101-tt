`timescale 1ns/1ps

module dac_tb();

    reg clk, rstn;
    reg[15:0] din;
    wire dout;

    initial begin
        $dumpfile("build/sim/dac_tb.vcd");
        $dumpvars();

        clk = 0;
        #10000 $finish;
    end
    always #5 clk = ~clk;

    initial begin
        din = 16'h0000;
        rstn = 0;
        #50 rstn = 1;
        #50 din = 16'h1000;
        #1000 din = 16'h8000;
        #1500 din = 16'hFFFF;
        #6500 din = 16'h0000;
    end

    dac uut (
        .clk(clk),
        .rstn(rstn),
        .din(din),
        .dout(dout)
    );

endmodule