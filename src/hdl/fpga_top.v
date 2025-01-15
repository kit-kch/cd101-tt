`timescale 1ns/1ps

module fpga_top(
    input clk,
    input rst,
    input trig,
    output data
);

    /*
     * ADSR: one cycle = 12.8ms. T = N * 12.8ms
     *                 => count = 256/N
     *                 => 50 ms => N=4 => ai = 256/4= 64
     * 100ms decay: but SUSTAIN at 128 => 128/8 = 16
     * release: 1s => 128/80=2
     */
    localparam ADSR_AI = 64;
    localparam ADSR_DI = 16;
    localparam ADSR_S = 128;
    localparam ADSR_RI = 2;
    localparam PULSE_PERIOD_2 = 66; // 303 Hz
    /* https://dsp.stackexchange.com/a/54088 (3)
     * a = -y + sqrt(y^2 + 2y)
     * y = 1-cos(wc)
     * => fc = 1000 => a = 0.26773053164
     * *2^16 => 17546
     */
    localparam FILTER_A = 16'd17546; // * 2^-16
    localparam FILTER_B = 16'hFFFF - FILTER_A; // * 2^-16

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