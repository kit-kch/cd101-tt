`timescale 1ns/1ps

module filter_tb();

    reg clk, clk_slow, clk_slow_x2;
    reg[15:0] din;
    wire[15:0] dout;
    localparam A = 8'd101; // * 2^-8
    localparam B = 8'hFF - A; // * 2^-8

    initial begin
        $dumpfile("build/sim/filter_tb.vcd");
        $dumpvars();

        clk = 1;
        clk_slow = 1;
        clk_slow_x2 = 1;
        #100000 $finish;
    end
    always #5 clk = ~clk;
    always #80 clk_slow = ~clk_slow;
    always #40 clk_slow_x2 = ~clk_slow_x2;

    wire mult_rst = clk_slow & ~clk_slow_x2;

    initial begin
        din = 16'h0000;
        #8000 din = 16'hFFFF;
        #8000 din = 16'h0000;
    end

    filter uut (
        .clk(clk),
        .clk_sample(clk_slow),
        .mult_rst(mult_rst),
        .din(din),
        .dout(dout),
        .a(A),
        .b(B)
    );

endmodule