`timescale 1ns/1ps

module synth_tb();

    /*
     * ADSR: one cycle = 12.8ms. T = N * 12.8ms
     *                 => count = 256/N
     *                 => 50 ms => N=4 => ai = 256/4= 64
     * 100ms decay: but SUSTAIN at 128 => 128/8 = 16
     * release: 1s => 128/80=2
     */
    localparam ADSR_AI = 64;
    localparam ADSR_DI = -10;
    localparam ADSR_S = 125;
    localparam ADSR_RI = -4;
    localparam PULSE_PERIOD_2 = 66; // 303 Hz
    /* https://dsp.stackexchange.com/a/54088 (3)
     * a = -y + sqrt(y^2 + 2y)
     * y = 1-cos(wc)
     * => fc = 1000 => a = 0.26773053164
     * *2^16 => 17546
     */
    localparam FILTER_A = 8'd101; // * 2^-8
    localparam FILTER_B = 8'hFF - FILTER_A; // * 2^-8

    wire data;
    reg clk;
    reg rstn, trig;

    initial begin
        $dumpfile("build/sim/synth_tb.vcd");
        $dumpvars();

        clk = 0;
        #1000000000 $finish;
    end
    always #5 clk = ~clk;

    initial begin
        rstn = 1'b0;
        trig = 1'b0;
        #50 rstn = 1'b1;
        #100 trig = 1'b1;

        #500000000 trig = 1'b0;
    end

    synth uut (
        .clk(clk),
        .rstn(rstn),
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