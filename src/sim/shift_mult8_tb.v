`timescale 1ns/1ps

module shift_mult8_tb();

    reg clk, clk_slow, clk_slow_x2;

    localparam A = 8'hFF;
    localparam B = 8'h80;

    initial begin
        $dumpfile("build/sim/shift_mult8_tb.vcd");
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
    shift_mult8 uut (
        .clk(clk),
        .mult_rst(mult_rst),
        .a(A),
        .b(B),
        .y(y)
    );

endmodule