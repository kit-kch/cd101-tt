`timescale 1ns/1ps

module filter_tb();

    reg clk;
    reg[15:0] din;
    wire[15:0] dout;
    localparam A = 16'd6553; // * 2^-16
    localparam B = 16'hFFFF - A; // * 2^-16

    initial begin
        $dumpfile("build/sim/filter_tb.vcd");
        $dumpvars();

        clk = 0;
        #10000 $finish;
    end
    always #5 clk = ~clk;

    initial begin
        din = 16'h0000;
        #50 din = 16'hFFFF;
        #100 din = 16'h0000;
        #150 din = 16'hFFFF;
        #200 din = 16'h0000;
        #250 din = 16'hFFFF;
        #300 din = 16'h0000;
        #350 din = 16'hFFFF;
    end

    filter uut (
        .clk(clk),
        .din(din),
        .dout(dout),
        .a(A),
        .b(B)
    );

endmodule