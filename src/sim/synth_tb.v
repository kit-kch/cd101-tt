`timescale 1ns/1ps

module synth_tb();

    localparam ADSR_AI = 5;
    localparam ADSR_DI = 10;
    localparam ADSR_S = 64;
    localparam ADSR_RI = 1;
    localparam PULSE_PERIOD_2 = 2;
    localparam FILTER_A = 16'd6553; // * 2^-16
    localparam FILTER_B = 16'hFFFF - FILTER_A; // * 2^-16

    wire data;
    reg clk;
    reg rst, trig;

    initial begin
        $dumpfile("out/sim/synth_tb.vcd");
        $dumpvars();

        clk = 0;
        #10000 $finish;
    end
    always #5 clk = ~clk;

    initial begin
        rst = 1'b1;
        trig = 1'b0;
        #50 rst = 1'b0;
        #50 trig = 1'b1;
        #4000 trig = 1'b0;
    end

    synth uut (
        .clk(clk),
        .rst(rst),
        .trig(trig),
        .adsr_ai(ADSR_AI),
        .adsr_di(ADSR_DI),
        .adsr_s(ADSR_S),
        .adsr_ri(ADSR_RI),
        .osc_count(PULSE_PERIOD_2),
        .filter_a(FILTER_A),
        .filter_b(FILTER_B),
        .data(data)
    );

endmodule