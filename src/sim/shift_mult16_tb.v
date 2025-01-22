`timescale 1ns/1ps

module shift_mult_tb();

    reg clk, clk_slow;

    localparam A = 16'hFFFF;
    localparam B = 16'hFFFF; // * 2^-16

    initial begin
        $dumpfile("build/sim/shift_mult_tb.vcd");
        $dumpvars();

        clk = 1;
        clk_slow = 1;
        #5000 $finish;
    end
    always #5 clk = ~clk;
    always #160 clk_slow = ~clk_slow;

    wire[15:0] y;
    shift_mult16 uut (
        .clk(clk),
        .clk_slow(clk_slow),
        .a(A),
        .b(B),
        .y(y)
    );

endmodule