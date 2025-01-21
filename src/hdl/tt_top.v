/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire rst, trig, data;
    assign rst = ~rst_n;
    assign trig = ui_in[0];
    assign uo_out[0] = data;

    // List all unused inputs to prevent warnings
    wire _unused = &{ena, ui_in[7:1], uio_in[7:0], 1'b0};

    // All output pins must be assigned. If not used, assign to 0.
    assign uio_out = 0;
    assign uio_oe = 0;
    assign uo_out[7:1] = 0;

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
