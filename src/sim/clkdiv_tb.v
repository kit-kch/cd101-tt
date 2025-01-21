`timescale 1ns/1ps

module oscillator_tb();

    wire clk_mod, clk_sample, clk_adsr;
    reg clk, arst;

    initial begin
        $dumpfile("build/sim/clkdiv_tb.vcd");
        $dumpvars();

        clk = 0;
        #5000 $finish;
    end
    always #5 clk = ~clk;

    initial begin
        arst = 1'b1;
        #50 arst = 1'b0;
    end

    clkdiv uut (
        .clk(clk),
        .arst(arst),
        .clk_mod(clk_mod),
        .clk_sample(clk_sample),
        .clk_adsr(clk_adsr)
    );

endmodule