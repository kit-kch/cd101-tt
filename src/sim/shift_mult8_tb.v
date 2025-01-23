`timescale 1ns/1ps

module shift_mult8_tb();

    reg clk, clk_slow;

    localparam A = 8'hFF;
    localparam B = 8'h80;

    initial begin
        $dumpfile("build/sim/shift_mult8_tb.vcd");
        $dumpvars();

        clk = 1;
        clk_slow = 1;
        #5000 $finish;
    end
    always #5 clk = ~clk;
    always #80 clk_slow = ~clk_slow;

    wire[15:0] y;
    shift_mult8 uut (
        .clk(clk),
        .clk_slow(clk_slow),
        .a(A),
        .b(B),
        .y(y)
    );

endmodule