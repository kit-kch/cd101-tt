`timescale 1ns/1ps

module oscillator_tb();

    wire clk_mod, clk_sample, clk_adsr, clk_mult;
    reg clk, rstn;

    initial begin
        $dumpfile("build/sim/clkdiv_tb.vcd");
        $dumpvars();

        clk = 0;
        #5000 $finish;
    end
    always #5 clk = ~clk;

    initial begin
        rstn = 1'b0;
        #50 rstn = 1'b1;
    end

    clkdiv uut (
        .clk(clk),
        .rstn(rstn),
        .clk_mod(clk_mod),
        .clk_sample(clk_sample),
        .clk_adsr(clk_adsr),
        .clk_mult(clk_mult)
    );

endmodule