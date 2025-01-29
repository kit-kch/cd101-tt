`timescale 1ns/1ps

module shift_mult16_tb();

    reg clk, clk_slow, clk_slow_x2;

    localparam A = 16'hFFFF;
    localparam B = 8'h40; // * 2^-8

    initial begin
        $dumpfile("build/sim/shift_mult16_tb.vcd");
        $dumpvars();

        clk = 1;
        clk_slow = 1;
        clk_slow_x2 = 1;
        #5000 $finish;
    end
    always #5 clk = ~clk;
    always #80 clk_slow = ~clk_slow;
    always #40 clk_slow_x2 = ~clk_slow_x2;

    wire mult_rst = clk_slow & ~clk_slow_x2;

    wire[15:0] y;
    shift_mult16 uut (
        .clk(clk),
        .mult_rst(mult_rst),
        .a(A),
        .b(B),
        .y(y)
    );

endmodule