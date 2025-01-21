`timescale 1ns/1ps

module oscillator_tb();

    localparam PULSE_PERIOD_2 = 16;
    wire[7:0] data;
    reg clk;

    initial begin
        $dumpfile("build/sim/oscillator_tb.vcd");
        $dumpvars();

        clk = 0;
        #5000 $finish;
    end
    always #5 clk = ~clk;

    oscillator uut (
        .clk(clk),
        .count_max(PULSE_PERIOD_2 - 1),
        .data(data)
    );

endmodule