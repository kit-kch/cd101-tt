`timescale 1ns/1ps

module dac_tb();

    reg clk;
    reg[7:0] din;
    wire dout;

    initial begin
        $dumpfile("out/sim/dac_tb.vcd");
        $dumpvars();

        clk = 0;
        #10000 $finish;
    end
    always #5 clk = ~clk;

    initial begin
        din = 8'h00;
        #50 din = 8'h10;
        #1000 din = 8'h80;
        #1500 din = 8'hFF;
        #6500 din = 8'h00;
    end

    dac uut (
        .clk(clk),
        .din(din),
        .dout(dout)
    );

endmodule